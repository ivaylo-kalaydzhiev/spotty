//
//  Show.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 14.06.22.
//

import Foundation

struct Show: Codable, Hashable, BusinessModel {
    
    let description: String
    let id: String
    let uri: String
    let episodes: ItemsResponse<Episode>?
    private let images: [ImageResponse]
    
    var imageURL: String { images[safeAt: 0]?.url ?? "" }
}
