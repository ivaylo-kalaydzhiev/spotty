//
//  PlaylistChangedResponse.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 15.06.22.
//

import Foundation

struct PlaylistChangedResponse: Codable {
    
    let snapshotId: String
    
    private enum CodingKeys: String, CodingKey {
        case snapshotId = "snapshot_id"
    }
}
