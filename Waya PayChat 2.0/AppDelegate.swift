//
//  AppDelegate.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 2/15/21.
//

import IQKeyboardManagerSwift
import Firebase

//@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let dataController = DataController(modelName: "WayaPayCoreData")
    let appDIContainer = AppDIContainer()
    var window: UIWindow?
    var rootController: UINavigationController {
        return self.window!.rootViewController as! UINavigationController  //UINavigationController()
    }
    
    private  var applicationCoordinator: Coordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        AppAppearance.setupAppearance()
        IQKeyboardManager.shared.enable = true
        
        window = UIWindow(frame: UIScreen.main.bounds)
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light // opt out of dark mode for now. to be removed later
        }
        let navigationController = UINavigationController()
        
        let notification = launchOptions?[.remoteNotification] as? [String: AnyObject]
        let deepLink = DeepLinkOption.build(with: notification)
        dataController.load()
        
        // splashscreen has a max display time of 3 seconds, so we let authentication loading and session checks to happen async while we display the splashscreen.
        auth.loaded.subscribeOnce(with: self) {
            DispatchQueue.main.async {
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
                    timer.invalidate()
                    wallet.load()
                    self.window?.rootViewController = navigationController
                    self.applicationCoordinator   = self.makeCoordinator(navigationController, self.dataController)
                    self.applicationCoordinator?.start(with: deepLink)
                    self.window?.makeKeyAndVisible()
                }
            }
        }
        auth.load()
        
        
        let splashScreen = SplashScreen.controllerFromStoryboard(.splash)
        self.window?.rootViewController = splashScreen
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    private func makeCoordinator(_ rootController : UINavigationController, _ dataController: DataController) -> Coordinator {
        return ApplicationCoordinator(
            router: RouterImp(rootController: self.rootController),
            coordinatorFactory: CoordinatorFactoryImpl(), 
            dataController: dataController, appDIContainer: appDIContainer
        )
    }
    //MARK: Handle push notifications and deep links
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        let dict = userInfo as? [String: AnyObject]
        let deepLink = DeepLinkOption.build(with: dict)
        applicationCoordinator?.start(with: deepLink)
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        let deepLink = DeepLinkOption.build(with: userActivity)
        applicationCoordinator?.start(with: deepLink)
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        saveViewContext()
        auth.appEnteringBackgroundOrTerminating()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        saveViewContext()
        auth.appEnteringBackgroundOrTerminating()
    }
    
    func saveViewContext() {
        try? dataController.viewContext.save()
    }
    
}
