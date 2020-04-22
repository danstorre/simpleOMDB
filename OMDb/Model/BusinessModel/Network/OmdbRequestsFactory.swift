//
//  OmdbRequestsFactory.swift
//  OMDb
//
//  Created by Daniel Torres on 4/4/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

enum OMDBRequestFactory: RequestMaker{
    case searchMedia(term: String, type: MediaType? = nil)
    case searchDetailMedia(byTitle: String)
    
    var host: String {
        return "www.omdbapi.com"
    }
    
    var scheme: String {
        switch self {
        case .searchMedia, .searchDetailMedia:
            return "http"
        }
    }
    
    var httpMethod: String {
        switch self {
        case .searchMedia, .searchDetailMedia:
            return "GET"
        }
    }
    
    var path: String {
        switch self {
        case .searchMedia, .searchDetailMedia:
            return "/"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .searchMedia(let term, let type):
            var queryItems = [URLQueryItem(name: "apikey", value: "c9b1a0c2"),
                              URLQueryItem(name: "s", value: term)]
            guard let type = type else {
                return queryItems
            }
            queryItems.append(URLQueryItem(name: "type", value: type.rawValue))
            return queryItems
        case .searchDetailMedia(let title):
            let queryItems = [URLQueryItem(name: "apikey", value: "c9b1a0c2"),
                              URLQueryItem(name: "t", value: title)]
            return queryItems
        }
    }
    
    var urlComponents: URLComponents{
        switch self {
        case .searchMedia, .searchDetailMedia:
            var urlComponents = URLComponents()
            urlComponents.scheme = scheme
            urlComponents.host = host
            urlComponents.path = path
            urlComponents.queryItems = queryItems
            return urlComponents
        }
    }
        
    var httpBody: Data?{
        return nil
    }
    
    var headers: [String: String]? {
        return nil
    }
    
    func makeRequest() -> URLRequest {
        switch self {
        case .searchMedia, .searchDetailMedia:
            assert(urlComponents.url != nil)
            var urlRequest = URLRequest(url: urlComponents.url!)
            urlRequest.httpMethod = httpMethod
            urlRequest.httpBody = httpBody
            urlRequest.allHTTPHeaderFields = headers
            return urlRequest
        }
    }
}
