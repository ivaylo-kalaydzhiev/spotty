//
//  Artist.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 14.06.22.
//

import Foundation

struct Artist: Codable, Hashable, BusinessModel {
    
    let id: String
    let name: String
    private let images: [ImageResponse]?
    let genres: [String]?
    
    var imageURL: String {
        guard let images = images,
              let image = images[safeAt: 0]
        else { return "" }
        
        return image.url
    }
}
