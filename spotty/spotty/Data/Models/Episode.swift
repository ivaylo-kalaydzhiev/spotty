//
//  Episode.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 14.06.22.
//

import Foundation

struct Episode: Codable {
    
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
