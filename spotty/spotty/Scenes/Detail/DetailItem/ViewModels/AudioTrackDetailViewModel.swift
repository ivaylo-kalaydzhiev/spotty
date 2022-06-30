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
    
    weak var delegate: CoreViewModelCoordinatorDelegate?
    
    private let webRepository: WebRepository
    
    init(webRepository: WebRepository = WebRepository(), of audioTrack: AudioTrack) {
        self.webRepository = webRepository
        
        webRepository.getAudioTrack(audioTrackId: audioTrack.id) { [weak self] result in
            switch result {
            case .success(let track):
                self?.imageURL.value = track.album.imageURL
                self?.title.value = track.name
                // TODO: Description should be lyrics https://developer.musixmatch.com/
            case .failure(let error):
                dump(error.localizedDescription)
            }
        }
    }
    
    func dismissView() {
        delegate?.dismissView()
    }
}
