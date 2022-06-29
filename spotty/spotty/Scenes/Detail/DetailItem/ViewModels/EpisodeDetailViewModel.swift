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
    
    init(webRepository: WebRepository = WebRepository(), of episode: Episode) {
        self.webRepository = webRepository
        configure(with: episode)
    }
    
    private func configure(with episode: Episode) {
        webRepository.getEpisode(episodeId: episode.id) { [weak self] result in
            switch result {
            case .success(let episode):
                self?.imageURL.value = episode.imageURL
                self?.title.value = episode.name
                self?.description.value = episode.htmlDescription
            case .failure(let error):
                dump(error.localizedDescription)
            }
        }
    }
}
