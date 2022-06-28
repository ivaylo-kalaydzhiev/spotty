//
//  Artist.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 14.06.22.
//

import Foundation

struct Artist: Codable, Hashable, BusinessModel {
    
    let uuid = UUID() // TODO: Deal with it and remove it.
    let name: String
    let images: [ImageResponse]?
    let genres: [String]?
}
