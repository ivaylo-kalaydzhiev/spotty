//
//  Show.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 14.06.22.
//

import Foundation

struct Show: Codable, Hashable {
    
    let description: String
    let id: String
    let images: [ImageResponse]
    let uri: String
    let episodes: ItemsResponse<Episode>?
}
