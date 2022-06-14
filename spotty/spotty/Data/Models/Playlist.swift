//
//  Playlist.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 14.06.22.
//

import Foundation

struct Playlist: Codable {
    
    let description: String?
    let id: String
    let images: [ImageResponse]
    let owner: UserProfile
    let snapshotId: String
    let tracks: TracksResponse
    let uri: String
    
    private enum CodingKeys: String, CodingKey {
        case description
        case id
        case images
        case owner
        case snapshotId = "snapshot_id"
        case tracks
        case uri
    }
}
