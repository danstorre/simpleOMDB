//
//  UserPresenters.swift
//  OMDb
//
//  Created by Daniel Torres on 4/21/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

protocol UserPresenter {
    var userName: String {get}
    var email: String {get}
}


struct UIBarItemUserPresenter: UserPresenter {
    var user: User
    init(user: User){
        self.user = user
    }
    
    var userName: String {
        if user is UserNotLogged {
            return "Login"
        }
        return "\(user.name)"
    }
    
    var email: String  {
        return user.email
    }
}

struct NormalLabelUserPresenter: UserPresenter {
    var user: User
    init(user: User){
        self.user = user
    }
    
    var userName: String {
        if user is UserNotLogged {
            return "User is not logged in"
        }
        return "Your name is \(user.name)"
    }
    var email: String  {
        return user.email
    }
}

enum UserPresenterOptions {
    case uibaritem(user: User)
    case profileLabel(user: User)
}

enum UserPresenterFactory {
    static func userPresenter(for option: UserPresenterOptions) -> UserPresenter? {

        switch option {
            case .uibaritem(let user):
                return UIBarItemUserPresenter(user: user)
            case .profileLabel(let user):
                return NormalLabelUserPresenter(user: user)
        }
        
    }
}
