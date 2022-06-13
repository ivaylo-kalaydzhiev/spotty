//
//  TopArtistsResponse.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 13.06.22.
//

import Foundation

struct TopArtistsResponse: Codable {
    
    let artists: [Artist]
    
    private enum CodingKeys: String, CodingKey {
        case artists = "items"
    }
}

struct Artist: Codable {
    
    let name: String
    let images: [SpotifyImage]
    let genres: [String]
}
