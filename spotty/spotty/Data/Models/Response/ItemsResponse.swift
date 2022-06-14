//
//  ItemsResponse.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 14.06.22.
//

import Foundation

/// Specific object returned by the Spotify API. Needed only for parsing API Responses.
struct ItemsResponse<T: Codable>: Codable {
    
    let value: [T]
    
    private enum CodingKeys: String, CodingKey {
        case value = "items"
    }
}
