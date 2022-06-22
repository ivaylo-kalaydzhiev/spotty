//
//  PlaylistDetailViewModel.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 22.06.22.
//

import UIKit

protocol PlaylistDetailViewModelProtocol {
    
    var playlist: Observable<Playlist> { get }
    var tracks: Observable<[AudioTrack]> { get }
}

class PlaylistDetailViewModel: PlaylistDetailViewModelProtocol {
    
    // TODO: Below is crazy
    let playlist = Observable(Playlist(description: nil, id: "fake", images: [ImageResponse(url: "", height: nil, width: nil)], owner: UserProfile(id: "", spotifyURI: "", email: "", displayName: "", images: nil), snapshotId: "", uri: ""))
    let tracks = Observable([AudioTrack]())
    
    private let webRepository: WebRepository
    
    // TODO: Make it work with real data
    init(webRepository: WebRepository = WebRepository()) {
        self.webRepository = webRepository
        
        webRepository.getPlaylist { result in
            switch result {
            case .success(let playlist):
                self.playlist.value = playlist
            case .failure(let error):
                dump(error.localizedDescription)
            }
        }
        webRepository.getPlaylistTracks { result in
            switch result {
            case .success(let tracks):
                let wrappedTracks = tracks.value
                let unwrappedTracks = wrappedTracks.map { $0.track }
                self.tracks.value = unwrappedTracks
            case .failure(let error):
                dump(error.localizedDescription)
            }
        }
    }
}
