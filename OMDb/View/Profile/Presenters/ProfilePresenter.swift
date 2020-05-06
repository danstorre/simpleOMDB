//
//  ProfilePresenter.swift
//  OMDb
//
//  Created by Daniel Torres on 5/4/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

protocol ProfilePresenterProtocol: NSObject {
    var profileHeader: ProfileHeaderProtocol {get set}
    var logOutButton: NormalButtonProtocol {get set}
    var profileView: ProfileLoggedViewProtocol {get set}
    var delegate: ProfilePresenterDelegate {get set}
    func updateProfile(with: User)
}

protocol ProfilePresenterDelegate {
    func pressedButtonLogout()
}

class ProfilePresenter: NSObject, ProfilePresenterProtocol {
    var profileHeader: ProfileHeaderProtocol
    var logOutButton: NormalButtonProtocol
    var profileView: ProfileLoggedViewProtocol
    var delegate: ProfilePresenterDelegate
    
    init(delegate: ProfilePresenterDelegate) {
        self.profileHeader = ProfileHeader(frame: .zero)
        self.logOutButton = ButtonFactory.button(for: .normalButton(text: "logout",
                                                                    color: UIColor(named: "DestructiveColor")!))
        self.profileView = ProfileLoggedView(frame: .zero)
        self.delegate = delegate
        super.init()
        setUp()
    }
    
    private func setUp() {
        profileHeader.titleLabel.attributedText = TextFactory.attributedText(for: .body2(string: ""))
        profileHeader.descriptionLabel.attributedText = TextFactory.attributedText(for: .body2(string: ""))
        profileHeader.profileImageView.image = UIImage()
        logOutButton.button.addTarget(self, action: #selector(logOutButtonPressed), for: .touchUpInside)
    }
    
    @objc
    private func logOutButtonPressed() {
        delegate.pressedButtonLogout()
    }
    
    func updateProfile(with user: User) {
        profileHeader.titleLabel.attributedText = TextFactory.attributedText(for: .body(string: user.name))
        profileHeader.descriptionLabel.attributedText = TextFactory.attributedText(for: .body2(string: user.email))        
        ImageDownloader.getImageFrom(urllink: user.urlImageProfile) { [weak self] (profileImage) in
            self?.profileHeader.profileImageView.image = profileImage
        }
        profileHeader.bounds.size.height = 127
        profileHeader.profileImageView.contentMode = .scaleAspectFit
        profileHeader.profileImageView.layer.cornerRadius = profileHeader.profileImageView.bounds.size.height / 2
        profileView.tableView.tableHeaderView = profileHeader
        profileView.tableView.tableFooterView = UIView()
        
        logOutButton.bounds.size.height = 56
        
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        profileView.addSubview(logOutButton)
        let heightLCFromlogOutButton = logOutButton.heightAnchor.constraint(equalToConstant: 48)
        let leadingLClogOutButton = logOutButton.leadingAnchor.constraint(equalTo: profileView.leadingAnchor, constant: 20)
        let trailingLClogOutButton = logOutButton.trailingAnchor.constraint(equalTo: profileView.trailingAnchor, constant: -20)
        let bottomLCFromlogOutButton = logOutButton.bottomAnchor.constraint(equalTo: profileView.bottomAnchor, constant: -36)
        let topLCfromlogOutButton = logOutButton.topAnchor.constraint(equalTo: profileView.tableView.bottomAnchor, constant: 0)
        
        NSLayoutConstraint.activate([heightLCFromlogOutButton,
                                     leadingLClogOutButton,
                                     trailingLClogOutButton,
                                     bottomLCFromlogOutButton,
                                     topLCfromlogOutButton])
        
        profileView.setNeedsLayout()
        profileView.layoutIfNeeded()
    }
}


