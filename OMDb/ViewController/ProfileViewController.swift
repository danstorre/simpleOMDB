//
//  ProfileViewController.swift
//  OMDb
//
//  Created by Daniel Torres on 4/21/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit
import GoogleSignIn

protocol ContentPreprable {
    func prepareContentView()
}

protocol ManagesUser {
    func accepts(user: User) -> Bool
}

protocol ProfilePresenterPreparator: ContentPreprable, ManagesUser, AnimatableAlpha {
    var contentView: UIView? {get set}
}

class ProfileContentPresenter: NSObject, ContentPreprable{
    var session: SessionProtocol?
    var contentPreparators: [ProfilePresenterPreparator]
    var activeContentPreparator: ProfilePresenterPreparator?
    
    init(session: SessionProtocol?, contentPreparators: [ProfilePresenterPreparator]) {
        self.session = session
        self.contentPreparators = contentPreparators
        super.init()
    }
    
    func prepareContentView() {
        if let user = session?.user {
            prepareContentFor(for: user)
        }
    }
    
    func prepareContentFor(for user: User) {
        activeContentPreparator?.hideAnimation() { [weak self] _ in
            guard let self = self else { return }
            self.activeContentPreparator = self.contentPreparators.first(where: { return $0.accepts(user: user)})
            self.activeContentPreparator?.prepareContentView()
        }
    }
}

extension ProfileContentPresenter: PropertyObserver {
    func didChange(propertyName: String, oldPropertyValue: Any?) {
    }
    
    func willChange(propertyName: String, newPropertyValue: Any?) {
        if propertyName == Session.SessionKeys.userKey, let user = newPropertyValue as? User {
            prepareContentFor(for: user)
        }
    }
}


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
            let contentView = contentView else {
            return
        }
        profileUserloggedPresenter.profileView.alpha = 0
        self.navigationController?.navigationBar.alpha = 0
        contentView.addSubview(profileUserloggedPresenter.profileView)
        profileUserloggedPresenter.profileView.frame = contentView.bounds
        profileUserloggedPresenter.profileView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        if let user = session?.user {
            profileUserloggedPresenter.updateProfile(with: user)
        }
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

class ProfileViewController: UIViewController, HasNavigation {
    var navigationObject: NavigationProtocol?
    var session: SessionProtocol?
    
    @IBOutlet var contentView: UIView!
    
    //contentPreparation
    var contentPreparator: ContentPreprable!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentPreparator.prepareContentView()
    }
}

