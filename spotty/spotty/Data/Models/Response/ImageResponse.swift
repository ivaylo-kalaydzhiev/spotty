//
//  ImageResponse.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 14.06.22.
//

import Foundation

/// Specific object returned by the Spotify API. Needed only for parsing API Responses.
struct ImageResponse: Codable {
    
    let url: String
    let height: Int
    let width: Int
}
