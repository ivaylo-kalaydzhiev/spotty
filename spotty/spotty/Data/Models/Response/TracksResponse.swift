//
//  TracksResponse.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 13.06.22.
//

import Foundation

/// Specific object returned by the Spotify API. Needed only for parsing API Responses.
struct TracksResponse: Codable {
    
    let tracks: [AudioTrack]
    
    private enum CodingKeys: String, CodingKey {
        case tracks = "items"
    }
}

