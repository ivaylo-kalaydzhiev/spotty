//
//  WebRepository.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 13.06.22.
//

import Foundation

struct WebRepository {
    
    func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        let url = URL(string: SpotifyAPIConstants.Endpoints.currentUserProfile)
        Network.performAuthorizedRequest(with: url, httpMethod: .GET, completion: completion)
    }
    
    func getCurrentUserTopTracks(completion: @escaping (Result<TopTracksResponse, Error>) -> Void) {
        let url = URL(string: SpotifyAPIConstants.Endpoints.currentUserTopTracks)
        Network.performAuthorizedRequest(with: url, httpMethod: .GET, completion: completion)
    }
}
