//
//  OMBDB_API.swift
//  OMDb
//
//  Created by Daniel Torres on 4/4/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

protocol OMBDB_API_Contract {
    func getMedia(searchTerm: String, type: MediaType?,
                  closure: @escaping ([Media]?) -> ())
    func getMediaDict(byTitle: String,
                  closure: @escaping ([String: AnyObject]?) -> ())
    func getMedia(byTitle: String,
                  closure: @escaping (MediaDetailsProtocol?) -> ())
    func getMediaBy(id: String,
                  closure: @escaping (MediaDetailsProtocol?) -> ())
}

class OMBDB_API: NSObject, API, OMBDB_API_Contract {

    private var session: URLSession
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func getMedia(searchTerm: String, type: MediaType? = nil,
                  closure: @escaping ([Media]?) -> ()) {
        
        executeDataRequestWithCustomSession(
            session: session,
            request: OMDBRequestFactory.searchMedia(term: searchTerm, type: type).makeRequest())
        { (data, response) in
            
            guard let data = data else{
                return
            }
            closure(OMBDB_API.parseListMediaData(data))
        }
    }
    
    func getMediaDict(byTitle: String, closure: @escaping ([String: AnyObject]?) -> ()) {
        executeDataRequestWithCustomSession(
            session: session,
            request: OMDBRequestFactory.searchDetailMedia(byTitle: byTitle).makeRequest())
        { (data, response) in
            
            guard let data = data else{
                return
            }
            closure(OMBDB_API.parseDetailMediaData(data))
        }
    }
    
    func getMediaBy(id: String, closure: @escaping (MediaDetailsProtocol?) -> ()) {
        executeDataRequestWithCustomSession(
            session: session,
            request: OMDBRequestFactory.searchDetailMediaById(id: id).makeRequest())
        { (data, response) in
            guard let data = data else{
                return
            }
            closure(OMBDB_API.parseMediaDetailData(data))
        }
    }
    
    func getMedia(byTitle: String, closure: @escaping (MediaDetailsProtocol?) -> ()) {
        executeDataRequestWithCustomSession(
            session: session,
            request: OMDBRequestFactory.searchDetailMedia(byTitle: byTitle).makeRequest())
        { (data, response) in
            
            guard let data = data else{
                return
            }
            closure(OMBDB_API.parseMediaDetailData(data))
        }
    }
    
    static func parseListMediaData(_ data: Data) -> [Media]? {
        let jsondecoder = JSONDecoder()
        guard let mediaList = try? jsondecoder.decode(SearchMedia.self, from: data) else {
            return nil
        }
        return mediaList.media
    }
    
    static func parseMediaDetailData(_ data: Data) -> MediaDetailsProtocol? {
        let jsondecoder = JSONDecoder()
        guard let media = try? jsondecoder.decode(MediaStruct.self, from: data), let type = media.type else {
            return nil
        }
        
        switch type {
        case .series:
            return try? jsondecoder.decode(SeriesDetails.self, from: data)
        case .movie:
            return try? jsondecoder.decode(MovieDetails.self, from: data)
        case .episode:
            return nil
        }
    }
    
    static func parseDetailMediaData(_ data: Data) -> [String: AnyObject]? {
        guard var detailDictMedia = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)  as? [String: AnyObject] else {
            return nil
        }
        
        detailDictMedia.removeValue(forKey: "Ratings")
        detailDictMedia.removeValue(forKey: "Response")
        detailDictMedia.removeValue(forKey: "Poster")
        
        return detailDictMedia
    }
}
