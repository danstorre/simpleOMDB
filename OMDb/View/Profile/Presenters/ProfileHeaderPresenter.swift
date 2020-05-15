//
//  ProfileHeaderPresenter.swift
//  OMDb
//
//  Created by Daniel Torres on 5/4/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

protocol ProfileHeaderPresenterProtocol {
    var header: ProfileHeaderProtocol {get set}
    func updateProfileHeader(with: User)
    init(header: ProfileHeaderProtocol)
}

class ProfileHeaderPresenter: NSObject, ProfileHeaderPresenterProtocol {
    var header: ProfileHeaderProtocol
    
    required init(header: ProfileHeaderProtocol) {
        self.header = header
    }
    
    func updateProfileHeader(with user: User) {
        //update profile according to user's data.
    }
}


