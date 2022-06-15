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
        let urlRequest = SpotifyEndpoint.getCurrentUserProfile.urlRequest
        Network.performAuthorizedRequest(with: urlRequest, completion: completion)
    }
    
    func getCurrentUserTopTracks(completion: @escaping (Result<ItemsResponse<AudioTrack>, Error>) -> Void) {
        let urlRequest = SpotifyEndpoint.getCurrentUserTopTracks(limit: 49).urlRequest
        Network.performAuthorizedRequest(with: urlRequest, completion: completion)
    }
    
    func getCurrentUserTopArtists(completion: @escaping (Result<ItemsResponse<Artist>, Error>) -> Void) {
        let urlRequest = SpotifyEndpoint.getCurrentUserTopArtists(limit: 49).urlRequest
        Network.performAuthorizedRequest(with: urlRequest, completion: completion)
    }
    
    func getCurrentUserPlaylists(completion: @escaping (Result<ItemsResponse<Playlist>, Error>) -> Void) {
        let urlRequest = SpotifyEndpoint.getCurrentUserPlaylists(limit: 49).urlRequest
        Network.performAuthorizedRequest(with: urlRequest, completion: completion)
    }
}
