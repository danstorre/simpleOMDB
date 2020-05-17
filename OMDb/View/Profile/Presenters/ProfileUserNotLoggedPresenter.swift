//
//  ProfileUserNotLoggedPresenter.swift
//  OMDb
//
//  Created by Daniel Torres on 5/4/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

protocol ProfileUserNotLoggedPresenterProtocol: class {
    var profileNotLoggedView: ProfileNotLoggedProtocol {get set}
    func addButtons(_: [UIButton])
}

class ProfileUserNotLoggedPresenter: NSObject, ProfileUserNotLoggedPresenterProtocol {
    var profileNotLoggedView: ProfileNotLoggedProtocol
    
    override init() {
        profileNotLoggedView = ProfileUserNotLogged(frame: .zero)
        super.init()
        setUp()
    }
    
    func addButtons(_ buttons: [UIButton]) {
        for button in profileNotLoggedView.loginButtons.arrangedSubviews {
            profileNotLoggedView.loginButtons.removeArrangedSubview(button)
        }
        for newButton in buttons {
            profileNotLoggedView.loginButtons.addArrangedSubview(newButton)
        }
    }
    
    private func setUp() {
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
    }
}
