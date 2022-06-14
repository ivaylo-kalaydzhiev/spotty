//
//  ArtistsResponse.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 13.06.22.
//

import Foundation

/// Specific object returned by the Spotify API. Needed only for parsing API Responses.
struct ArtistsResponse: Codable {
    
    let artists: [Artist]
    
    private enum CodingKeys: String, CodingKey {
        case artists = "items"
    }
}
