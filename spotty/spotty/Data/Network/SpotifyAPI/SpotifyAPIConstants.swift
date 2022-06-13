//
//  SpotifyAPIConstants.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 10.06.22.
//

import Foundation

struct SpotifyAPIConstants {
    
    static let clientID = "c59a4896be7047bcb23abe70013fc4e6"
    static let clientSecret = "579cb39eac01484295a44177d8752af3"
    
    static let redirectURI = "https://en.wikipedia.org/wiki/Bulgaria"
    
    static let scopes = "user-read-private" +
    "%20playlist-modify-public" +
    "%20playlist-read-private" +
    "%20playlist-modify-private" +
    "%20user-follow-read" +
    "%20user-library-modify" +
    "%20user-library-read" +
    "%20user-read-email"
    
    struct Endpoints {
        
        // Authorization
        private static let baseAuthURL = "https://accounts.spotify.com"
        static let authorize = baseAuthURL + "/authorize"
        static let token = baseAuthURL + "/api/token"
        
        // API Calls
        private static let baseAPIURL = "https://api.spotify.com/v1"
       
        static let currentUserProfile = baseAPIURL + "/me"
    }
}
