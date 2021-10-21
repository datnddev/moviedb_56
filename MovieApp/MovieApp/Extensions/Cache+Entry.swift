//
//  Cache+Entry.swift
//  MovieApp
//
//  Created by datNguyem on 27/10/2021.
//

import Foundation

extension Cache {
    final class Entry {
        
        let value: Value
        
        init(value: Value) {
            self.value = value
        }
    }
}
