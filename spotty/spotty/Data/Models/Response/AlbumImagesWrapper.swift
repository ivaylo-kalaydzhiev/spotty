//
//  AlbumRequest.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 14.06.22.
//

import Foundation

struct AlbumImagesWrapper: Codable, Hashable {
    
    let uuid = UUID() // TODO: Remove!!!
    private let images: [ImageResponse]
    
    var imageURL: String {
        guard let image = images[safeAt: 0] else { return "" }
        return image.url
    }
}
