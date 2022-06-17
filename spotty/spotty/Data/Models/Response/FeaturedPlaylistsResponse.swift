//
//  FeaturedPlaylistsResponse.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 15.06.22.
//

import Foundation

struct FeaturedPlaylistsResponse: Codable, Hashable {
    
    let message: String
    let playlists: ItemsResponse<Playlist>
}
