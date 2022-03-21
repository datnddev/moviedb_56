//
//  Cache+WrapperKey.swift
//  MovieApp
//
//  Created by datNguyem on 27/10/2021.
//

import Foundation

extension Cache {
    
    final class WrapperKey: NSObject {
        
        let key: Key
        
        init(_ key: Key) {
            self.key = key
        }
        
        override var hash: Int {
            return self.key.hashValue
        }
        
        override func isEqual(_ object: Any?) -> Bool {
            guard let value = object as? WrapperKey else { return false }
            return value.key == key
        }
    }
}
