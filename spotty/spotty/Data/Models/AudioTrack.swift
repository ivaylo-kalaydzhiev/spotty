//
//  AudioTrack.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 14.06.22.
//

import Foundation

struct AudioTrack: Codable {
    
    let album: AlbumJustForImages
    let id: String
    let name: String
    let uri: String
}

struct AlbumJustForImages: Codable {
    
    let images: [ImageResponse]
}
