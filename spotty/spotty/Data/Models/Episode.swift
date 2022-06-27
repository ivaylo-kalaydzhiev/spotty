//
//  Episode.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 14.06.22.
//

import Foundation

struct Episode: Codable, Hashable, BusinessModel {
    
    let description: String
    let htmlDescription: String
    let id: String
    private let images: [ImageResponse]
    let name: String
    let releaseDate: String
    let uri: String
    
    private enum CodingKeys: String, CodingKey {
        case description
        case htmlDescription = "html_description"
        case id
        case images
        case name
        case releaseDate = "release_date"
        case uri
    }
    
    
    var imageURL: String {
        guard let image = images[safeAt: 0] else { return "" }
        return image.url
    }
}
