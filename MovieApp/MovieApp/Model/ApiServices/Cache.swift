//
//  Cache.swift
//  MovieApp
//
//  Created by datNguyem on 27/10/2021.
//

import Foundation

final class Cache<Key: Hashable, Value> {
    
    var cache: NSCache<WrapperKey, Entry>
    
    init() {
        cache = NSCache<WrapperKey, Entry>()
        cache.countLimit = 40
    }
}
