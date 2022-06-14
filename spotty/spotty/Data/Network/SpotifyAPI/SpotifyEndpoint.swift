//
//  SpotifyEndpoint.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 10.06.22.
//

import Foundation

enum SpotifyEndpoint {
    
    // MARK: - Cases
    
    case getCurrentUserProfile
    case getCurrentUserTopTracks(limit: Int, offset: Int = 0)
    case getCurrentUserTopArtists(limit: Int, offset: Int = 0)
    
    // MARK: - Private properties
    
    private var scheme: String {
        switch self {
        default:
            return "https"
        }
    }
    
    private var host: String {
        switch self {
        default:
            return "api.spotify.com"
        }
    }
    
    private var path: String {
        switch self {
        case .getCurrentUserProfile:
            return "/v1/me"
        case .getCurrentUserTopTracks:
            return "/v1/me/top/tracks"
        case .getCurrentUserTopArtists:
            return "/v1/me/top/artists"
        }
    }
    
    private var queryItems: [URLQueryItem] {
        switch self {
        case .getCurrentUserProfile:
            return []
        case .getCurrentUserTopTracks(let limit, let offset), .getCurrentUserTopArtists(let limit, let offset):
            return [
                URLQueryItem(name: "time_range", value: "long_term"),
                URLQueryItem(name: "limit", value: String(limit)),
                URLQueryItem(name: "offset", value: String(offset))
            ]
        }
    }
    
    // MARK: - Exposed properties
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = self.scheme
        components.host = self.host
        components.path = self.path
        components.queryItems = self.queryItems
        
        return components.url
    }
}
