//
//  CategoriesMovie.swift
//  MovieApp
//
//  Created by datNguyem on 20/10/2021.
//

import Foundation

struct CategoriesMovie: Decodable {
    var results: [Movie]
}

struct Movie: Decodable {
    var id: Int
    var title: String
    var posterImage: String?
    var releaseDate: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case posterImage = "poster_path"
        case releaseDate = "release_date"
    }
}
