//
//  API_Interface.swift
//  OMDb
//
//  Created by Daniel Torres on 4/4/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

protocol API{
    func executeRequest(request: URLRequest, finishedBlock: @escaping ((Any?)->Void))
    func executeDataRequestWithCustomSession(session: URLSession,
                                             request: URLRequest,
                                             finishedBlock: @escaping ((Data?, URLResponse?)->Void))
}

extension API{
    func executeRequest(request: URLRequest,
                        finishedBlock: @escaping ((Any?)->Void)){
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else{
                print("error making a data task \(error.debugDescription)")
                finishedBlock(nil)
                return
            }
            
            finishedBlock(data)
        }
        
        task.resume()
    }
    
    func executeDataRequestWithCustomSession(session: URLSession,
                                             request: URLRequest,
                                             finishedBlock: @escaping ((Data?, URLResponse?)->Void)){
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else{
                print("error making a data task \(error.debugDescription)")
                finishedBlock(nil, response)
                return
            }
            
            guard let data = data else {
                print("there is no data from data task")
                finishedBlock(nil, response)
                return
            }
            
            finishedBlock(data, response)
        }
        
        task.resume()
    }
}
