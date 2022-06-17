//
//  MusicViewModel.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 16.06.22.
//

import UIKit

class MusicViewModel {
    
    let featuredPlaylists: Observable<[Playlist]> = Observable([Playlist]())
    let recentlyPlayedTracks: Observable<[AudioTrack]> = Observable([AudioTrack]())
    let recentlyPlayedArtists: Observable<[Artist]> = Observable([Artist]())
    
    private let webRepository = WebRepository()
    
    init() {
        webRepository.getRecentlyPlayedTracks { [weak self] result in
            switch result {
            case .success(let items):
                let wrappedAudioTracks = items.value
                let tracks = wrappedAudioTracks.map { $0.track }
                self?.recentlyPlayedTracks.value? = tracks
                self?.recentlyPlayedArtists.value? = tracks.map { $0.artists[0] }
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
