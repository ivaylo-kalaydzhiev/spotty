//
//  Album.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 14.06.22.
//

import Foundation

struct Album: Codable {
    
    let id: String
    let images: [ImageResponse]
    let name: String
    let uri: String
    let tracks: ItemsResponse<AudioTrack>
}
