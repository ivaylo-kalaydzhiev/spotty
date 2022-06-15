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
        
        urlSession.dataTask(with: urlRequest) { data, response, error in
            if let data = data {
                
                // Delete those two lines
//                let str = String(decoding: data, as: UTF8.self)
//                print("DataString: \(str)")
//                print(response)
                
                data.parseJSON(completion: completion)
            } else if let error = error {
                completion(.failure(error))
            }
        }
        .resume()
    }
    
    static func performAuthorizedRequest<T: Decodable>(with request: URLRequest,
                                                       completion: @escaping (Result<T, Error>) -> Void) {
        
        AuthManager.shared.withValidToken { token in
            var urlRequest = request
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            performRequest(urlRequest: urlRequest, completion: completion)
        }
    }
}
