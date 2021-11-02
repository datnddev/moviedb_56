//
//  MovieResultViewController.swift
//  MovieApp
//
//  Created by datNguyem on 02/11/2021.
//

import UIKit

final class MovieSearchViewController: UIViewController {
    private var genres = [Genre]()
    private var movies = [Movie]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getGenres()
    }
    
    private func getGenres() {
        APIFeching().fetchingData(typeGeneric: Genres.self, url: Constant.getGenresLink()) { result in
            switch result {
            case .success(let genres):
                self.genres = genres.genres
            case .failure(let error):
                print("\(error)")
            }
        }
    }
    
    private func searchMovie(query: String, genre: Genre){
        APIFeching().fetchingData(typeGeneric: CategoriesMovie.self,
                                  url: Constant.getSearchLink(query: query, genre: genre)) { result in
            switch result {
            case .success(let movies):
                self.movies = movies.results
            case .failure(let error):
                print("\(error)")
            }
        }
    }
}
