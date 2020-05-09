//
//  ProfileViewController.swift
//  OMDb
//
//  Created by Daniel Torres on 4/21/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit
import GoogleSignIn

class ProfileViewController: UIViewController, ProfilePresenterDelegate, HasNavigation {
    var navigationObject: NavigationProtocol?
    var session: SessionProtocol?
    
    @IBOutlet var contentView: UIView!

    //views
    lazy var profile: ProfileLoggedViewProtocol = ProfileLoggedView(frame: .zero)
    
    //presenters
    lazy var profileUserNotloggedPresenter: ProfileUserNotLoggedPresenterProtocol = ProfileUserNotLoggedPresenter()
    lazy var profileUserloggedPresenter: ProfilePresenterProtocol = ProfilePresenter(delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
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
        
        UIView.animate(withDuration: 0.3, animations: {
            self.profileUserNotloggedPresenter.profileNotLoggedView.alpha = 0
            
        }) { (true) in
            self.profileUserNotloggedPresenter.profileNotLoggedView.removeFromSuperview()
            
            self.profileUserloggedPresenter.profileView.alpha = 0
            self.navigationController?.navigationBar.alpha = 0
            contentView.addSubview(self.profileUserloggedPresenter.profileView)
            self.profileUserloggedPresenter.profileView.frame = contentView.bounds
            self.profileUserloggedPresenter.profileView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.profileUserloggedPresenter.updateProfile(with: user)
            
            self.navigationController?.isNavigationBarHidden = false
            
            UIView.animate(withDuration: 0.6) {
                self.navigationController?.navigationBar.alpha = 1
                self.profileUserloggedPresenter.profileView.alpha = 1
            }
        }
        
        //prepare cell
        //prepare delegate
        //prepare datasource
    
    }
    
    private func prepareUserNotLoggedView(){
        guard let contentView = contentView else {
            return
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.profileUserloggedPresenter.profileView.alpha = 0
            self.navigationController?.navigationBar.alpha = 0
        }) { (true) in
            self.profileUserloggedPresenter.profileView.removeFromSuperview()
            self.navigationController?.isNavigationBarHidden = true
            
            self.profileUserNotloggedPresenter.profileNotLoggedView.alpha = 0
            let googleButton = ButtonFactory.button(for: .normalButton(text: "Login with Google")).button
            googleButton.addTarget(self, action: #selector(self.loginWithGoogleButton), for: .touchUpInside)
            googleButton.translatesAutoresizingMaskIntoConstraints = false
            googleButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
            self.profileUserNotloggedPresenter.addButtons([googleButton])
            
            self.profileUserNotloggedPresenter.profileNotLoggedView.loginButtons.setNeedsLayout()
            self.profileUserNotloggedPresenter.profileNotLoggedView.loginButtons.layoutIfNeeded()
            
            contentView.addSubview(self.profileUserNotloggedPresenter.profileNotLoggedView)
            self.profileUserNotloggedPresenter.profileNotLoggedView.frame = contentView.bounds
            self.profileUserNotloggedPresenter.profileNotLoggedView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            UIView.animate(withDuration: 0.6) {
                self.profileUserNotloggedPresenter.profileNotLoggedView.alpha = 1
            }
        }
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
