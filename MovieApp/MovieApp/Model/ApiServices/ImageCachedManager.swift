//
//  ImageCachedManager.swift
//  MovieApp
//
//  Created by datNguyem on 01/11/2021.
//

import Foundation
import UIKit

final class ImageCacheManager {
    var imagesCache = Cache<NSString, UIImage>()
    
    static let shared = ImageCacheManager()
    
    private init() { }
}
