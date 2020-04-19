//
//  RequestFactory.swift
//  OMDb
//
//  Created by Daniel Torres on 4/4/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

protocol RequestMaker {
    
    var host: String { get }
    var scheme: String { get }
    var httpMethod: String { get }
    var path: String { get }
    var urlComponents: URLComponents { get }
    var queryItems: [URLQueryItem]? { get }
    var httpBody: Data? {get}
    var headers: [String: String]? { get }
    
    func makeRequest() -> URLRequest
}
