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
    
    func configure(company: Company) {
        guard let logoPath = company.logoPath else {
            logoImageView.isHidden = true
            nameLabel.isHidden = false
            nameLabel.text = company.name
            return
        }

        logoImageView.loadImageUrl(path: logoPath)
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
