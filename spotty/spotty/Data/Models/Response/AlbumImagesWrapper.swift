//
//  AlbumRequest.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 14.06.22.
//

import Foundation

struct AlbumImagesWrapper: Codable, Hashable {
    
    private let images: [ImageResponse]
    
    var imageURL: String { images[safeAt: 0]?.url ?? "" }
}
