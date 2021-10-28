//
//  MovieDetailViewController.swift
//  MovieApp
//
//  Created by datNguyem on 28/10/2021.
//

import UIKit

final class MovieDetailViewController: UIViewController {
    var movieId: Int?
    private var movieDetail: MovieDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingMovieDetail()
    }
    
    private func loadingMovieDetail() {
        guard let movieId = movieId else { return }
        
        let urlMovie = Constant.getDetailLink(for: movieId)
        
        APIFeching().fetchingData(typeGeneric: MovieDetail.self, url: urlMovie) { [weak self] result in
            switch result {
            case .success(let movie):
                guard let self = self else { return }
                self.movieDetail = movie
            case .failure(let error):
                print(error)
            }
        }
    }
}
