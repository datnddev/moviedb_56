//
//  ApiFetcher.swift
//  MovieApp
//
//  Created by datNguyem on 21/10/2021.
//

import Foundation
import UIKit

enum APIError: Error {
    case urlError
    case responseError
    case decodeError
}

class APIFeching {
    private var runningTasks = [UUID: URLSessionDataTask]()
    
    func fetchingData<T: Decodable>(
        typeGeneric: T.Type,
        url: String,
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        guard let url = URL(string: url) else {
            completion(.failure(.urlError))
            return
        }
       
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let response = response as? HTTPURLResponse, response.statusCode == 200, let data = data else {
                completion(.failure(.responseError))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(.decodeError))
                print(String(describing: error))
            }
        }.resume()
    }
    
    func loadImageURL(path: String, completion: @escaping ((Result<UIImage, Error>) -> Void)) -> UUID? {
        guard let url = URL(string: Constant.getImageLink(path: path)) else { return nil}
        let imageCaches = ImageCacheManager.shared.imagesCache
        let key = NSString(string: path)
        
        if let cachedData = imageCaches.value(for: key) {
            completion(.success(cachedData))
            return nil
        }
        
        let taskID = UUID()
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            defer {
                self.runningTasks.removeValue(forKey: taskID)
            }
            
            if let error = error, (error as NSError).code != NSURLErrorCancelled {
                completion(.failure(error))
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(APIError.responseError))
                return
            }
            guard let data = data, let image = UIImage(data: data) else {
                completion(.failure(APIError.decodeError))
                return
            }
            completion(.success(image))
        }
        task.resume()
        runningTasks[taskID] = task
        return taskID
    }
    
    func cancelTask(with taskID: UUID) {
        runningTasks[taskID]?.cancel()
        runningTasks.removeValue(forKey: taskID)
    }
}
