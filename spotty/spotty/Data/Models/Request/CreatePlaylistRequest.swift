//
//  CreatePlaylistRequest.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 15.06.22.
//

import Foundation

struct CreatePlaylistRequest: Codable {
    
    let name: String
    let description: String
}
