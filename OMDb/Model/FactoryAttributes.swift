//
//  FactoryAttributes.swift
//  OMDb
//
//  Created by Daniel Torres on 5/14/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation


protocol MediaAttributesMaker {
    var attributes: [String: String] {get}
}

struct MovieMediaAttributesMaker: MediaAttributesMaker {
    let media: MediaDetailsProtocol
    
    var attributes: [String : String] {
        let jsonEncoder = JSONEncoder()
        if let media = media as? MovieDetails, let mediaEncoded = try? jsonEncoder.encode(media),
            let jsonMediaDetails = try? JSONSerialization.jsonObject(with: mediaEncoded, options: .allowFragments),
            let dictMediaDetails = jsonMediaDetails as? [String: String]{
            return dictMediaDetails
        }
        return [String: String]()
    }
}

struct SeriesMediaAttributesMaker: MediaAttributesMaker {
    let media: MediaDetailsProtocol
    
    var attributes: [String : String] {
        let jsonEncoder = JSONEncoder()
        if let media = media as? SeriesDetails, let mediaEncoded = try? jsonEncoder.encode(media),
            let jsonMediaDetails = try? JSONSerialization.jsonObject(with: mediaEncoded, options: .allowFragments),
            let dictMediaDetails = jsonMediaDetails as? [String: String]{
            return dictMediaDetails
        }
        return [String: String]()
    }
}

enum MediaAttributesFactoryOptions {
    case attributes(media: MediaDetailsProtocol)
}

enum MediaAttributesFactory {
    
    static func attributes(for option: MediaAttributesFactoryOptions) -> [String: String]? {
        switch option {
        case .attributes(let media):
            
            switch media.self {
            case let x where x is MovieDetails:
                return MovieMediaAttributesMaker(media: x).attributes
            case let x where x is SeriesDetails:
                return SeriesMediaAttributesMaker(media: x).attributes
            default: return nil
            }
        }
    }
}
