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

    lazy var profileNotLoggedView: ProfileNotLoggedProtocol = ProfileUserNotLogged(frame: .zero)
    lazy var profile: ProfileLoggedProtocol = ProfileLoggedView(frame: .zero)
    
    var profileNotLoggedViewLoaded: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = session?.user {
            prepareContentView(for: user)
        }
    }
    
    private func prepareContentView(for user: User) {
        switch user  {
        case let x where x is UserNotLogged: prepareUserNotLoggedView()
        case let x where x is Profile: prepareUserLoggedView(for: user)
        default: break
        }
    }
    
    private func prepareUserLoggedView(for user: User) {
        guard let contentView = contentView else {
            return
        }
        for subViews in contentView.subviews {
            subViews.removeFromSuperview()
        }
        
        
    }
    
    private func prepareUserNotLoggedView(){
        guard let contentView = contentView else {
            return
        }
        for subViews in contentView.subviews {
            subViews.removeFromSuperview()
        }
        
        defer {
            contentView.addSubview(profileNotLoggedView)
            profileNotLoggedView.frame = contentView.bounds
            profileNotLoggedView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
        
        guard profileNotLoggedViewLoaded == false else {
            return
        }
        profileNotLoggedView.headLabel.attributedText = TextFactory.attributedText(for: .headerDualColor(string1: "Save here",
                                                                    string2: "\nuse it anywhere.",
                                                                    color: UIColor(named: "Blue1")!))
        profileNotLoggedView.headLabel.numberOfLines = 0
        profileNotLoggedView.headLabel.lineBreakMode = .byWordWrapping
        profileNotLoggedView.headLabel.backgroundColor = .clear
        
        profileNotLoggedView.featuresView.addArrangedSubview(TextFactoryTextBox.textBox(for: .featureTextBox(title: "Take them with you",
                                                                titleColor: UIColor(named: "Blue1")!,
                                                                description:
                                                    "Login with google and save your favorite media, Then, login in any devices to retrieve your saved media.",
                                                                                        image: UIImage(systemName: "folder")!,
                                                                                        iconColor: UIColor(named: "Yellow")!)))
        
        profileNotLoggedView.featuresView.setNeedsLayout()
        profileNotLoggedView.featuresView.layoutIfNeeded()
        
        profileNotLoggedView.descriptionLabel.attributedText = TextFactory.attributedText(for: .body(string: "Login or sign up by clicking the button above."))
        profileNotLoggedView.descriptionLabel.numberOfLines = 0
        profileNotLoggedView.descriptionLabel.lineBreakMode = .byWordWrapping
        profileNotLoggedView.descriptionLabel.backgroundColor = .clear
        
        profileNotLoggedView.descriptionLabel.numberOfLines = 0
        profileNotLoggedView.descriptionLabel.lineBreakMode = .byWordWrapping
        profileNotLoggedView.descriptionLabel.backgroundColor = .clear
        profileNotLoggedView.descriptionLabel.textAlignment = .center
        
        let googleButton = ButtonFactory.button(for: .normalButton(text: "Login with Google")).button
        googleButton.addTarget(self, action: #selector(loginWithGoogleButton), for: .touchUpInside)
        googleButton.translatesAutoresizingMaskIntoConstraints = false
        googleButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        profileNotLoggedView.loginButtons.addArrangedSubview(googleButton)
        
        profileNotLoggedView.loginButtons.setNeedsLayout()
        profileNotLoggedView.loginButtons.layoutIfNeeded()
        
        profileNotLoggedViewLoaded = true
    }
    
    @objc
    func loginWithGoogleButton(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.signIn()
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
            prepareContentView(for: user)
        }
        
    }
}
