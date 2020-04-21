//
//  Session.swift
//  OMDb
//
//  Created by Daniel Torres on 4/21/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

protocol SessionProtocol: class{
    var user: User {get set}
    var observer:PropertyObserver? {get set}
}

protocol PropertyObserver : class {
    func willChange(propertyName: String, newPropertyValue: Any?)
    func didChange(propertyName: String, oldPropertyValue: Any?)
}

final class Session: SessionProtocol{
    
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

protocol ObserverCollection {
    func addObserver(observer: PropertyObserver)
    func removeAll()
}

final class SessionObserverMediator: PropertyObserver, ObserverCollection {
    
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
