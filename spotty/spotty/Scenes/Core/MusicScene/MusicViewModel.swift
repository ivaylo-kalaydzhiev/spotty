//
//  MusicViewModel.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 16.06.22.
//

import UIKit

class MusicViewModel {
    
    let recentlyPlayedTracks: Observable<[AudioTrack]> = Observable([AudioTrack]())
    let featuredPlaylists: Observable<[Playlist]> = Observable([Playlist]())
    
    private let webRepository = WebRepository()
    
    init() {
        webRepository.getRecentlyPlayedTracks { [weak self] result in
            switch result {
            case .success(let items):
                let wrappedAudioTracks = items.value
                self?.recentlyPlayedTracks.value? = wrappedAudioTracks.map { $0.track }
            case .failure(let error):
                dump(error.localizedDescription)
            }
        }
        webRepository.getFeaturedPlaylists { [weak self] result in
            switch result {
            case .success(let playlistResponse):
                self?.featuredPlaylists.value? = playlistResponse.playlists.value
            case .failure(let error):
                dump(error.localizedDescription)
            }
        }
    }
}
