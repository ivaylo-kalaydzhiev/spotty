//
//  EpisodeDetailViewModel.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 24.06.22.
//

import UIKit

class EpisodeDetailViewModel: DetailItemViewModelProtocol {

    var imageSource = Observable(UIImage())
    var title = Observable("")
    var description = Observable("")
    
    private let webRepository: WebRepository
    
    // TODO: Make it work with real data
    init(webRepository: WebRepository = WebRepository()) {
        self.webRepository = webRepository
        
        webRepository.getEpisode { result in
            switch result {
            case .success(let episode):
                self.imageSource.value = UIImage.getImage(from: episode.images[0].url)
                self.title.value = episode.name
                self.description.value = episode.htmlDescription
            case .failure(let error):
                dump(error.localizedDescription)
            }
        }
    }
}
