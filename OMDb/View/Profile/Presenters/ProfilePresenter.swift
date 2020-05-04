//
//  ProfilePresenter.swift
//  OMDb
//
//  Created by Daniel Torres on 5/4/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

protocol ProfilePresenterProtocol: NSObject {
    var profileHeader: ProfileHeaderProtocol {get set}
    var logOutButton: NormalButtonProtocol {get set}
    var profileView: ProfileLoggedViewProtocol {get set}
    
    func updateProfile(with: User)
}

class ProfilePresenter: NSObject, ProfilePresenterProtocol {
    var profileHeader: ProfileHeaderProtocol
    var logOutButton: NormalButtonProtocol
    var profileView: ProfileLoggedViewProtocol
    
    override init() {
        self.profileHeader = ProfileHeader(frame: .zero)
        self.logOutButton = ButtonFactory.button(for: .normalButton(text: "logout", color: .red))
        self.profileView = ProfileLoggedView(frame: .zero)
        super.init()
        setUp()
    }
    
    private func setUp(){
        
    }
    
    func updateProfile(with user: User) {
        // set up any
    }
}


