//
//  Artist.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 14.06.22.
//

import Foundation

struct Artist: Codable {
    
    let name: String
    let images: [ImageResponse]
    let genres: [String]
}