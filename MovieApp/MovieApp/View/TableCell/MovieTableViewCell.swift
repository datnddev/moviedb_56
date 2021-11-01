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
    
    private var imagesCache = Cache<NSString, UIImage>()
    
    func configure(movie: FavoriteMovie) {
        titleLabel.text = movie.title
        releaseDateLabel.text = "Release: \(movie.releaseDate ?? "")"
        
        guard let posterPath = movie.posterPath else { return }
        let key = NSString(string: posterPath)

        if let cachedImage = imagesCache.value(for: key) {
            movieImageView.image = cachedImage
        } else {
            movieImageView.loadImageUrl(path: posterPath) { [weak self] image in
                guard let self = self, let image = image else { return }
                self.imagesCache.insert(image, for: key)
            }
        }
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
        movieImageView.image = nil
    }   
}
