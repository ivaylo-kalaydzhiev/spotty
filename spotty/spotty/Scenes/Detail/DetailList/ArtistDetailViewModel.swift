//
//  ArtistDetailViewModel.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 24.06.22.
//

import UIKit

class ArtistDetailViewModel: DetailListViewModelProtocol {
    
    typealias ItemType = AudioTrack
    
    var imageSource = Observable(UIImage())
    var title = Observable("Episodes")
    var items = Observable([ItemType]())
    
    private let webRepository: WebRepository
    
    // TODO: Make it work with real data
    init(webRepository: WebRepository = WebRepository()) {
        self.webRepository = webRepository
        
        webRepository.getArtist { result in
            switch result {
            case .success(let artist):
                guard let images = artist.images,
                      let imageModel = images[safeAt: 0] else { return }
                self.imageSource.value = UIImage.getImage(from: imageModel.url)
            case .failure(let error):
                dump(error.localizedDescription)
            }
        }
        webRepository.getArtistTopTracks { result in
            switch result {
            case .success(let tracks):
                let unwrappedAudioTracks = tracks.tracks
                self.items.value = unwrappedAudioTracks
            case .failure(let error):
                dump(error.localizedDescription)
            }
        }
    }
}
