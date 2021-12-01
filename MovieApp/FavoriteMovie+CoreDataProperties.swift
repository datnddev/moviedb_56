//
//  FavoriteMovie+CoreDataProperties.swift
//  MovieApp
//
//  Created by datNguyem on 29/11/2021.
//
//

import Foundation
import CoreData


extension FavoriteMovie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteMovie> {
        return NSFetchRequest<FavoriteMovie>(entityName: "FavoriteMovie")
    }

    @NSManaged public var releaseDate: String?
    @NSManaged public var id: Int64
    @NSManaged public var imageLink: String?
    @NSManaged public var title: String?

}

extension FavoriteMovie : Identifiable {

}
