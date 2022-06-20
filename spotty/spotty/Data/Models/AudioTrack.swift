//
//  AudioTrack.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 14.06.22.
//

import Foundation

struct AudioTrack: Codable, Hashable, BusinessModel {
    
    let album: AlbumImagesWrapper
    let id: String
    let name: String
    let uri: String
    let artists: [Artist]
}
