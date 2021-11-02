//
//  Genre.swift
//  MovieApp
//
//  Created by datNguyem on 20/10/2021.
//

import Foundation

struct Genre: Decodable {
    var id: Int
    var name: String
}

struct Genres: Decodable {
    var genres: [Genre]
}
