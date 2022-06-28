//
//  ShowsViewModel.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 21.06.22.
//

import UIKit

protocol ShowsViewModelProtocol {
    
    var title: String { get }
    var savedShows: Observable<[Show]> { get }
    var savedEpisodes: Observable<[Episode]> { get }
}

class ShowsViewModel: ShowsViewModelProtocol {
    
    let title = Constant.SceneTitle.show
    let savedShows = Observable([Show]())
    let savedEpisodes = Observable([Episode]())
    
    private let webRepository: WebRepository
    
    init(webRepository: WebRepository = WebRepository()) {
        self.webRepository = webRepository
        
        webRepository.getUserSavedShows { [weak self] result in
            switch result {
            case .success(let items):
                let wrappedShows = items.value
                let shows = wrappedShows.map { $0.show }
                self?.savedShows.value? = shows
            case .failure(let error):
                dump(error.localizedDescription)
            }
        }
        webRepository.getUserSavedEpisodes { [weak self] result in
            switch result {
            case .success(let items):
                let wrappedEpisodes = items.value
                let episodes = wrappedEpisodes.map { $0.episode }
                self?.savedEpisodes.value? = episodes
            case .failure(let error):
                dump(error.localizedDescription)
            }
        }
    }
}
