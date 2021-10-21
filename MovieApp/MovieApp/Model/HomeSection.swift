//
//  HomeSection.swift
//  MovieApp
//
//  Created by datNguyem on 27/10/2021.
//

import Foundation

struct HomeSection {
    var kind: Categories
    var data: [Movie]
    
    var title: String {
        switch kind {
        case .nowPlaying:
            return "Now Playing"
        case .popular:
            return "Popular"
        case .topRated:
            return "Top Rated"
        case .upcoming:
            return "Up Coming"
        }
    }
}
