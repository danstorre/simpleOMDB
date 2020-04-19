//
//  Media.swift
//  OMDb
//
//  Created by Daniel Torres on 4/4/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

enum MediaType: String {
    case series = "series"
    case movie = "movie"
    case episode = "episode"
}

struct Media {
    var poster: String
    var name: String
    var year: String
    var type: MediaType? = nil
}

extension Media: Decodable{
    
    enum MediaCodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case poster = "Poster"
        case type = "Type"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: MediaCodingKeys.self)
        
        poster = try values.decode(String.self, forKey: .poster)
        name = try values.decode(String.self, forKey: .title)
        year = try values.decode(String.self, forKey: .year)
        let typeString = try values.decode(String.self, forKey: .type)
        if let typeEnum = MediaType(rawValue: typeString) {
            type = typeEnum
        }
    }
}

struct SearchMedia: Decodable {
    var media: [Media]
    enum MediaSearchContainer: String, CodingKey {
        case search = "Search"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: MediaSearchContainer.self)
        
        media = try values.decode([Media].self, forKey: .search)
    }
}
