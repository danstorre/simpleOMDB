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
    var id: String {get set}
}

struct MediaStruct : Media {
    var id: String
    var poster: String
    var name: String
    var year: String
    var type: MediaType? = nil
    
    enum MediaCodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case poster = "Poster"
        case type = "Type"
        case id = "imdbID"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: MediaCodingKeys.self)
        
        id = try values.decode(String.self, forKey: .id)
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
    var rated: String { get set }
    var runtime: String { get set }
    var genre: String { get set }
    var writer: String { get set }
    var actor: String { get set }
    var language: String { get set }
    var awards: String { get set }
    var country: String { get set }
    var metascore: String { get set }
    var imdbRating: String { get set }
    var imdbVotes: String { get set }
    var imdbID: String { get set }
    var typeMedia: String { get set }
}


protocol SeriesDetailsProtocol: MediaDetailsProtocol {
    
}

struct SeriesDetails: SeriesDetailsProtocol {
    
    var id: String
    var poster: String
    var name: String
    var year: String
    var type: MediaType?
    var director: String
    var plot: String
    var rated: String
    var runtime: String
    var genre: String
    var writer: String
    var actor: String
    var language: String
    var awards: String
    var country: String
    var metascore: String
    var imdbRating: String
    var imdbVotes: String
    var imdbID: String
    var typeMedia: String
    var totalSeasons: String
    
    enum MediaDetailsCodingKeys: String, CodingKey {
        case director = "Director"
        case plot = "Plot"
        case rated = "Rated"
        case runtime = "Runtime"
        case genre = "Genre"
        case writer = "Writer"
        case actor = "Actors"
        case language = "Language"
        case awards = "Awards"
        case metascore = "Metascore"
        case imdbRating = "imdbRating"
        case imdbVotes = "imdbVotes"
        case imdbID = "imdbID"
        case typeMedia = "Type"
        case boxOffice = "BoxOffice"
        case production = "Production"
        case website = "Website"
        case country = "Country"
        case totalSeasons = "totalSeasons"
        
        static func descriptionForAttribute(string: String) -> String {
            guard let codingKey = MediaDetailsCodingKeys(rawValue: string) else {
                return ""
            }
            switch codingKey {
            case .totalSeasons:
                return "Total Seasons"
            default:
                return codingKey.rawValue
            }
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: MediaDetailsCodingKeys.self)
        try container.encode(director, forKey: .director)
        try container.encode(plot, forKey: .plot)
        try container.encode(rated                  , forKey:        .rated      )
        try container.encode(runtime                    , forKey: .runtime      )
        try container.encode(genre                  , forKey: .genre      )
        try container.encode(writer                 , forKey: .writer      )
        try container.encode(actor                  , forKey: .actor      )
        try container.encode(language                   , forKey: .language      )
        try container.encode(awards                 , forKey: .awards      )
        try container.encode(country                    , forKey: .country      )
        try container.encode(typeMedia                  , forKey: .typeMedia )
        try container.encode(totalSeasons                  , forKey: .totalSeasons)
    }
    
    init(from decoder: Decoder) throws {
        let mediaValues = try decoder.container(keyedBy: MediaStruct.MediaCodingKeys.self)
        
        id =  try mediaValues.decode(String.self, forKey: .id)
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
        
        rated       = try detailValues.decode(String.self, forKey: .rated     )
        runtime     = try detailValues.decode(String.self, forKey: .runtime   )
        genre       = try detailValues.decode(String.self, forKey: .genre     )
        writer      = try detailValues.decode(String.self, forKey: .writer    )
        actor       = try detailValues.decode(String.self, forKey: .actor     )
        language    = try detailValues.decode(String.self, forKey: .language  )
        awards      = try detailValues.decode(String.self, forKey: .awards    )
        country     = try detailValues.decode(String.self, forKey: .country    )
        metascore   = try detailValues.decode(String.self, forKey: .metascore )
        imdbRating  = try detailValues.decode(String.self, forKey: .imdbRating )
        imdbVotes   = try detailValues.decode(String.self, forKey: .imdbVotes )
        imdbID      = try detailValues.decode(String.self, forKey: .imdbID )
        typeMedia   = try detailValues.decode(String.self, forKey: .typeMedia )
        totalSeasons   = try detailValues.decode(String.self, forKey: .totalSeasons )
    }
}
