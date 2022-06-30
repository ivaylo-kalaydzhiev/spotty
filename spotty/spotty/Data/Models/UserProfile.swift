//
//  UserProfile.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 13.06.22.
//

import Foundation

struct UserProfile: Codable, Hashable {
    
    let id: String
    let spotifyURI: String
    let email: String?
    let displayName: String
    private let images: [ImageResponse]?
    
    var imageURL: String { images?[safeAt: 0]?.url ?? "" }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case spotifyURI = "uri"
        case email
        case displayName = "display_name"
        case images
    }
}
