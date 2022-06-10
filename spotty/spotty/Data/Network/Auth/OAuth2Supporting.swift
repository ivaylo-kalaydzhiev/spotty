//
//  OAuth2Supporting.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 10.06.22.
//

import Foundation

protocol OAuth2Supporting {
    
    /// Constructs a ``URLRequest`` suited to exchange Code for Access Token as part of the OAuth2 Code Flow.
    /// - Parameter code: Code provided by the API.
    /// - Returns: ``URLRequest`` which can be used to exchange Code for Access Token as part of the OAuth2 Code Flow.
    func createTokenExchangeRequest(with code: String) -> URLRequest?
    
    /// Constructs a ``URLRequest`` suited to exchange Refresh Token for Access Token as part of the OAuth2 Code Flow.
    /// - Parameter refreshToken: Valid Refresh Token.
    /// - Returns: ``URLRequest`` which can be used to exchange Refresh Token for Access Token as part of the OAuth2 Code Flow.
    func createTokenRefreshRequest(with refreshToken: String) -> URLRequest?
}
