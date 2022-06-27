//
//  PlaylistDetailViewModel.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 22.06.22.
//

import Foundation

class PlaylistDetailViewModel: DetailListViewModelProtocol {
    
    var imageURL = Observable("")
    var title = Observable("Tracks")
    var items: Observable<[BusinessModel]> = Observable([AudioTrack]())
    
    private let webRepository: WebRepository
    
    init(webRepository: WebRepository = WebRepository()) {
        self.webRepository = webRepository
        
        webRepository.getPlaylist { [weak self] result in
            switch result {
            case .success(let playlist):
                self?.imageURL.value = playlist.images[0].url
            case .failure(let error):
                dump(error.localizedDescription)
            }
        }
        webRepository.getPlaylistTracks { [weak self] result in
            switch result {
            case .success(let tracks):
                let wrappedTracks = tracks.value
                let unwrappedTracks = wrappedTracks.map { $0.track }
                self?.items.value = unwrappedTracks
            case .failure(let error):
                dump(error.localizedDescription)
            }
        }
    }
}
