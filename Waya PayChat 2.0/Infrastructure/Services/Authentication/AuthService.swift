//
//  AuthService.swift
//  Waya PayChat 2.0
//
//  Created by Mark Boleigha on 15/06/2021.
//

import Foundation
import Signals

var auth = AuthService.shared()

enum AuthStatus {
    case locked
    case appUnlocked
    case walletUnlocked
}

/// Basic authentication and session management
final class AuthService {
    private static var instance: AuthService?
    var data: AuthData!
    var prefs: Prefs!
    let userDefault = UserDefaults.standard
    private var loading = false
    var loaded = Signal<()>()
    
    // returns verifications required
    var profileReloaded = Signal<()>()
    
    // fire a signal anytime the app session times out, when pin is verified or when app loads from background. only view controllers that implement this in their ViewDidAppear method should listen
    let appLockChanged = Signal<(AuthStatus)>()
    
    var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter
    }()
    
    static func shared() -> AuthService {
        if instance == nil {
            instance = AuthService()
            instance?.load()
        }
        return instance!
    }
    
    // Optional async so nobody waits for this function to return
    func load() {
        // because this function runs in async, race conditions might cause loading to fire multiple times. this ensures we only fire once by keeping the task locked until one completes.
        guard self.loading == false else {
            return
        }
        self.loading = true
        if let data = userDefault.value(forKey: "AUTH_DATA") as? Data, let prefs = userDefault.value(forKey: "prefs") as? Data {
    
            guard let defaults = try? JSONDecoder().decode(AuthData.self, from: data), let settings = try? JSONDecoder().decode(Prefs.self, from: prefs) else {
                return // put breakpoint here. something is failing on the auth level
            }
            self.loadDefaults(defaults: defaults, settings: settings)
        } else {
            self.setupData()
        }
        
    }
    
    func loadDefaults(defaults: AuthData, settings: Prefs) {
        self.data = defaults
        self.prefs = settings
        // safety check here
        if data.loggedIn == true && data.userId != nil && data.profile != nil && data.token != nil {
            // check if user session is valid on the backend
            DispatchQueue.main.async {
                self.checkSessionAndContinue()
            }
        } else {
            self.data.appLockStatus = .locked
            self.loaded => ()
            self.loading = false // unlock loading for other parts of the app
        }
        
    }
    
    private func checkSessionAndContinue() {
        
        let request = NetworkRequest(endpoint: .auth(.tokenValidate), method: .post, encoding: .json, body: [:])
        Request.shared.fetch(request) { (status, _ response: Response<UserValidResponse>?) in
            switch status {
            case .success:
                guard let response = response else {
                    return
                }
                if let user = response.data {
                    self.data.profile?.emailVerified = user.emailVerified
                    self.data.profile?.phoneVerified = user.phoneVerified
                    self.toggleLock(status: .appUnlocked) // unlock app first, then wallet next
                    //unlock wallet if session hasn't timed out
                    if !self.sessionTimedOut() {
                        self.toggleLock(status: .walletUnlocked)
                    }
                }
                self.loaded => ()
                self.refreshProfile()
                self.loading = false
            case .failed(let error):
                if error == NetworkError.unauthenticated {
                    self.logout()
                }
                self.loaded => ()
                break
            }
            self.loading = false
        }
    }
    
    func setupData() {
        let defaultData = AuthData(onboarding: false)
        let defaultSettings = Prefs(defaultView: nil, font_size: .medium)
        self.data = defaultData
        do {
            let data = try JSONEncoder().encode(defaultData)
            let settings = try JSONEncoder().encode(defaultSettings)
            userDefault.set(data, forKey: "AUTH_DATA")
            userDefault.set(settings, forKey: "prefs")
        } catch {
//            completion() // breakpoint here to debug fresh installs
        }
        self.loaded => ()
        self.loading = false
    }
    
    
    func sessionTimedOut() -> Bool {
        if data.last_active == nil || data.loggedIn == false {
           return true
        }
       
        let timeDate = dateFormatter.date(from: data.last_active!)!
        let difference = Int(Date().timeIntervalSince(timeDate))
        
        if difference >= 120 {
            self.toggleLock(status: .appUnlocked)
            return true
        } else {
            self.toggleLock(status: .walletUnlocked) // make sure wallet is unlocked
            return false
        }
    }
    
    func updateLocalPrefs() {
        // Make sure user isn't nil, this is to prevent JSONEncoder() from crashing on newly logged in user
        if data.profile != nil {
            if data.appLockStatus == .walletUnlocked {
                // update the timestamp
                let now = dateFormatter.string(from: Date())
                self.data.last_active = now
            }
        }
        
        let encoded = try! JSONEncoder().encode(self.data)
        let settings = try! JSONEncoder().encode(self.prefs)
        userDefault.set(encoded, forKey: "AUTH_DATA")
        userDefault.set(settings, forKey: "prefs")
        self.profileReloaded =>  () // something was changed and saved, fire a signal to all listening views
    }
    
    func toggleLock(status: AuthStatus) {
        self.data.appLockStatus = status
        self.updateLocalPrefs()
        self.appLockChanged => (status)
    }
       
    func appEnteringBackgroundOrTerminating() {
        let status: AuthStatus = (self.data.token != nil) ? .appUnlocked : .locked
        self.toggleLock(status: status)
    }
    
    //TODO
    func refreshProfile() {
        let viewModel = AuthViewModelImpl()
        viewModel.getUserWayagramProfile()
        
        let profileModel = ProfileViewModelImpl()
        profileModel.getUserProfileById(userId: profileModel.userId) { (_) in
            auth.updateLocalPrefs()
        }
        
        let walletViewModel = WalletViewModelImpl()
        walletViewModel.getUserWallets()
        
        walletViewModel.getUserBankAccounts() { (_ response: ResponseList<BankResponse>?, error) in
            if let banks = response?.data {
                if banks.count > 0 {
                    if self.data.accounts == nil {
                        self.data.accounts = PaymentAccounts()
                    }
                    self.data.accounts?.banks = banks
                    if self.data.completedKyc?.firstIndex(of: .accountLinked) == nil {
                        self.data.completedKyc?.append(.accountLinked)
                    }
                } else {
                    if let index = self.data.completedKyc?.firstIndex(of: .accountLinked){
                        self.data.completedKyc?.remove(at: index)
                    }
                    self.data.accounts?.banks = nil
                }
            }
            self.updateLocalPrefs()
        }
                
        walletViewModel.getUserBankCard(userId: String(data.userId!)) { (result) in
            switch result {
            case .success(let cardResponse):
                if let cards = cardResponse as? [CardResponse]{
                    if cards.count > 0 {
                        if self.data.accounts == nil {
                            self.data.accounts = PaymentAccounts()
                        }
                        if let kyc = self.data.completedKyc, let _ = kyc.firstIndex(of: .cardLinked) {
                            self.data.completedKyc!.append(.cardLinked)
                        }
                        self.data.accounts?.cards = cards
                    } else {
                        if let index = self.data.completedKyc?.firstIndex(of: .cardLinked){
                            self.data.completedKyc!.remove(at: index)
                        }
                        self.data.accounts?.cards = nil
                    }
                }
            case .failure(_):
                break
            }
            self.updateLocalPrefs()
            self.profileReloaded =>  ()
        }
        checkBVN()
    }
            
            
    func checkBVN() {
        guard data.completedKyc?.firstIndex(of: .bvnLinked) == nil, data.profile != nil else {
            return
        }
        
        let user = String(data.profile!.userId)
        let request = NetworkRequest(endpoint: .kyc(.isBvnLinked(user: user)), method: .get, encoding: .urlJson, body: [:])

        Request.shared.fetch(request) { (status, _ response: Response<String>?) in
            switch status {
            case .success:
                if let bvn_response = response, bvn_response.status == true {
                    if self.data.completedKyc?.firstIndex(of: .bvnLinked) == nil {
                        self.data.completedKyc?.append(.bvnLinked)
                    }
                } else {
                    if let index = self.data.completedKyc?.firstIndex(of: .bvnLinked){
                        self.data.completedKyc!.remove(at: index)
                    }
                }
            case .failed(_):
                return
            }
        }
    }
    func logout() {
        self.data.loggedIn = false
        self.data.token = nil
        self.data.userId = nil
        self.data.profile = nil
        self.data.last_active = nil
        self.toggleLock(status: .locked)
    }
}
