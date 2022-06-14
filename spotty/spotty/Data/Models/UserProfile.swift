//
//  UserProfile.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 13.06.22.
//

import Foundation

struct UserProfile: Codable {
    
    let id: String
    let spotifyURI: String
    let email: String?
    let displayName: String
    let images: [ImageResponse]?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case spotifyURI = "uri"
        case email
        case displayName = "display_name"
        case images
    }
}
