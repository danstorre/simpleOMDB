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
        activeContentPreparator?.hideAnimation()
        activeContentPreparator = contentPreparators.first(where: { return $0.accepts(user: user)})
        activeContentPreparator?.prepareContentView()
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


class ProfileContentUserNotLogged: NSObject, ProfilePresenterPreparator, ProfilePresenterDelegate {
    
    var contentView: UIView
    var profileUserNotloggedPresenter: ProfileUserNotLoggedPresenterProtocol
    var navigationController: UINavigationController?
    
    init(contentView: UIView,
         navigationController: UINavigationController?,
         profileUserNotloggedPresenter: ProfileUserNotLoggedPresenterProtocol) {
        self.contentView = contentView
        self.profileUserNotloggedPresenter = profileUserNotloggedPresenter
        self.navigationController = navigationController
        super.init()
    }
    
    func prepareContentView() {
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
        
        showAnimation()
    }
    
    func hideAnimation() {
        UIView.animate(withDuration: 0.3, animations: {
                   self.profileUserNotloggedPresenter.profileNotLoggedView.alpha = 0
               }) { (_) in }
    }
    
    
    func showAnimation() {
        self.profileUserNotloggedPresenter.profileNotLoggedView.alpha = 1
    }
    
    func accepts(user: User) -> Bool {
        return user is UserNotLogged
    }
    
    @objc
    func loginWithGoogleButton(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.presentingViewController = navigationController
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    func pressedButtonLogout() {
        GIDSignIn.sharedInstance()?.disconnect()
    }
}

class ProfileContentUserLogged: NSObject, ProfilePresenterPreparator {
    
    var contentView: UIView
    var navigationController: UINavigationController?
    var profileUserloggedPresenter: ProfilePresenterProtocol
    var session: SessionProtocol?
    
    init(contentView: UIView,
         navigationController: UINavigationController?,
         profileUserloggedPresenter: ProfilePresenterProtocol,
         session: SessionProtocol?) {
        self.contentView = contentView
        self.navigationController = navigationController
        self.profileUserloggedPresenter = profileUserloggedPresenter
        self.session = session
        super.init()
    }
    
    func prepareContentView() {
        self.profileUserloggedPresenter.profileView.alpha = 0
        self.navigationController?.navigationBar.alpha = 0
        contentView.addSubview(self.profileUserloggedPresenter.profileView)
        self.profileUserloggedPresenter.profileView.frame = contentView.bounds
        self.profileUserloggedPresenter.profileView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        if let user = session?.user {
            self.profileUserloggedPresenter.updateProfile(with: user)
        }
        self.navigationController?.isNavigationBarHidden = false
        
        showAnimation()
    }
    
    func hideAnimation() {
        UIView.animate(withDuration: 0.3, animations: {
            self.profileUserloggedPresenter.profileView.alpha = 0
            self.navigationController?.navigationBar.alpha = 0
        }) { (true) in
            self.profileUserloggedPresenter.profileView.removeFromSuperview()
            self.navigationController?.isNavigationBarHidden = true
        }
    }
    
    func showAnimation() {
        UIView.animate(withDuration: 0.6) {
            self.navigationController?.navigationBar.alpha = 1
            self.profileUserloggedPresenter.profileView.alpha = 1
        }
    }
    
    func accepts(user: User) -> Bool {
        return user is Profile
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
        navigationController?.isNavigationBarHidden = true
        contentPreparator.prepareContentView()
    }
}

