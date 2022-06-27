//
//  MusicViewModel.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 16.06.22.
//

import UIKit

protocol MusicViewModelProtocol {
    
    var featuredPlaylists: Observable<[Playlist]> { get }
    var recentlyPlayedTracks: Observable<[AudioTrack]> { get }
    var recentlyPlayedArtists: Observable<[Artist]> { get }
}

class MusicViewModel: MusicViewModelProtocol {
    
    let featuredPlaylists = Observable([Playlist]())
    let recentlyPlayedTracks = Observable([AudioTrack]())
    let recentlyPlayedArtists = Observable([Artist]())
    
    private let webRepository: WebRepository
    
    init(webRepository: WebRepository = WebRepository()) { // TODO: Extract start()
        self.webRepository = webRepository
        
        webRepository.getRecentlyPlayedTracks { [weak self] result in
            switch result {
            case .success(let items):
                let wrappedAudioTracks = items.value
                let tracksWithDuplicates = wrappedAudioTracks.map { $0.track }
                let tracks = tracksWithDuplicates.uniqued()
                self?.recentlyPlayedTracks.value? = tracks
                self?.recentlyPlayedArtists.value? = tracks.map { $0.artists[0] }.uniqued()
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
        // TODO: Get pictures for the artists. Then, you can display them in the VC.
    }
}
