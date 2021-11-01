//
//  MovieDetailViewController.swift
//  MovieApp
//
//  Created by datNguyem on 28/10/2021.
//

import UIKit

final class MovieDetailViewController: UIViewController {
    @IBOutlet private weak var backdropImageView: UIImageView!
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var releaseDateLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var producerCollectionView: UICollectionView!
    @IBOutlet private weak var hearthImageView: UIImageView!
    
    var movieId: Int?
    private var movieDetail: MovieDetail?
    private let isExistMovie = CoreDataManager.shared.isExistMovie
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupView()
        setupAction()
        loadingMovieDetail()
    }
    
    @objc
    func onLikeMovieTapped() {
        guard let movieId = movieId,
              let movieDetail = movieDetail else { return }
    
        if isExistMovie(movieId) {
            CoreDataManager.shared.deleteFavoriteMovie(id: movieId)
        } else {
            CoreDataManager.shared.addFavoriteMovie(movie: movieDetail)
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "dataChanged"), object: nil)
        hearthImageView.tintColor = isExistMovie(movieId) ? .red : .white
    }
    
    private func setupAction() {
        hearthImageView.isUserInteractionEnabled = true
        hearthImageView.addGestureRecognizer(UITapGestureRecognizer(
                                                target: self,
                                                action: #selector(onLikeMovieTapped)
        ))
    }
    
    private func setupView() {
        hearthImageView.tintColor = .clear
    }
    
    private func updateData(movie: MovieDetail) {
        titleLabel.text = movie.title
        releaseDateLabel.text = "Release: \(movie.releaseDate)"
        ratingLabel.text = "Average: \(String(format: "%.1f", movie.average))/10"
        descriptionLabel.text = movie.overview       
        backdropImageView.loadImageUrl(path: movie.backdropImage, completion: nil)
        posterImageView.loadImageUrl(path: movie.posterImage, completion: nil)
        hearthImageView.tintColor = isExistMovie(movie.id) ? .red : .white
    }
    
    private func loadingMovieDetail() {
        guard let movieId = movieId else { return }
        
        let urlMovie = Constant.getDetailLink(for: movieId)
        
        APIFeching().fetchingData(typeGeneric: MovieDetail.self, url: urlMovie) { [weak self] result in
            switch result {
            case .success(let movie):
                guard let self = self else { return }
                self.movieDetail = movie
                
                DispatchQueue.main.async {
                    self.updateData(movie: movie)
                    self.producerCollectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 15
        layout.scrollDirection = .horizontal
        producerCollectionView.collectionViewLayout = layout
        producerCollectionView.register(ProducerCollectionViewCell.nib,
                                        forCellWithReuseIdentifier: ProducerCollectionViewCell.identifier)
        producerCollectionView.delegate = self
        producerCollectionView.dataSource = self
    }
}

extension MovieDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.6, height: collectionView.frame.height)
    }
}

extension MovieDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieDetail?.producer.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProducerCollectionViewCell.identifier,
                                                      for: indexPath) as! ProducerCollectionViewCell
        cell.configure(company: (movieDetail?.producer[indexPath.row])!)
        return cell
    }
}
