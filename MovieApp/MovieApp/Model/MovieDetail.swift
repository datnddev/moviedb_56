//
//  MovieDetail.swift
//  MovieApp
//
//  Created by datNguyem on 20/10/2021.
//

import Foundation

struct MovieDetail: Decodable {
    var id: Int
    var title: String
    var overview: String
    var backdropImage: String
    var posterImage: String
    var releaseDate: String
    var genres: [Genre]
    var producer: [Company]
    var results: [Trailer]
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case backdropImage = "backdrop_path"
        case posterImage = "poster_path"
        case releaseDate = "release_date"
        case genres
        case producer = "production_companies"
        case videos
        case results
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        overview = try container.decode(String.self, forKey: .overview)
        backdropImage = try container.decode(String.self, forKey: .backdropImage)
        posterImage = try container.decode(String.self, forKey: .posterImage)
        releaseDate = try container.decode(String.self, forKey: .releaseDate)
        genres = try container.decode([Genre].self, forKey: .genres)
        producer = try container.decode([Company].self, forKey: .producer)
        
        let innerContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .videos)
        results = try innerContainer.decode([Trailer].self, forKey: .results)
    }
}
