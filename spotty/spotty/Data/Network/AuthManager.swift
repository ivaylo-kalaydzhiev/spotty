//
//  AuthManager.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 10.06.22.
//

import Foundation

// TODO: Store AccessToken, Refresh Token and Expiration Date in Keychain
// TODO: Where should I store the ClientID and Client Secret?
final class AuthManager {
    
    // MARK: - Stored properties
    static let shared = AuthManager()
    private var isRefreshingToken = false
    private var refreshBlockStore = [(String) -> Void]()
    
    // MARK: - Init
    private init() {}
    
    // MARK: - Computed properties
    
    /// Used by AuthVC
    var signInURL: URL? {
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
    
    /// Used by SceneDelegate
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
    
    private var encryptedBasicToken: String? {
        let basicToken = SpotifyAPIConstants.clientID + ":" + SpotifyAPIConstants.clientSecret
        let data = basicToken.data(using: .utf8)
        return data?.base64EncodedString()
    }
    
    private var accessTokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }
    
    // MARK: - Internal methods
    // bool in the completion block represents that there is now a valid access token
    func exchangeCodeForAccessToken(code: String, completion: @escaping (Bool) -> Void) {
        // Create URL
        guard let url = URL(string: SpotifyAPIConstants.Endpoints.token) else { return }
        guard let encryptedBasicToken = encryptedBasicToken else { return }
        
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
        
        // Perform URL Request
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            
            // Parse JSON
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.cacheTokens(result: result)
                completion(true)
            } catch {
                print(error.localizedDescription)
                completion(false)
            }
        }
        
        task.resume()
    }
    
    // bool in the completion block represents that there is now a valid access token
    func refreshTokenIfNeeded(completion: @escaping (Bool) -> Void) {
        guard !isRefreshingToken else { return }
        guard shouldRefreshToken else {
            completion(true)
            return
        }
        guard let refreshToken = refreshToken else { return }
        guard let encryptedBasicToken = encryptedBasicToken else { return }
        
        // Create URL
        guard let url = URL(string: SpotifyAPIConstants.Endpoints.token) else { return }
        
        // Start refreshing Token
        isRefreshingToken = true
        
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
        request.setValue("Basic \(encryptedBasicToken)", forHTTPHeaderField: "Authorization")
        request.httpBody = components.query?.data(using: .utf8)
        
        // Perform URL Request
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            // Stop refreshing Token
            self?.isRefreshingToken = false
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.refreshBlockStore.forEach { $0(result.access_token) }
                self?.refreshBlockStore.removeAll()
                self?.cacheTokens(result: result)
                completion(true)
            } catch {
                print(error.localizedDescription)
                completion(false)
            }
            
        }
        
        task.resume()
    }
    
    func withValidToken(completion: @escaping (String) -> Void) {
        guard !isRefreshingToken else {
            refreshBlockStore.append(completion)
            return
        }
        
        // Refresh token and pass it to the completion
        if shouldRefreshToken {
            refreshTokenIfNeeded { [weak self] success in
                if success, let token = self?.accessToken { completion(token) }
            }
        // If the current token does not need to be refreshed just pass it to the comlpetion
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
