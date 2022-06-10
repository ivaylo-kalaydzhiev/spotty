//
//  AuthManager.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 10.06.22.
//

import Foundation

// TODO: Store AccessToken, Refresh Token and Expiration Date in Keychain
// TODO: Where should I store the ClientID and Client Secret?


/// Singleton Manager implementing the OAuth2 Code Flow with PKCE extension
final class AuthManager {
    
    /// Singleton instance used to interact with the Manager
    static let shared = AuthManager()
    
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
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var refreshToken: String? {
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    private var accessTokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date
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
        guard let request = SpotifyAuth.createTokenExchangeRequest(with: code) else { return }
        
        Networking.performRequest(urlRequest: request) { [weak self] (result: Result<AuthResponse, Error>) in
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
        guard !isRefreshingToken else { return }
        guard let refreshToken = refreshToken else { return }
        guard shouldRefreshToken else {
            completion(true)
            return
        }
        
        guard let request = SpotifyAuth.createTokenRefreshRequest(with: refreshToken) else { return }
        isRefreshingToken = true
        
        Networking.performRequest(urlRequest: request) { [weak self] (result: Result<AuthResponse, Error>) in
            self?.isRefreshingToken = false
            
            switch result {
            case .success(let response):
                self?.refreshBlockStore.forEach { $0(response.access_token) }
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
        UserDefaults.standard.setValue(result.access_token, forKey: "access_token")
        if let refreshToken = result.refresh_token {
            UserDefaults.standard.setValue(refreshToken, forKey: "refresh_token")
        }
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expirationDate")
    }
}

struct SpotifyAuth {
    
    static var signInURL: URL? {
        guard let challange = PKCEFlowProvider.shared.codeChallange else { return nil }
        let base = "https://accounts.spotify.com/authorize"
        let urlString = "\(base)?response_type=code" +
        "&client_id=\(SpotifyAPIConstants.clientID)" +
        "&scope=\(SpotifyAPIConstants.scopes)" +
        "&redirect_uri=\(SpotifyAPIConstants.redirectURI)" +
        "&show_dialog=TRUE" +
        "&code_challenge_method=S256" +
        "&code_challenge=\(challange)"
        
        return URL(string: urlString)
    }
    
    private static var encryptedBasicToken: String? {
        let basicToken = SpotifyAPIConstants.clientID + ":" + SpotifyAPIConstants.clientSecret
        let data = basicToken.data(using: .utf8)
        return data?.base64EncodedString()
    }
    
    static func createTokenExchangeRequest(with code: String) -> URLRequest? {
        guard let encryptedBasicToken = encryptedBasicToken,
              let url = URL(string: SpotifyAPIConstants.Endpoints.token)
        else { return nil }
        
        // Create URL Components
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: SpotifyAPIConstants.redirectURI),
            URLQueryItem(name: "client_id", value: SpotifyAPIConstants.clientID),
            URLQueryItem(name: "code_verifier", value: PKCEFlowProvider.shared.codeVerifier)
        ]
        
        // Create URL Request
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.POST.rawValue
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Basic \(encryptedBasicToken)", forHTTPHeaderField: "Authorization")
        request.httpBody = components.query?.data(using: .utf8)
        
        return request
    }
    
    static func createTokenRefreshRequest(with refreshToken: String) -> URLRequest? {
        guard let url = URL(string: SpotifyAPIConstants.Endpoints.token) else { return nil }
        
        // Create URL Components
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken),
            URLQueryItem(name: "client_id", value: SpotifyAPIConstants.clientID)
        ]
        
        // Create URL Request
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.POST.rawValue
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        
        return request
    }
}

struct Networking {
    
    /// This method performs a URL Request with the supplied `URLSession` and then parses the retrieved `Data`,
    ///  presuming it is in JSON format into the type, specified by the  completion handler
    /// - Parameters:
    ///    - urlRequest: The ``URLRequest`` to be performed.
    ///    - urlSession: A `URLSession` on which to perform the `URLRequest` formed by the urlString parameter
    ///    - completion: A block of code that handles both successfull data retrieval and parsing and potential errors
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

extension Data {
    
    /// This is a generic JSON Parser extension that tries to decode the `Data` object on which it operates into the Data Type provided by the completion block
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
