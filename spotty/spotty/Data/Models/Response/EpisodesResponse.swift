//
//  EpisodesResponse.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 14.06.22.
//

import Foundation

/// Specific object returned by the Spotify API. Needed only for parsing API Responses.
struct EpisodesResponse: Codable {
    
    let value: [Episode]
    
    private enum CodingKeys: String, CodingKey {
        case value = "items"
    }
}
