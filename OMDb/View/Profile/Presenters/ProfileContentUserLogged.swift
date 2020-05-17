//
//  ProfileContentUserLogged.swift
//  OMDb
//
//  Created by Daniel Torres on 5/16/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit
import GoogleSignIn

class ProfileContentUserLogged: NSObject, ProfilePresenterPreparator, ProfilePresenterDelegate {
    
    var contentView: UIView?
    var navigationController: UINavigationController?
    var profileUserloggedPresenter: ProfilePresenterProtocol?
    var session: SessionProtocol?
    
    init(navigationController: UINavigationController?,
         session: SessionProtocol?) {
        self.navigationController = navigationController
        self.session = session
        super.init()
    }
    
    func prepareContentView() {
        
        guard let profileUserloggedPresenter = profileUserloggedPresenter,
            let contentView = contentView,
            let user = session?.user else {
            return
        }
        profileUserloggedPresenter.profileView.alpha = 0
        self.navigationController?.navigationBar.alpha = 0
        contentView.addSubview(profileUserloggedPresenter.profileView)
        profileUserloggedPresenter.profileView.frame = contentView.bounds
        profileUserloggedPresenter.profileView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        profileUserloggedPresenter.updateProfile(with: user)
        self.navigationController?.isNavigationBarHidden = false
        
        showAnimation() {_ in}
    }
    
    func hideAnimation(completionHandler: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: 0.3, animations: {
            self.profileUserloggedPresenter?.profileView.alpha = 0
            self.navigationController?.navigationBar.alpha = 0
        }) { (terminated) in
            self.profileUserloggedPresenter?.profileView.removeFromSuperview()
            self.navigationController?.isNavigationBarHidden = true
            completionHandler(terminated)
        }
    }
    
    func showAnimation(completionHandler: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: 0.6, animations: {
            self.navigationController?.navigationBar.alpha = 1
            self.profileUserloggedPresenter?.profileView.alpha = 1
        }) { (terminated) in
            completionHandler(terminated)
        }
    }
    
    func accepts(user: User) -> Bool {
        return user is Profile
    }
    
    func pressedButtonLogout() {
        GIDSignIn.sharedInstance()?.disconnect()
    }
    
}
