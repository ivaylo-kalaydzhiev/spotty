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
    private let images: [ImageResponse]
    let uri: String
    let episodes: ItemsResponse<Episode>?
    
    var imageURL: String {
        guard let image = images[safeAt: 0] else { return "" }
        return image.url
    }
}
