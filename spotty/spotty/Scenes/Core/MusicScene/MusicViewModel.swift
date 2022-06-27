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
    
    func didSelectItem(at index: Int)
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
                let artistWithoutImages = tracks.map { $0.artists[0] }.uniqued()
                self?.getArtistModelsWithImages(artists: artistWithoutImages)
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
    
    private func getArtistModelsWithImages(artists: [Artist]) {
        for artist in artists {
            webRepository.getArtist(artistId: artist.id) { [weak self] result in
                switch result {
                case .success(let artist):
                    self?.recentlyPlayedArtists.value?.append(artist)
                case .failure(let error):
                    dump(error.localizedDescription)
                }
            }
        }
    }
    
    func didSelectItem(at index: Int) {
        guard let playlists = featuredPlaylists.value,
              let playlist = playlists[safeAt: index]
        else { return }
        
        // Display DetailListViewController with needed playlist.
        let viewModel = PlaylistDetailViewModel(playlist: playlist)
        let viewController = DetailListViewController()
    }
}
