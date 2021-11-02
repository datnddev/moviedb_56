//
//  Constants.swift
//  MovieApp
//
//  Created by datNguyem on 21/10/2021.
//

import Foundation

enum Categories: String, CaseIterable {
    case popular = "popular"
    case topRated = "top_rated"
    case upcoming = "upcoming"
    case nowPlaying = "now_playing"
}

enum Constant {
    static let baseUrl = "https://api.themoviedb.org/3"
    
    static func getAPIKey() -> String {
        if let path = Bundle.main.path(forResource: "keys", ofType: "plist") {
            if let dict = NSDictionary(contentsOfFile: path) {
                if let value = dict["APIKey"] as? String {
                    return value
                } else {
                    print("Api key not found")
                }
            }
        }
        return ""
    }
    
    static func getCategoriesLink(for type: Categories, page: Int = 1) -> String {
        return "\(baseUrl)/movie/\(type.rawValue)?api_key=\(getAPIKey())&page=\(page)"
    }
    
    static func getSearchLink(query: String, genre: Genre) -> String {
        let queryWithOutSpace = query.replacingOccurrences(of: " ", with: "+")
        return "\(baseUrl)/search/movie?api_key=\(getAPIKey())&query=\(queryWithOutSpace)&with_genres=\(genre.id)"
    }
    
    static func getDetailLink(for idMovie: Int) -> String {
        return "\(baseUrl)/movie/\(idMovie)?api_key=\(getAPIKey())&append_to_response=videos"
    }
    
    static func getImageLink(path: String) -> String {
        return "https://image.tmdb.org/t/p/w500\(path)"
    }
    
    static func getGenresLink() -> String {
        return "https://api.themoviedb.org/3/genre/movie/list?api_key=\(getAPIKey())"
    }
}
