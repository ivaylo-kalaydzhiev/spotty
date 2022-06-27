//
//  ShowDetailViewModel.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 24.06.22.
//

import Foundation

class ShowDetailViewModel: DetailListViewModelProtocol {
    
    var imageURL = Observable("")
    var title = Observable("Episodes")
    var items: Observable<[BusinessModel]> = Observable([Episode]())
    
    private let webRepository: WebRepository
    
    init(webRepository: WebRepository = WebRepository()) {
        self.webRepository = webRepository
        
        webRepository.getShow { [weak self] result in
            switch result {
            case .success(let show):
                self?.imageURL.value = show.imageURL
            case .failure(let error):
                dump(error.localizedDescription)
            }
        }
        webRepository.getShowEpisodes { [weak self] result in
            switch result {
            case .success(let episodes):
                self?.items.value = episodes.value
            case .failure(let error):
                dump(error.localizedDescription)
            }
        }
    }
}
