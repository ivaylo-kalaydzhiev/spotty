//
//  PlaylistDetailViewModel.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 22.06.22.
//

import UIKit

class PlaylistDetailViewModel: DetailViewModeProtocol {
    
    var imageSource = Observable(UIImage())
    var title = Observable("Tracks")
    var items = Observable([AudioTrack]())
    
    private let webRepository: WebRepository
    
    // TODO: Make it work with real data
    init(webRepository: WebRepository = WebRepository()) {
        self.webRepository = webRepository
        
        webRepository.getPlaylist { result in
            switch result {
            case .success(let playlist):
                self.imageSource.value = UIImage.getImage(from: playlist.images[0].url)
            case .failure(let error):
                dump(error.localizedDescription)
            }
        }
        webRepository.getPlaylistTracks { result in
            switch result {
            case .success(let tracks):
                let wrappedTracks = tracks.value
                let unwrappedTracks = wrappedTracks.map { $0.track }
                self.items.value = unwrappedTracks
            case .failure(let error):
                dump(error.localizedDescription)
            }
        }
    }
}
