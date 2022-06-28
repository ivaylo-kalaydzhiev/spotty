//
//  Playlist.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 14.06.22.
//

import Foundation

struct Playlist: Codable, Hashable, BusinessModel {
    
    let description: String?
    let id: String
    let owner: UserProfile
    let snapshotId: String
    let uri: String
    private let images: [ImageResponse]
    
    var imageURL: String {
        images[safeAt: 0]?.url ?? ""
    }
   
    private enum CodingKeys: String, CodingKey {
        case description
        case id
        case images
        case owner
        case snapshotId = "snapshot_id"
        case uri
    }
    
}
