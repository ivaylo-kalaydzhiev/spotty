//
//  AudioTrack.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 14.06.22.
//

import Foundation

struct AudioTrack: Codable {
    
    let album: AlbumRequest
    let id: String
    let name: String
    let uri: String
}
