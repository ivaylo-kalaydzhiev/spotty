//
//  SpotifyEndpoint.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 10.06.22.
//

import Foundation

struct SpotifyEndpoint {
    
    let path: String
    let queryItems: [URLQueryItem]
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.spotify.com"
        components.path = path
        components.queryItems = queryItems
        
        return components.url
    }
    
    static func currentUserProfile() -> SpotifyEndpoint {
        
        let endpoint = SpotifyEndpoint(
            path: "/v1/me",
            queryItems: []
        )
        
        return endpoint
    }
    
    static func top(type: TopItemsType,
                    return limit: Int,
                    after offset: Int = 0) -> SpotifyEndpoint {
        
        let endpoint = SpotifyEndpoint(
            path: "/v1/me/top/\(type)",
            queryItems: [
                URLQueryItem(name: "time_range", value: "medium_term"),
                URLQueryItem(name: "limit", value: String(limit)),
                URLQueryItem(name: "offset", value: String(offset))
            ]
        )
        
        return endpoint
    }
}

enum TopItemsType: String {
    
    case tracks
    case artists
}
