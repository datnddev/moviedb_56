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
    
    func configure(movie: Movie) {
        titleLabel.text = movie.title
        dateLabel.text = movie.releaseDate
        
        guard let posterPath = movie.posterImage else { return }
        movieImage.loadImageUrl(path: posterPath)
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
