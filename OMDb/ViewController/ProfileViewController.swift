//
//  ProfileViewController.swift
//  OMDb
//
//  Created by Daniel Torres on 4/21/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet var userNameLabel: UILabel!
    var session: SessionProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        session?.user = Profile(id: "1", email: "q@gmail.com", name: "Daniel")
    }
    
}

extension ProfileViewController: PropertyObserver {
    func didChange(propertyName: String, oldPropertyValue: Any?) {
    }
    
    func willChange(propertyName: String, newPropertyValue: Any?) {
        if propertyName == Session.SessionKeys.userKey, let user = newPropertyValue as? User {
            userNameLabel.text = "Your name is \(user.name)"
            print("userNameLabel as changed to \(user.name)")
        }
    }
}
