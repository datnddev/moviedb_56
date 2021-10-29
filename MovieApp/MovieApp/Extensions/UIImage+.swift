//
//  UIImage+.swift
//  MovieApp
//
//  Created by datNguyem on 29/10/2021.
//

import Foundation
import UIKit

extension UIImageView {
    func loadImageUrl(path: String, completion: ((UIImage?) -> ())? ) {
        guard let url = URL(string: Constant.getImageLink(path: path)) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data, let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.isHidden = false
                self.image = image
                
                guard let completion = completion else { return }
                completion(image)
            }
        }.resume()
    }
}
