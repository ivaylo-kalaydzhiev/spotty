//
//  AuthManager.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 10.06.22.
//

import Foundation

/// Singleton Manager suited for implementing the OAuth2 Code Flow.
final class AuthManager {
    
    /// Singleton instance used to interact with the Manager.
    static let shared = AuthManager()
    
    /// Authorization provider with which the ``AuthManager`` is going to try to authorize.
    var apiDelegate: OAuth2Supporting!
    
    // MARK: - Stored properties
    private var isRefreshingToken = false
    private var refreshBlockStore = [(String) -> Void]()
    
    private init() {}
    
    // MARK: - Computed properties
    var isSignedIn: Bool {
        return accessToken != nil
    }
    
    private var shouldRefreshToken: Bool {
        guard let expirationDate = accessTokenExpirationDate else { return false }
        let currentDate = Date()
        let fiveMinutes: TimeInterval = 300
        return currentDate.addingTimeInterval(fiveMinutes) >= expirationDate
    }
    
    private var accessToken: String? {
        guard let data = KeychainManager.read(
            service: KeychainManager.Services.accessToken,
            account: KeychainManager.Accounts.spotify)
        else { return nil }
        return String(data: data, encoding: .utf8)!
    }
    
    private var refreshToken: String? {
        guard let data = KeychainManager.read(
            service: KeychainManager.Services.refreshToken,
            account: KeychainManager.Accounts.spotify)
        else { return nil }
        return String(data: data, encoding: .utf8)!
    }
    
    private var accessTokenExpirationDate: Date? {
        guard let data = KeychainManager.read(
            service: KeychainManager.Services.expirationDate,
            account: KeychainManager.Accounts.spotify)
        else { return nil }
        let retrievedTimestamp = data.withUnsafeBytes { $0.load(as: Double.self) }
        return Date(timeIntervalSinceReferenceDate: retrievedTimestamp)
    }
    
    // MARK: - Exposed methods
    /// Exchange the Code from the API for an Access Token and cache the response
    /// - Parameters:
    ///   - code: The Code return by the external API as part of the OAuth2 Code flow.
    ///   - completion: Handle successfull or unsuccessfull exchange.
    ///
    ///  The API Response that needs to be cached is represented by an ``AuthResponse`` model in this application.
    ///  It contains multiple properties including Access Token, Refresh Token and Expiration Date
    func exchangeCodeForAccessToken(code: String, completion: @escaping (Bool) -> Void) {
        guard let request = apiDelegate.createTokenExchangeRequest(with: code) else { return }
        
        Network.performRequest(urlRequest: request) { [weak self] (result: Result<AuthResponse, Error>) in
            switch result {
            case .success(let response):
                self?.cacheTokens(result: response)
                completion(true)
            case .failure(let error):
                print(error.localizedDescription)
                completion(false)
            }
        }
    }
    
    /// Exchange the Refresh Token for an Access Token and cache the response.
    /// - Parameter completion: Handle successfull or unsuccessfull exchange.
    ///
    /// The API Response that needs to be cached is represented by an ``AuthResponse`` model in this application.
    /// It contains multiple properties including Access Token, Refresh Token and Expiration Date
    func refreshTokenIfNeeded(completion: @escaping (Bool) -> Void) {
        guard !isRefreshingToken, let refreshToken = refreshToken else { return }
        guard shouldRefreshToken else { completion(true); return }
        
        guard let request = apiDelegate.createTokenRefreshRequest(with: refreshToken) else { return }
        isRefreshingToken = true
        
        Network.performRequest(urlRequest: request) { [weak self] (result: Result<AuthResponse, Error>) in
            self?.isRefreshingToken = false
            
            switch result {
            case .success(let response):
                self?.refreshBlockStore.forEach { $0(response.accessToken) }
                self?.refreshBlockStore.removeAll()
                self?.cacheTokens(result: response)
                completion(true)
            case .failure(let error):
                print(error.localizedDescription)
                completion(false)
            }
        }
    }
    
    /// Perform any action with a valid Access Token exposed by the parameter of the completion handler.
    /// - Parameter completion: The action you want to perform with a valid Access Token.
    func withValidToken(completion: @escaping (String) -> Void) {
        guard !isRefreshingToken else {
            refreshBlockStore.append(completion)
            return
        }
        
        // Refresh token and use it
        if shouldRefreshToken {
            refreshTokenIfNeeded { [weak self] refreshSucceeded in
                if refreshSucceeded, let token = self?.accessToken { completion(token) }
            }
            // If the current token does not need to be refreshed just use it
        } else if let token = accessToken {
            completion(token)
        }
    }
    
    // MARK: - Private methods
    private func cacheTokens(result: AuthResponse) {
        KeychainManager.save(
            Data(result.accessToken.utf8),
            service: KeychainManager.Services.accessToken,
            account: KeychainManager.Accounts.spotify)
        
        if let refreshToken = result.refreshToken {
            KeychainManager.save(
                Data(refreshToken.utf8),
                service: KeychainManager.Services.refreshToken,
                account: KeychainManager.Accounts.spotify)
        }
        
        let expirationDate = Date().addingTimeInterval(TimeInterval(result.expiresIn))
        let timestamp = expirationDate.timeIntervalSinceReferenceDate
        KeychainManager.save(
            withUnsafeBytes(of: timestamp) { Data($0) },
            service: KeychainManager.Services.expirationDate,
            account: KeychainManager.Accounts.spotify)
    }
}

// TODO: One Repository, that implements multiple protocols.
// TODO: Create Splash Screen.
