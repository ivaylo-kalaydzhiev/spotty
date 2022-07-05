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
    let genres: [String]?
    private let images: [ImageResponse]?
    
    var imageURL: String { images?[safeAt: 0]?.url ?? "" }
}
