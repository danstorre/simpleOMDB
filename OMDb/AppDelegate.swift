//
//  AppDelegate.swift
//  OMDb
//
//  Created by Daniel Torres on 4/4/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
   
    // MARK: UISceneSession Lifecycle
    var sessionObservers: ObserverMediator?
    var session: SessionProtocol?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        session = Session(user: UserNotLogged())
        sessionObservers = SessionObserverMediator()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let mainTabBarViewController = storyboard
            .instantiateViewController(withIdentifier: "MainTabBarVC") as? UITabBarController,
            let searchVc = mainTabBarViewController.viewControllers?[0] as? ViewController,
            let profileVC = mainTabBarViewController.viewControllers?[0] as? ProfileViewController {
            
            searchVc.session = session
            profileVC.session = session
            sessionObservers?.addObserver(observer: profileVC)
            session?.observer = sessionObservers
            application.windows[0].rootViewController = mainTabBarViewController
            application.windows[0].makeKeyAndVisible()
        }
        
        return true
    }

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

    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
      return GIDSignIn.sharedInstance().handle(url)
    }
    
    
}

