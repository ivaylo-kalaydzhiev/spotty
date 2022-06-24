//
//  Episode.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 14.06.22.
//

import Foundation

struct Episode: Codable, Hashable, BusinessModel {
    
    let description: String
    let id: String
    let images: [ImageResponse]
    let name: String
    let releaseDate: String
    let uri: String
    
    private enum CodingKeys: String, CodingKey {
        case description
        case id
        case images
        case name
        case releaseDate = "release_date"
        case uri
    }
}
//
//extension Episode {
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(description)
//        hasher.combine(id)
//        hasher.combine(images)
//        hasher.combine(name)
//        hasher.combine(releaseDate)
//        hasher.combine(uri)
//    }
//    
//    static func ==(lhs: Episode, rhs: Episode) -> Bool {
//        lhs.description == rhs.description &&
//        lhs.id == rhs.id &&
//        lhs.images == rhs.images &&
//        lhs.name == rhs.name &&
//        lhs.releaseDate == rhs.releaseDate &&
//        lhs.uri == rhs.uri
//    }
//}
