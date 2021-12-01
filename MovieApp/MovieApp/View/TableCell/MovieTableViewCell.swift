//
//  MovieTableViewCell.swift
//  MovieApp
//
//  Created by datNguyem on 01/11/2021.
//

import UIKit

final class MovieTableViewCell: UITableViewCell, ReusableViewProtocol {
    @IBOutlet private weak var movieImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var releaseDateLabel: UILabel!
    
    func configure(movie: FavoriteMovie) {
        titleLabel.text = movie.title
        releaseDateLabel.text = "Release: \(movie.releaseDate ?? "")"
        print(movie.imageLink)
        guard let posterPath = movie.imageLink else { return }
        movieImageView.loadImageUrl(path: posterPath)
    }
    
    func configure(movie: Movie) {
        titleLabel.text = movie.title
        releaseDateLabel.text = "Release: \(movie.releaseDate)"
        
        guard let posterPath = movie.posterImage else { return }
        ImageServices.shared.load(path: posterPath, for: movieImageView)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        movieImageView.contentMode = .scaleAspectFill
        movieImageView.layer.masksToBounds = true
        movieImageView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        releaseDateLabel.text = nil
        ImageServices.shared.cancel(for: movieImageView)
        movieImageView.image = nil
    }   
}
