//
//  GenreCollectionViewCell.swift
//  MovieApp
//
//  Created by datNguyem on 02/11/2021.
//

import UIKit

final class GenreCollectionViewCell: UICollectionViewCell, ReusableViewProtocol {
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    func configure(title: String) {
        titleLabel.text = title
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let selectedView = UIView(frame: bounds)
        layer.cornerRadius = 20
        selectedView.backgroundColor = .yellow
        selectedBackgroundView = selectedView
    }
    
    override var isSelected: Bool {
        didSet {
            print(isSelected)
            containerView.backgroundColor = isSelected ? .blue : .white
        }
    }
}
