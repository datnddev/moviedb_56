//
//  ReusableViewProtocol.swift
//  MovieApp
//
//  Created by datNguyem on 24/10/2021.
//

import Foundation
import UIKit

protocol ReusableViewProtocol {
    static var identifier: String { get }
    static var nib: UINib { get }
}

extension ReusableViewProtocol {
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}
