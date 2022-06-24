//
//  ShowDetailViewModel.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 24.06.22.
//

import UIKit

class ShowDetailViewModel: DetailListViewModelProtocol {
    
    typealias ItemType = Episode
    
    var imageSource = Observable(UIImage())
    var title = Observable("Episodes")
    var items = Observable([ItemType]())
    
    private let webRepository: WebRepository
    
    // TODO: Make it work with real data
    init(webRepository: WebRepository = WebRepository()) {
        self.webRepository = webRepository
        
        webRepository.getShow { result in
            switch result {
            case .success(let show):
                self.imageSource.value = UIImage.getImage(from: show.images[0].url)
            case .failure(let error):
                dump(error.localizedDescription)
            }
        }
        webRepository.getShowEpisodes { result in
            switch result {
            case .success(let episodes):
                self.items.value = episodes.value
            case .failure(let error):
                dump(error.localizedDescription)
            }
        }
    }
}
