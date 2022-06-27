//
//  ArtistDetailViewModel.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 24.06.22.
//

import Foundation

class ArtistDetailViewModel: DetailListViewModelProtocol {
    
    var imageURL = Observable("")
    var title = Observable("Top Tracks")
    var items: Observable<[BusinessModel]> = Observable([AudioTrack]())
    
    private let webRepository: WebRepository
    
    init(webRepository: WebRepository = WebRepository()) {
        self.webRepository = webRepository
        
        webRepository.getArtist { [weak self] result in
            switch result {
            case .success(let artist):
                self?.imageURL.value = artist.imageURL
            case .failure(let error):
                dump(error.localizedDescription)
            }
        }
        webRepository.getArtistTopTracks { [weak self] result in
            switch result {
            case .success(let tracks):
                let unwrappedAudioTracks = tracks.tracks
                self?.items.value = unwrappedAudioTracks
            case .failure(let error):
                dump(error.localizedDescription)
            }
        }
    }
}
