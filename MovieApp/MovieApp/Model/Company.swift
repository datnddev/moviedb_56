//
//  Company.swift
//  MovieApp
//
//  Created by datNguyem on 20/10/2021.
//

import Foundation

struct Company: Decodable {
    var id: Int
    var name: String
    var logoPath: String?
    
    enum Codingkeys: String, CodingKey {
        case id
        case name
        case logoPath = "logo_path"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Codingkeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        logoPath = try container.decode(String.self, forKey: .logoPath)
    }
}
