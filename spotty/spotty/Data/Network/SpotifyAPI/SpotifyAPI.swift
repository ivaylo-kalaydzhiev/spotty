//
//  SpotifyAPI.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 10.06.22.
//

import Foundation

final class SpotifyAPI {
    
    /// Singleton instance to be used for interaction with the API.
    static let shared = SpotifyAPI()
    
    private  var encryptedBasicToken: String? {
        let basicToken = SpotifyAPIConstants.clientID + ":" + SpotifyAPIConstants.clientSecret
        let data = basicToken.data(using: .utf8)
        return data?.base64EncodedString()
    }
    
    /// URL to the Authorizaition Endpoint, containing query paramteres.
    var signInURL: URL? {
        guard let codeChallange = PKCEFlowProvider.shared.codeChallange else { return nil }
        let urlString = "\(SpotifyAPIConstants.Endpoints.authorize)" +
        "?response_type=code" +
        "&client_id=\(SpotifyAPIConstants.clientID)" +
        "&scope=\(SpotifyAPIConstants.scopes)" +
        "&redirect_uri=\(SpotifyAPIConstants.redirectURI)" +
        "&show_dialog=TRUE" +
        "&code_challenge_method=S256" +
        "&code_challenge=\(codeChallange)"
        
        return URL(string: urlString)
    }
}

extension SpotifyAPI: OAuth2Supporting {
    
    func createTokenExchangeRequest(with code: String) -> URLRequest? {
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
    
    func createTokenRefreshRequest(with refreshToken: String) -> URLRequest? {
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
