//
//  AudioTrackDetailViewMode.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 24.06.22.
//

import UIKit

class AudioTrackDetailViewModel: DetailItemViewModelProtocol {

    var imageSource = Observable(UIImage())
    var title = Observable("")
    var description = Observable("")
    
    private let webRepository: WebRepository
    
    // TODO: Make it work with real data
    init(webRepository: WebRepository = WebRepository()) {
        self.webRepository = webRepository
        
        webRepository.getAudioTrack { result in
            switch result {
            case .success(let track):
                self.imageSource.value = UIImage.getImage(from: track.album.images[0].url)
                self.title.value = track.name
                // TODO: Description should be lyrics https://developer.musixmatch.com/
            case .failure(let error):
                dump(error.localizedDescription)
            }
        }
    }
}
