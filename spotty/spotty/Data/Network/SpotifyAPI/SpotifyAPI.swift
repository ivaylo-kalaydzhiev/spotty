//
//  SpotifyAPI.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 10.06.22.
//

import Foundation

final class SpotifyAuthProvider {
    
    /// Singleton instance to be used for interaction with the API.
    static let shared = SpotifyAuthProvider()
    
    private struct Endpoints {
        
        private static let baseAuthURL = "https://accounts.spotify.com"
        static let authorize = baseAuthURL + "/authorize"
        static let token = baseAuthURL + "/api/token"
    }
    
    private let clientID = "c59a4896be7047bcb23abe70013fc4e6"
    private let clientSecret = "579cb39eac01484295a44177d8752af3"
    
    private let redirectURI = "https://en.wikipedia.org/wiki/Bulgaria"
    
    private let scopes = "user-read-private" +
    "%20playlist-modify-public" +
    "%20playlist-read-private" +
    "%20playlist-modify-private" +
    "%20user-follow-read" +
    "%20user-library-modify" +
    "%20user-library-read" +
    "%20user-read-email" +
    "%20user-top-read"
    
    private  var encryptedBasicToken: String? {
        let basicToken = clientID + ":" + clientSecret
        let data = basicToken.data(using: .utf8)
        return data?.base64EncodedString()
    }
    
    /// URL to the Authorizaition Endpoint, containing query paramteres.
    var signInURL: URL? {
        guard let codeChallange = PKCEFlowProvider.shared.codeChallange else { return nil }
        let urlString = "\(Endpoints.authorize)" +
        "?response_type=code" +
        "&client_id=\(clientID)" +
        "&scope=\(scopes)" +
        "&redirect_uri=\(redirectURI)" +
        "&show_dialog=TRUE" +
        "&code_challenge_method=S256" +
        "&code_challenge=\(codeChallange)"
        
        return URL(string: urlString)
    }
}

extension SpotifyAuthProvider: OAuth2Supporting {
    
    func createTokenExchangeRequest(with code: String) -> URLRequest? {
        guard let encryptedBasicToken = encryptedBasicToken,
              let url = URL(string: Endpoints.token)
        else { return nil }
        
        // Create URL Components
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "client_id", value: clientID),
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
    
    func createTokenRefreshRequest(with refreshToken: String) -> URLRequest? {
        guard let url = URL(string: Endpoints.token) else { return nil }
        
        // Create URL Components
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken),
            URLQueryItem(name: "client_id", value: clientID)
        ]
        
        // Create URL Request
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.POST.rawValue
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        
        return request
    }
}
