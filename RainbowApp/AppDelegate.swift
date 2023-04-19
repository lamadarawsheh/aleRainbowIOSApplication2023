//
//  AppDelegate.swift
//  RainbowApp
//
//  Created by Lama Darawsheh on 16/03/2023.
//

import UIKit
import Rainbow  
@main
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {
    
    let appId:String = "10a83170c3f711edab9089d10662fe49"
    let appSecret:String = "YpJSxDbUGf4PxCkt5DognoJjzRO0ecNzYfNVOd44FelEr7ZNmm6q3B2ndSxXVfBZ"
    
    @objc private func didChangeServer(notification: NSNotification) {
        // Do something once the server hostname has been switched to the new one
    }
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeServer(notification:)), name: NSNotification.Name(kLoginManagerDidChangeServer), object: nil)
        ServicesManager.sharedInstance()?.setAppID(appId, secretKey: appSecret)
        if !(ServicesManager.sharedInstance().myUser.server?.isSandboxServer() ?? false)
        {
            NotificationCenter.default.post(name: NSNotification.Name(kLoginManagerDidChangeServer), object: ["serverURL" : "sandbox.openrainbow.com"])
        }
        UNUserNotificationCenter.current().delegate = self
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
        }
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(kLoginManagerDidChangeServer), object: nil)
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound,.banner])
    }
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

