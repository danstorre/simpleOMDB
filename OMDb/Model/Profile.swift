//
//  Profile.swift
//  OMDb
//
//  Created by Daniel Torres on 4/21/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

protocol User {
    var email: String {get set}
    var name: String {get set}
}

class Profile: NSObject, User{
    var id: String
    var email: String
    var name: String
    
    init(id: String, email: String, name: String) {
        self.id = id
        self.email = email
        self.name = name
    }
}


