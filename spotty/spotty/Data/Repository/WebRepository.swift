//
//  WebRepository.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 13.06.22.
//

import Foundation

struct WebRepository {
    
    func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        let endpoint = SpotifyEndpoint.currentUserProfile()
        let url = endpoint.url
        Network.performAuthorizedRequest(with: url, httpMethod: .GET, completion: completion)
    }
    
    func getCurrentUserTopTracks(completion: @escaping (Result<TopTracksResponse, Error>) -> Void) {
        let endpoint = SpotifyEndpoint.top(type: .tracks, return: 2)
        let url = endpoint.url
        Network.performAuthorizedRequest(with: url, httpMethod: .GET, completion: completion)
    }
    
    func getCurrentUserTopArtists(completion: @escaping (Result<TopArtistsResponse, Error>) -> Void) {
        let endpoint = SpotifyEndpoint.top(type: .artists, return: 2)
        let url = endpoint.url
        Network.performAuthorizedRequest(with: url, httpMethod: .GET, completion: completion)
    }
}
