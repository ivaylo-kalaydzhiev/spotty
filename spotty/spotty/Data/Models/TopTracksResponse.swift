//
//  TopTracksResponse.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 13.06.22.
//

import Foundation

struct TopTracksResponse: Codable {
    
    let tracks: [AudioTrack]
    
    private enum CodingKeys: String, CodingKey {
        case tracks = "items"
    }
}

struct AudioTrack: Codable {
    
    let album: Album
    let name: String
}

struct Album: Codable {
    
    let images: [SpotifyImage]
}
