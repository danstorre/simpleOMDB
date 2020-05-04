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

    var session: SessionProtocol?
    
    @IBOutlet var contentView: UIView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = session?.user {
        }
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.disconnect()
    }
    
    func toggleLogoutButton(user: User){
    }
    
}

extension ProfileViewController: PropertyObserver {
    func didChange(propertyName: String, oldPropertyValue: Any?) {
    }
    
    func willChange(propertyName: String, newPropertyValue: Any?) {
        if propertyName == Session.SessionKeys.userKey, let user = newPropertyValue as? User {
            print("userNameLabel as changed to \(user.name)")
            toggleLogoutButton(user: user)
        }
        
    }
}
