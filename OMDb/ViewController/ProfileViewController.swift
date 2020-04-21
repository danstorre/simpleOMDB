//
//  ProfileViewController.swift
//  OMDb
//
//  Created by Daniel Torres on 4/21/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit
import GoogleSignIn

class ProfileViewController: UIViewController {

    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var signInButton: GIDSignInButton!
    @IBOutlet var logoutButton: UIButton!
    var session: SessionProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = session?.user {
            let userpresenter = UserPresenterFactory.userPresenter(for: .profileLabel(user: user))
            userNameLabel?.text = userpresenter?.userName
            toggleLogoutButton(user: user)
        }
        GIDSignIn.sharedInstance()?.presentingViewController = self
        signInButton.colorScheme = .light
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.disconnect()
    }
    
    func toggleLogoutButton(user: User){
        logoutButton?.isHidden = user is UserNotLogged
    }
    
}

extension ProfileViewController: PropertyObserver {
    func didChange(propertyName: String, oldPropertyValue: Any?) {
    }
    
    func willChange(propertyName: String, newPropertyValue: Any?) {
        if propertyName == Session.SessionKeys.userKey, let user = newPropertyValue as? User {
            let userpresenter = UserPresenterFactory.userPresenter(for: .profileLabel(user: user))
            userNameLabel?.text = userpresenter?.userName
            print("userNameLabel as changed to \(user.name)")
            toggleLogoutButton(user: user)
        }
        
    }
}
