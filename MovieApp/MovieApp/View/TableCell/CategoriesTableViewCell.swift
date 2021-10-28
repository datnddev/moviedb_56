//
//  CategoriesTableViewCell.swift
//  MovieApp
//
//  Created by datNguyem on 22/10/2021.
//

import UIKit

final class CategoriesTableViewCell: UITableViewCell, ReusableViewProtocol {
    @IBOutlet private weak var movieCollectionView: UICollectionView!
    private var movies = [Movie]()
    
    func configure(movies: [Movie]) {
        self.movies = movies
        movieCollectionView.reloadData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        movieCollectionView.register(MovieCollectionViewCell.nib,
                                     forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        movieCollectionView.dataSource = self
        movieCollectionView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension CategoriesTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width * 0.45, height: collectionView.frame.height)
    }
}

extension CategoriesTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier,
                                                      for: indexPath) as! MovieCollectionViewCell
        cell.configure(movie: movies[indexPath.row])
        return cell
    }
}

extension CategoriesTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyboard.instantiateViewController(identifier: "MovieDetailViewController")
            as MovieDetailViewController
        detailVC.movie = movies[indexPath.row]
        self.window?.rootViewController?.present(detailVC, animated: true, completion: nil)
    }
}
