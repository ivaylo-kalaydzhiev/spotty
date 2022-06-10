//
//  Network.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 10.06.22.
//

import Foundation

struct Network {
    
    /// This method performs a ``URLRequest`` with the supplied ``URLSession`` and then parses the retrieved ``Data``,
    ///  presuming it is in JSON format into the type, specified by the  completion handler
    /// - Parameters:
    ///    - urlRequest: The ``URLRequest`` to be performed.
    ///    - urlSession: A ``URLSession`` on which to perform the ``URLRequest``.
    ///    - completion: A block of code that handles both successfull data retrieval and parsing and potential errors.
    static func performRequest<T: Decodable>(urlRequest: URLRequest,
                                             urlSession: URLSession = URLSession.shared,
                                             completion: @escaping (Result<T, Error>) -> Void) {
        
        urlSession.dataTask(with: urlRequest) { (data, response, error) in
            if let data = data {
                data.parseJSON(completion: completion)
            } else if let error = error {
                completion(.failure(error))
            }
        }
        .resume()
    }
}
