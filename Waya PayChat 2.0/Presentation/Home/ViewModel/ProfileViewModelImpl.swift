//
//  ProfileViewModel.swift
//  Waya PayChat 2.0
//
//  Created by Home on 2/3/21.
//

import Foundation
import Signals

final class ProfileViewModelImpl  {
    
    var myProfile: UserProfile?
    var UserProfiles = [UserProfile]()
    var followerRequest = FollowUserRequest(user_id: "", username: "")
    var profileRepo : ProfileRepository
    let userDefault = UserDefaults.standard
    var userId : String = ""
    var followers = [FollowerViewModelItem]()
    var following = [FollowerViewModelItem]()
    
    // fires whenever a profile update operation is completed, views can listen and implement UI changes
    // Returns (_ status: Bool, _ error: String?)
    var profileUpdated = Signal<(Bool, String?)>()
    
    let bvnRepo = BvnRepositoryImpl()
    
    init(profileRepo: ProfileRepository = ProfileRepositoryImpl()){
        self.profileRepo = profileRepo
        guard let id = auth.data?.userId else {
            self.userId = "0"
            return
        }
        self.userId = String(id)
    }
}


extension ProfileViewModelImpl : ProfileViewModel {
    func updateUserProfile(updateProfileRequest: Dictionary<String, Any>) {
        profileRepo.updateUserProfile(userid: userId, updateUserProfileRequest: updateProfileRequest) { (result) in
            switch(result) {
                case .success(_):
                    self.profileUpdated => (true, nil)
                case .failure(let error):
                    self.profileUpdated => (false, error.localizedDescription)
            }
        }
    }
    
    func uploadProfileImage(data: Data,  completion : @escaping Handler) {
        profileRepo.uploadProfileImage(data: data) { (result) in
           
            switch result{
                case .success(let response):
                    print("response from image upload: \(response)")
                    completion(.success(response))
                case .failure(.custom(let message)):
                    print("response from image upload: \(message)")
                    completion(.failure(.custom(message: message)))
            }
        }
    }
    
    func getUserProfileById(userId : String, completion : @escaping Handler) {
        
        profileRepo.getUserProfile(userId: userId) { (result) in
            switch(result){
                case .success(let response):
                    if let profile = response as? UserProfile{
                        
                        if auth.data.profile == nil {
                            auth.data.profile = profile
                        } else {
                            auth.data.profile?.email =  profile.email
                            auth.data.profile?.phoneNumber = profile.phoneNumber
                            auth.data.profile?.lastName = profile.lastName
                            auth.data.profile?.gender = profile.gender
                            auth.data.profile?.district = profile.district
                            auth.data.profile?.state = profile.state
                            auth.data.profile?.profileId = profile.profileId
                            auth.data.profile?.surname = profile.surname
                            auth.data.profile?.pinCreated = profile.pinCreated
                            auth.data.profile?.address = profile.address
                            auth.data.profile?.city = profile.city
                            auth.data.profile?.profileImage = profile.profileImage
                        }
                    }
                    completion(.success(response))
                case .failure(let errMessage):
                    completion(.failure(.custom(message: errMessage.localizedDescription)))
                    
            }
        }
        self.getOtherDetails(id: userId)
    }
    
    private func getOtherDetails(id: String) {
        profileRepo.getOtherDetailsForCorporate(id: id) { (result) in
            switch result {
            case .success(let details):
                if let details = details as? ProfileResponse {
                    auth.data.profile?.dateOfBirth = details.dateOfBirth
                    auth.data.profile?.smsAlertConfig = details.smsAlertConfig
                    auth.data.profile?.otherDetails = details.otherDetails
                    auth.data.profile?.profileId = details.id
                    auth.data.profile?.referenceCode = details.referenceCode
                    auth.data.profile?.gender = details.gender
                    auth.data.profile?.profileImage = details.profileImage
                    auth.data.profile?.surname = details.surname
                }
//                self.profileUpdated => (true, nil)
                auth.updateLocalPrefs()
            case .failure(let error):
                self.profileUpdated => (false, error.localizedDescription)
            }
        }
    }
    
    func getFriends(page : Int, completion: @escaping Handler){
        profileRepo.getFriends(page: page) {(result) in
            
            switch result{
                case .success(let response):
                    print("The result \(result)")
                    completion(.success(response))
                case .failure(.custom(let message)):
                    completion(.failure(.custom(message: message)))
            }
        }
    }
    
    func getFriendSuggestions(completion: @escaping Handler){
        profileRepo.getFriendSuggestions {(result) in
            
            switch result{
                case .success(let response):
                    print("The result \(result)")
                    completion(.success(response))
                case .failure(.custom(let message)):
                    completion(.failure(.custom(message: message)))
            }
        }
    }
    
    func getAllFriendsRequest(page: Int, completion: @escaping Handler){
        profileRepo.getAllFriendsRequest(page : page) {(result) in
            
            switch result{
                case .success(let response):
                    print("The result \(result)")
                    completion(.success(response))
                case .failure(.custom(let message)):
                    completion(.failure(.custom(message: message)))
            }
        }
    }
    
    func followUsers(followRequest: FollowUserRequest, completion: @escaping Handler){
        profileRepo.followUsers(followRequest: followRequest) {(result) in
            
            switch result{
                case .success(let response):
                    print("The result \(result)")
                    completion(.success(response))
                case .failure(.custom(let message)):
                    completion(.failure(.custom(message: message)))
            }
        }
    }
    
    func unFollowUsers(followRequest: FollowUserRequest, completion: @escaping Handler){
        profileRepo.unFollowUsers(followRequest : followRequest) {(result) in
            
            switch result{
                case .success(let response):
                    print("The result \(result)")
                    completion(.success(response))
                case .failure(.custom(let message)):
                    completion(.failure(.custom(message: message)))
            }
        }
    }
    
    func blockUser(followRequest: FollowUserRequest, completion: @escaping Handler){
        profileRepo.blockUser(followRequest: followRequest) {(result) in
            
            switch result{
                case .success(let response):
                    print("The result \(result)")
                    completion(.success(response))
                case .failure(.custom(let message)):
                    completion(.failure(.custom(message: message)))
            }
        }
    }
    
    func unBlockUser(followRequest: FollowUserRequest, completion: @escaping Handler){
        profileRepo.unBlockUser(followRequest: followRequest) {(result) in
            
            switch result{
                case .success(let response):
                    print("The result \(result)")
                    completion(.success(response))
                case .failure(.custom(let message)):
                    completion(.failure(.custom(message: message)))
            }
        }
    }
    
    func acceptRequest(followRequest: FollowUserRequest, completion: @escaping Handler){
        profileRepo.acceptRequest(followRequest: followRequest) {(result) in
            
            switch result{
                case .success(let response):
                    print("The result \(result)")
                    completion(.success(response))
                case .failure(.custom(let message)):
                    completion(.failure(.custom(message: message)))
            }
        }
    }
    
    func declineRequest(followRequest: FollowUserRequest, completion: @escaping Handler){
        profileRepo.declineRequest(followRequest : followRequest) {(result) in
            
            switch result{
                case .success(let response):
                    print("The result \(result)")
                    completion(.success(response))
                case .failure(.custom(let message)):
                    completion(.failure(.custom(message: message)))
            }
        }
    }
    
    func getReferralCode(completion: @escaping Handler){
        profileRepo.getReferralCode {(result) in
            
            switch result{
                case .success(let response):
                    print("The result \(result)")
                    completion(.success(response))
                case .failure(.custom(let message)):
                    completion(.failure(.custom(message: message)))
            }
        } 
    }
    
    func getFollowers(pageNumber : Int, completion: @escaping Handler){
//        profileRepo.getFollowers(pageNumber: pageNumber) { [weak self](result) in
//            switch result{
//                case .success(let response):
//                    guard let response_   = response as? FollowResponse else {
//                        completion(.success(response))
//                        return
//                    }
//                    if response_.following.count > 0{
//                        let imageGroup = DispatchGroup()
//                        for i in 0...response_.following.count - 1{
//                            self?.followers.append(EntityMapper.createWayagramProfileMapper(wayagramProfile: response_.following[i], imageGroup: imageGroup))
//                        }
//                        imageGroup.notify(queue: .main){
//                            completion(.success(response))
//                        }                    }
//                case .failure(.custom(let message)):
//                    completion(.failure(.custom(message: message)))
//            }
//        }
    }
    func getFollowing(pageNumber : Int, completion: @escaping Handler){
//        profileRepo.getFollowing(pageNumber: pageNumber) {[weak self] (result) in
//            switch result{
//                case .success(let response):
//                    guard let response_   = response as? FollowResponse else {
//                        completion(.success(response))
//                        return
//                    }
//                    if response_.following.count > 0{
//                        let imageGroup = DispatchGroup()
//                        for i in 0...response_.following.count - 1{
//                            self?.following.append(EntityMapper.createWayagramProfileMapper(wayagramProfile: response_.following[i], imageGroup: imageGroup))
//                        } 
//                        imageGroup.notify(queue: .main){
//                            completion(.success(response))
//                        }                    }
//                case .failure(.custom(let message)):
//                    completion(.failure(.custom(message: message)))
//            }
//        }
    }
    
    func getFriends(pageNumber : Int, completion: @escaping Handler){
        profileRepo.getFriends(page: pageNumber) { (result) in
            switch result{
                case .success(let response):
                    print("The result \(result)")
                    completion(.success(response))
                case .failure(.custom(let message)):
                    completion(.failure(.custom(message: message)))
            }
        }
    }

    func fetchMyProfile() {
        
    }
    
    func linkBVN(bvn: String, completion: @escaping Handler) {
        
        let profile = auth.data.profile!
        let request = LinkBvnRequest(bvn: bvn, dob: profile.dateOfBirth!, firstName: profile.firstName, lastName: profile.lastName!, userId: String(profile.userId))
        bvnRepo.linkBvnToAccount(linkBvnRequest: request) { (result) in
            switch result {
            case .success(_):
                completion(.success(nil))
            case .failure(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
    
    func resendOTPForBVN(completion: @escaping Handler) {
        bvnRepo.resendOTP(user: String(auth.data.profile!.userId)) { (result) in
            switch result {
            case .success(_):
                completion(.success(nil))
            case .failure(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
    
    func verifyBVN(request: ValidateBVNRequest, completion: @escaping Handler) {
        bvnRepo.verifyBvnToAccount(otp: request.otp, user: request.user) { (result) in
            switch result {
            case .success(_):
                completion(.success(nil))
            case .failure(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
}
