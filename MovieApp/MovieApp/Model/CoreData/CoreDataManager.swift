//
//  CoreDataManager.swift
//  MovieApp
//
//  Created by datNguyem on 01/11/2021.
//

import Foundation
import CoreData

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init() { }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MovieAppDB")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Save error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension CoreDataManager {
    func checkExistMovie(id: Int) -> Bool {
        return getMovies().contains(where: {$0.id == id})
    }
    
    func addFavoriteMovie(movie: MovieDetail) {
        let newItem = FavoriteMovie(context: persistentContainer.viewContext)
        newItem.id = Int64(movie.id)
        newItem.title = movie.title
        newItem.posterPath = movie.posterImage
        newItem.releaseDate = movie.releaseDate
        
        CoreDataManager.shared.saveContext()
    }
    
    func deleteFavoriteMovie(id: Int) -> Bool {
        guard let movie = getMovies().filter({ $0.id == id }).first else {
            return false
        }
        persistentContainer.viewContext.delete(movie)
        return true
    }
    
    func getMovies() -> [FavoriteMovie] {
        let context = persistentContainer.viewContext
        let request = FavoriteMovie.fetchRequest() as NSFetchRequest<FavoriteMovie>
        
        do {
            return try context.fetch(request)
        } catch {
            return []
        }
    }
}
