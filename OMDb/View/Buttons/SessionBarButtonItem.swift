//
//  SessionBarButtonItem.swift
//  OMDb
//
//  Created by Daniel Torres on 4/21/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

protocol SessionBarButtonItem: UIBarButtonItem , PropertyObserver{
    func setStateFor(user: User)
}

class ProfileImageBarButtonItem: UIBarButtonItem, SessionBarButtonItem {
    
    override init() {
        super.init()
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        customView = UIImageView(frame: .zero)
    }
    
    func setStateFor(user: User) {
        guard !(user is UserNotLogged) else {
            UIView.animate(withDuration: 0.3, animations: {
                self.customView?.alpha = 0
            }) { (finished) in
                let loginButton = UIButton(frame: .zero)
                loginButton.setAttributedTitle(TextFactory
                                                .attributedText(for:
                                                    .body(string: "Login",
                                                          withColor: UIColor(named: "Blue1"))),
                                               for: .normal)
                loginButton.addTarget(self.target!, action: self.action!, for: .touchUpInside)
                self.customView = loginButton
                self.customView?.alpha = 0
                UIView.animate(withDuration: 0.6, animations: {
                    self.customView?.alpha = 1
                })
            }
            return
        }
        
        ImageDownloader.getImageFrom(urllink: user.urlImageProfile) { [weak self] (profileImage) in
            UIView.animate(withDuration: 0.3, animations: {
                self?.customView?.alpha = 0
            }) { (finished) in
                guard let self = self else {
                    return
                }
                let button = UIButton(frame: .zero)
                button.setImage(profileImage, for: .normal)
                button.layer.cornerRadius = 20
                button.layer.masksToBounds = true
                self.customView = button
                self.customView?.widthAnchor.constraint(equalToConstant: 40).isActive = true
                self.customView?.heightAnchor.constraint(equalToConstant: 40).isActive = true
                button.addTarget(self.target!, action: self.action!, for: .touchUpInside)
                self.customView?.setNeedsLayout()
                self.customView?.layoutIfNeeded()
                self.customView?.alpha = 0
                UIView.animate(withDuration: 0.6, animations: {
                    self.customView?.alpha = 1
                })
            }
        }
    }
    
    func didChange(propertyName: String, oldPropertyValue: Any?) {
    }
    
    func willChange(propertyName: String, newPropertyValue: Any?) {
        if propertyName == Session.SessionKeys.userKey, let user = newPropertyValue as? User {
            setStateFor(user: user)
        }
    }
    
}
