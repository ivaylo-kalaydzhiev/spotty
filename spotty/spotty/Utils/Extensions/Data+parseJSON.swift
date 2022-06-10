//
//  Data+parseJSON.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 10.06.22.
//

import Foundation

extension Data {
    
    /// This is a generic JSON Parser extension that tries to decode the ``Data`` object on which it operates into the Data Type provided by the completion block
    /// - Parameters:
    ///    - completion: A completion block that handles both succesful data parsing and any potential parsing error.
    func parseJSON<T: Decodable>(completion: @escaping (Result<T, Error>) -> Void) {
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: self)
            completion(.success(decodedData))
        } catch {
            completion(.failure(error))
        }
    }
}
