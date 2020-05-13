//
//  Media.swift
//  OMDb
//
//  Created by Daniel Torres on 4/4/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

protocol Sanitazable {
    associatedtype T
    func sanitize() -> [T]
}


enum MediaType: String, Encodable {
    case series = "series"
    case movie = "movie"
    case episode = "episode"
    
    var description: String {
        switch self {
        case .episode:
            return "Episodes"
        case .movie:
            return "Movies"
        case .series:
            return "Series"
        }
    }
}

protocol Media: Codable {
    var poster: String {get set}
    var name: String {get set}
    var year: String {get set}
    var type: MediaType? {get set}
}

struct MediaStruct : Media {
    var poster: String
    var name: String
    var year: String
    var type: MediaType? = nil
    
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
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: MediaCodingKeys.self)
        try container.encode(poster, forKey: .title)
        try container.encode(name, forKey: .year)
        try container.encode(year, forKey: .poster)
        try container.encodeIfPresent(type, forKey: .type)
    }
}

struct SearchMedia: Decodable {
    var media: [Media]
    enum MediaSearchContainer: String, CodingKey {
        case search = "Search"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: MediaSearchContainer.self)
        
        media = try values.decode([MediaStruct].self, forKey: .search)
    }
}


protocol MediaDetailsProtocol: Media {
    var director: String { get set }
    var plot: String { get set }
}

struct MediaDetails: MediaDetailsProtocol {
    var poster: String
    var name: String
    var year: String
    var type: MediaType?
    var director: String
    var plot: String
    
    enum MediaDetailsCodingKeys: String, CodingKey {
        case director = "Director"
        case plot = "Plot"
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: MediaDetailsCodingKeys.self)
        try container.encode(director, forKey: .director)
        try container.encode(plot, forKey: .plot)
    }

    init(from decoder: Decoder) throws {
        let mediaValues = try decoder.container(keyedBy: MediaStruct.MediaCodingKeys.self)
        
        poster = try mediaValues.decode(String.self, forKey: .poster)
        name = try mediaValues.decode(String.self, forKey: .title)
        year = try mediaValues.decode(String.self, forKey: .year)
        let typeString = try mediaValues.decode(String.self, forKey: .type)
        if let typeEnum = MediaType(rawValue: typeString) {
            type = typeEnum
        }
        let detailValues = try decoder.container(keyedBy: MediaDetailsCodingKeys.self)
        director = try detailValues.decode(String.self, forKey: .director)
        plot = try detailValues.decode(String.self, forKey: .plot)
    }
}
