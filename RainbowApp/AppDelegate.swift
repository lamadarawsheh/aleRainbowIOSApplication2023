//
//  AppDelegate.swift
//  RainbowApp
//
//  Created by Lama Darawsheh on 16/03/2023.
//

import UIKit
import Rainbow
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let appId:String = "797c85b0c3ee11edb15759358f91b00c"          // Fill with your application id
    let appSecret:String = "SQ4CCd99cs2M0R9A4fZQWdGcn6B5gL65kq3CPcRqLLvbJp9FaZiK2N3lbbyjuhuS"  // Fill with your secret key



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        ServicesManager.sharedInstance()?.setAppID(appId, secretKey: appSecret)
        let isConnected:Bool = ServicesManager.sharedInstance()?.loginManager.isConnected ?? false
        NSLog("IsConnected: %@", isConnected ? "true" : "false")

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

