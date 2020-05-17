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
    var contentView: UIView? {get set}
    func prepareContentView()
}

protocol ManagesUser {
    func accepts(user: User) -> Bool
}

protocol ProfilePresenterPreparator: ContentPreprable, ManagesUser, AnimatableAlpha {
}

class ProfileContentPresenter: NSObject, ContentPreprable{
    var contentView: UIView?
    var session: SessionProtocol?
    var contentPreparators: [ProfilePresenterPreparator]
    var activeContentPreparator: ProfilePresenterPreparator?
    
    init(session: SessionProtocol?, contentPreparators: [ProfilePresenterPreparator]) {
        self.session = session
        self.contentPreparators = contentPreparators
        super.init()
        self.activeContentPreparator = contentPreparators.first
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
            self.activeContentPreparator?.contentView = self.contentView
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


class ProfileViewController: UIViewController, HasNavigation {
    var navigationObject: NavigationProtocol?
    var session: SessionProtocol?
    
    @IBOutlet var contentView: UIView!
    
    //contentPreparation
    var contentPreparator: ContentPreprable!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentPreparator.contentView = contentView
        contentPreparator.prepareContentView()
    }
}
