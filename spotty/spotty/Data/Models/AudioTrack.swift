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

//extension AudioTrack {
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(album)
//        hasher.combine(id)
//        hasher.combine(name)
//        hasher.combine(uri)
//        hasher.combine(artists)
//    }
//    
//    static func ==(lhs: AudioTrack, rhs: AudioTrack) -> Bool {
//        lhs.album == rhs.album &&
//        lhs.id == rhs.id &&
//        lhs.name == rhs.name &&
//        lhs.uri == rhs.uri &&
//        lhs.artists == rhs.artists
//    }
//}
