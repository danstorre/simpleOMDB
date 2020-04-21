//
//  Session.swift
//  OMDb
//
//  Created by Daniel Torres on 4/21/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation
import GoogleSignIn

protocol SessionProtocol: class{
    var user: User {get set}
    var observer:PropertyObserver? {get set}
}

protocol PropertyObserver : class {
    func willChange(propertyName: String, newPropertyValue: Any?)
    func didChange(propertyName: String, oldPropertyValue: Any?)
}

final class Session: NSObject, SessionProtocol{
    
    init(user: User) {
        self.user = user
    }
    
    weak var observer:PropertyObserver?
    
    enum SessionKeys {
        static let userKey = "user"
    }
    
    var user: User {
        willSet(newValue) {
            observer?.willChange(propertyName: SessionKeys.userKey, newPropertyValue: newValue)
        }
        didSet {
            observer?.didChange(propertyName: SessionKeys.userKey, oldPropertyValue: oldValue)
        }
    }
}

extension Session: GIDSignInDelegate{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        GIDSignIn.sharedInstance().clientID = "215368444628-j924tqlejb6b6a0bl6u3iu47dbegjo2d.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        // Perform any operations on signed in user here.
        let userId = user.userID                  // For client-side use only!
        //        let idToken = user.authentication.idToken // Safe to send to the server
        //        let fullName = user.profile.name
        //        let familyName = user.profile.familyName
        guard let givenName = user.profile.givenName,
            let email = user.profile.email else{
                print("couldn't retrieve user info")
                self.user = UserNotLogged()
                return
        }
        
        let profileFromUserLoggedIn = Profile(id: userId ?? "1", email: email, name: givenName)
        self.user = profileFromUserLoggedIn
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
        self.user = UserNotLogged()
    }
}

protocol ObserverCollection {
    func addObserver(observer: PropertyObserver)
    func removeAll()
}

protocol ObserverMediator: PropertyObserver & ObserverCollection {
}

final class SessionObserverMediator: ObserverMediator {
    
    var sessionObservers: [PropertyObserver]
    init(){
        self.sessionObservers = [PropertyObserver]()
    }
    
    func willChange(propertyName: String, newPropertyValue: Any?) {
        for sessionObserver in sessionObservers {
            sessionObserver.willChange(propertyName: propertyName,
                                       newPropertyValue: newPropertyValue)
        }
    }
    
    func didChange(propertyName: String, oldPropertyValue: Any?) {
        for sessionObserver in sessionObservers {
            sessionObserver.didChange(propertyName: propertyName,
                                      oldPropertyValue: oldPropertyValue)
        }
    }
    
    func addObserver(observer: PropertyObserver) {
        sessionObservers.append(observer)
    }
    
    func removeAll(){
        sessionObservers.removeAll()
    }
    
}