//
//  UIImage+.swift
//  MovieApp
//
//  Created by datNguyem on 27/10/2021.
//

import Foundation
import UIKit

extension UIImageView {
    func loadImageUrl(path: String, completion: @escaping (UIImage?) -> ()) {
        guard let imageURL = URL(string: Constant.getImageLink(path: path)) else { return }
        
        URLSession.shared.dataTask(with: imageURL) { data, _, error in
            guard let data = data else { return }
            let image = UIImage(data: data)
            
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}
