//
//  FavoriteMovieViewController.swift
//  MovieApp
//
//  Created by datNguyem on 19/10/2021.
//

import UIKit

final class FavoriteMovieViewController: UIViewController {
    private var movies = [FavoriteMovie]()

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(loadData),
                                               name: NSNotification.Name("dataChanged"),
                                               object: nil)
        loadData()
    }
    
    @objc
    private func loadData() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            self.movies = CoreDataManager.shared.getMovies()
            
            DispatchQueue.main.async {
                //update data here
            }
        }
    }
}
