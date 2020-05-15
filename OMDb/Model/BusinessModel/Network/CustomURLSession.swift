//
//  CustomURLSession.swift
//  OMDb
//
//  Created by Daniel Torres on 5/6/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

struct SessionsCoordinator {
    static let cacheSession = URLSession.shared.cacheSession
    static let defaultSession = URLSession.shared.normalSession
}

extension URLSession {
    var cacheSession : URLSession {
        let defaultConfiguration = URLSessionConfiguration.default
        
        // Configuring caching behavior for the default session
        let cachesDirectoryURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let cacheURL = cachesDirectoryURL.appendingPathComponent("CacheSession")
        let diskPath = cacheURL.path
        
        let cache = URLCache(memoryCapacity: 10 * 1024 * 1024, diskCapacity: 120 * 1024 * 1024, diskPath: diskPath)
        defaultConfiguration.urlCache = cache
        defaultConfiguration.requestCachePolicy = .returnCacheDataElseLoad
        defaultConfiguration.httpShouldUsePipelining = false
        
        return URLSession(configuration: defaultConfiguration)
    }
    
    var normalSession : URLSession {
        let defaultConfiguration = URLSession.shared.configuration
        
        defaultConfiguration.httpShouldUsePipelining = true
        defaultConfiguration.waitsForConnectivity = true
        
        return URLSession(configuration: defaultConfiguration)
    }
}
