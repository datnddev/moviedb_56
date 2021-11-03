//
//  FavoriteMovieViewController.swift
//  MovieApp
//
//  Created by datNguyem on 19/10/2021.
//

import UIKit

final class FavoriteMovieViewController: UIViewController {
    enum LayoutOptions {
        static let movieCellHeight: CGFloat = 130
    }
    
    @IBOutlet private weak var movieTableView: UITableView!
    
    private var movies = [FavoriteMovie]()

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(loadData),
                                               name: NSNotification.Name("dataChanged"),
                                               object: nil)
        setupTableView()
        loadData()
    }
    
    private func setupTableView() {
        movieTableView.register(MovieTableViewCell.nib,
                                forCellReuseIdentifier: MovieTableViewCell.identifier)
        movieTableView.delegate = self
        movieTableView.dataSource = self
    }
    
    @objc
    private func loadData() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            self.movies = CoreDataManager.shared.getMovies()
            
            DispatchQueue.main.async {
                //update data here
                self.movieTableView.reloadData()
            }
        }
    }
}

extension FavoriteMovieViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier,
                                                 for: indexPath) as! MovieTableViewCell
        cell.configure(movie: movies[indexPath.row])
        return cell
    }
}

extension FavoriteMovieViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return LayoutOptions.movieCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyboard.instantiateViewController(identifier: "MovieDetailViewController")
            as MovieDetailViewController
        detailVC.movieId = Int(movies[indexPath.row].id)
        present(detailVC, animated: true, completion: nil)
    }
}
