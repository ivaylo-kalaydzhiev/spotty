//
//  EpisodeDetailViewModel.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 24.06.22.
//

import Foundation

class EpisodeDetailViewModel: DetailItemViewModelProtocol {

    var imageURL = Observable("")
    var title = Observable("")
    var description = Observable("")
    
    private let webRepository: WebRepository
        
    init(webRepository: WebRepository = WebRepository()) {
        self.webRepository = webRepository
        
        webRepository.getEpisode { [weak self] result in
            switch result {
            case .success(let episode):
                self?.imageURL.value = episode.images[0].url
                self?.title.value = episode.name
                self?.description.value = episode.htmlDescription
            case .failure(let error):
                dump(error.localizedDescription)
            }
        }
    }
}
