//
//  SpotifyRequestTrack.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 14.06.22.
//

import Foundation

// TODO: Remove?
struct SpotifyRequestTrack: Codable {
    // { "tracks": [{ "uri": "spotify:track:4iV5W9uYEdYUVa79Axb7Rh" },{ "uri": "spotify:track:1301WleyT98MSxVHPZCA6M" }] }
    let uri: String
}
