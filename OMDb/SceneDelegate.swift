//
//  SceneDelegate.swift
//  OMDb
//
//  Created by Daniel Torres on 4/4/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit
import GoogleSignIn

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var sessionObservers: ObserverMediator?
    var sessionUser: SessionProtocol?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        let mySession = Session(user: UserNotLogged())
        sessionUser = mySession
        sessionObservers = SessionObserverMediator()
        
        GIDSignIn.sharedInstance().clientID = "215368444628-j924tqlejb6b6a0bl6u3iu47dbegjo2d.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = mySession
        
        //Order this code properly
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let mainTabBarViewController = storyboard
            .instantiateViewController(withIdentifier: "MainTabBarVC") as? UITabBarController,
            let navVCForSearchVc = mainTabBarViewController.viewControllers?[0] as? NavigationProtocol,
            let searchVc = navVCForSearchVc.viewControllers[0] as? ViewController,
            let profileNav = mainTabBarViewController.viewControllers?[1] as? NavigationProtocol,
            let profileVC = profileNav.viewControllers[0] as? ProfileViewController {
            
            searchVc.session = sessionUser
            searchVc.navigationObject = navVCForSearchVc
            profileVC.session = sessionUser
            profileVC.navigationObject = navVCForSearchVc
            
            //initialize userloggedContentPreparator
            let userloggedContentPreparator = ProfileContentUserLogged(navigationController: profileVC.navigationController,
                                                                       session: sessionUser)
            let profilePresenter = ProfilePresenter(delegate: userloggedContentPreparator)
            userloggedContentPreparator.profileUserloggedPresenter = profilePresenter
            
            //initialize userNotLoggedContentPreparator
            let userNotLoggedContentPreparator = ProfileContentUserNotLogged(navigationController: profileVC.navigationController,
                                                                             profileUserNotloggedPresenter: ProfileUserNotLoggedPresenter())
            
            let contentPreparator = ProfileContentPresenter(session: sessionUser,
                                                            contentPreparators: [userloggedContentPreparator, userNotLoggedContentPreparator])
            
            sessionObservers?.addObserver(observer: contentPreparator)
            profileVC.contentPreparator = contentPreparator
            sessionUser?.observer = sessionObservers
            
            guard let windowScene = scene as? UIWindowScene else { return }
            window = UIWindow(windowScene: windowScene)
            window?.rootViewController = mainTabBarViewController
            window?.makeKeyAndVisible()
            
            
            if let introVC = storyboard
                .instantiateViewController(withIdentifier: "IntroVC") as? IntroViewController {
                mainTabBarViewController.modalPresentationStyle = .overFullScreen
                mainTabBarViewController.present(introVC, animated: true, completion: nil)
            }
        }
        
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
}

