//
//  Cache+.swift
//  MovieApp
//
//  Created by datNguyem on 27/10/2021.
//

import Foundation

extension Cache {
    func insert(_ value: Value, for key: Key) {
        let entry = Entry(value: value)
        self.cache.setObject(entry, forKey: WrapperKey(key))
    }
    
    func value(for key: Key) -> Value? {
        guard let entry = self.cache.object(forKey: WrapperKey(key)) else { return nil }
        return entry.value
    }
    
    func remove(for key: Key) {
        self.cache.removeObject(forKey: WrapperKey(key))
    }
}
