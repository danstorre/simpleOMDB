//
//  File.swift
//  OMDb
//
//  Created by Daniel Torres on 5/16/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit
import GoogleSignIn

class ProfileContentUserNotLogged: NSObject, ProfilePresenterPreparator {
    var contentView: UIView?
    var profileUserNotloggedPresenter: ProfileUserNotLoggedPresenterProtocol
    var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?,
         profileUserNotloggedPresenter: ProfileUserNotLoggedPresenterProtocol) {
        self.profileUserNotloggedPresenter = profileUserNotloggedPresenter
        self.navigationController = navigationController
        super.init()
    }
    
    func prepareContentView() {
        guard let contentView = contentView else {
            return
        }
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
        
        showAnimation() {_ in}
    }
    
    func hideAnimation(completionHandler: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: 0.3, animations: {
                   self.profileUserNotloggedPresenter.profileNotLoggedView.alpha = 0
               }) { (terminated) in
                self.profileUserNotloggedPresenter.profileNotLoggedView.removeFromSuperview()
            completionHandler(terminated)
        }
    }
    
    
    func showAnimation(completionHandler: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: 0.6, animations: {
            self.profileUserNotloggedPresenter.profileNotLoggedView.alpha = 1
        }) { (terminated) in
            completionHandler(terminated)
        }
    }
    
    func accepts(user: User) -> Bool {
        return user is UserNotLogged
    }
    
    @objc
    func loginWithGoogleButton(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.presentingViewController = navigationController
        GIDSignIn.sharedInstance()?.signIn()
    }
    
}
