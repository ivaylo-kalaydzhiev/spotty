//
//  AudioTrackDetailViewMode.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 24.06.22.
//

import Foundation

class AudioTrackDetailViewModel: DetailItemViewModelProtocol {

    var imageURL = Observable("")
    var title = Observable("")
    var description = Observable("")
    
    private let webRepository: WebRepository
    
    init(webRepository: WebRepository = WebRepository()) {
        self.webRepository = webRepository
        
        webRepository.getAudioTrack { [weak self] result in
            switch result {
            case .success(let track):
                self?.imageURL.value = track.album.images[0].url
                self?.title.value = track.name
                // TODO: Description should be lyrics https://developer.musixmatch.com/
            case .failure(let error):
                dump(error.localizedDescription)
            }
        }
    }
}
