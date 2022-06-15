//
//  RemoveAudioTrackFromPlaylistRequest.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 14.06.22.
//

import Foundation

struct RemoveAudioTrackFromPlaylistRequest: Codable {
    
    let tracks: [RemoveTrackRequest]
    let snapshotId: String
    
    private enum CodingKeys: String, CodingKey {
        case tracks
        case snapshotId = "snapshot_id"
    }
}
