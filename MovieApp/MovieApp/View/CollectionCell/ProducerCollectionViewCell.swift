//
//  ProducerCollectionViewCell.swift
//  MovieApp
//
//  Created by datNguyem on 28/10/2021.
//

import UIKit

final class ProducerCollectionViewCell: UICollectionViewCell, ReusableViewProtocol {
    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    
    private var imagesCache = Cache<NSString, UIImage>()
    
    func configure(company: Company) {
        guard let logoPath = company.logoPath else {
            nameLabel.isHidden = false
            nameLabel.text = company.name
            return
        }
        
        let key = NSString(string: logoPath)
        
        if let imageCache = imagesCache.value(for: key) {
            logoImageView.isHidden = false
            logoImageView.image = imageCache
        } else {
            logoImageView.loadImageUrl(path: logoPath) { [weak self] image in
                guard let self = self, let image = image else { return }                
                self.imagesCache.insert(image, for: key)
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        logoImageView.image = nil
        nameLabel.text = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = .white
        logoImageView.contentMode = .scaleAspectFit
        nameLabel.adjustsFontSizeToFitWidth = true
    }
}
