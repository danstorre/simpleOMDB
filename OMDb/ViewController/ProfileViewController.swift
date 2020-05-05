//
//  ProfileViewController.swift
//  OMDb
//
//  Created by Daniel Torres on 4/21/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit
import GoogleSignIn

class ProfileViewController: UIViewController, ProfilePresenterDelegate {
   
    var session: SessionProtocol?
    
    @IBOutlet var contentView: UIView!

    //views
    lazy var profile: ProfileLoggedViewProtocol = ProfileLoggedView(frame: .zero)
    
    //presenters
    lazy var profileUserNotloggedPresenter: ProfileUserNotLoggedPresenterProtocol = ProfileUserNotLoggedPresenter()
    lazy var profileUserloggedPresenter: ProfilePresenterProtocol = ProfilePresenter(delegate: self)
    
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
        
        contentView.addSubview(profileUserloggedPresenter.profileView)
        profileUserloggedPresenter.profileView.frame = contentView.bounds
        profileUserloggedPresenter.profileView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        profileUserloggedPresenter.updateProfile(with: user)
        //prepare cell
        //prepare delegate
        //prepare datasource
    
    }
    
    private func prepareUserNotLoggedView(){
        guard let contentView = contentView else {
            return
        }
        for subViews in contentView.subviews {
            subViews.removeFromSuperview()
        }
        let googleButton = ButtonFactory.button(for: .normalButton(text: "Login with Google")).button
        googleButton.addTarget(self, action: #selector(loginWithGoogleButton), for: .touchUpInside)
        googleButton.translatesAutoresizingMaskIntoConstraints = false
        googleButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        profileUserNotloggedPresenter.addButtons([googleButton])
        
        profileUserNotloggedPresenter.profileNotLoggedView.loginButtons.setNeedsLayout()
        profileUserNotloggedPresenter.profileNotLoggedView.loginButtons.layoutIfNeeded()
        
        contentView.addSubview(profileUserNotloggedPresenter.profileNotLoggedView)
        profileUserNotloggedPresenter.profileNotLoggedView.frame = contentView.bounds
        profileUserNotloggedPresenter.profileNotLoggedView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    @objc
    func loginWithGoogleButton(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    func pressedButtonLogout() {
        GIDSignIn.sharedInstance()?.disconnect()
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
