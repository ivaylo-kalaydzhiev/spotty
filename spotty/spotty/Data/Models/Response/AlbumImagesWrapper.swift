//
//  AlbumRequest.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 14.06.22.
//

import Foundation

struct AlbumImagesWrapper: Codable, Hashable {
    
    let uuid = UUID()
    let images: [ImageResponse]
}
