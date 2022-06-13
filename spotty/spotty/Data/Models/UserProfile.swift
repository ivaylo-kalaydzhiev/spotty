//
//  UserProfile.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 13.06.22.
//

import Foundation

struct UserProfile: Codable {

    let country: String
    let displayName: String
    let email: String
    let externalURLs: [String: String]
    let id: String
    let product: String
    let images: [SpotifyImage]

    private enum CodingKeys: String, CodingKey {
        case country = "country"
        case displayName = "display_name"
        case email = "email"
        case externalURLs = "external_urls"
        case id = "id"
        case product = "product"
        case images = "images"
    }
}

struct SpotifyImage: Codable {

    let url: String
}
