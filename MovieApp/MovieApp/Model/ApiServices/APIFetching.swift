//
//  ApiFetcher.swift
//  MovieApp
//
//  Created by datNguyem on 21/10/2021.
//

import Foundation

enum APIError: Error {
    case urlError
    case responseError
    case decodeError
}

class APIFeching {
    
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
}
