//
//  WebRepository.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 13.06.22.
//

import Foundation

// TODO: One Repository, that implements multiple protocols. Maybe name them like Spotify names them in it Docs.
struct WebRepository {
    
    func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        let url = SpotifyEndpoint.getCurrentUserProfile.url
        Network.performAuthorizedRequest(with: url, httpMethod: .GET, completion: completion)
    }
    
    func getCurrentUserTopTracks(completion: @escaping (Result<ItemsResponse<AudioTrack>, Error>) -> Void) {
        let url = SpotifyEndpoint.getCurrentUserTopTracks(limit: 49).url
        Network.performAuthorizedRequest(with: url, httpMethod: .GET, completion: completion)
    }
    
    func getCurrentUserTopArtists(completion: @escaping (Result<ItemsResponse<Artist>, Error>) -> Void) {
        let url = SpotifyEndpoint.getCurrentUserTopArtists(limit: 49).url
        Network.performAuthorizedRequest(with: url, httpMethod: .GET, completion: completion)
    }
}
