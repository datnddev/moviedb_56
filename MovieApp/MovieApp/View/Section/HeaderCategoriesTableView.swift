//
//  HeaderCategoriesTableView.swift
//  MovieApp
//
//  Created by datNguyem on 22/10/2021.
//

import UIKit

final class HeaderCategoriesTableView: UIView {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var moreImage: UIImageView!
    
    static let identifier = "HeaderCategoriesTableView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        let viewFromXib = Bundle.main.loadNibNamed(HeaderCategoriesTableView.identifier,
                                                   owner: self,
                                                   options: nil)?.first as! UIView
        viewFromXib.frame = self.bounds
        addSubview(viewFromXib)
    }
    
    func configure(homeSection: HomeSection) {
        titleLabel.text = homeSection.title
    }
}
