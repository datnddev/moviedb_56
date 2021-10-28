//
//  MovieCollectionViewCell.swift
//  MovieApp
//
//  Created by datNguyem on 21/10/2021.
//

import UIKit

final class MovieCollectionViewCell: UICollectionViewCell, ReusableViewProtocol {
    @IBOutlet private weak var movieImage: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    
    private var imagesCache = Cache<NSString, UIImage>()
    private let utilityQueue = DispatchQueue.global(qos: .utility)   
    
    func configure(movie: Movie) {
        titleLabel.text = movie.title
        dateLabel.text = movie.releaseDate
        
        let key = NSString(string: movie.posterImage)

        if let cachedImage = imagesCache.value(for: key) {
            movieImage.image = cachedImage
        } else {
            movieImage.loadImageUrl(path: movie.posterImage) { [weak self] image in
                guard let self = self, let image = image else { return }
                self.movieImage.image = image
                self.imagesCache.insert(image, for: key)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        movieImage.contentMode = .scaleAspectFill
        backgroundColor = UIColor.hex_0E1A2B
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        dateLabel.text = nil
        movieImage.image = nil
    }
}
