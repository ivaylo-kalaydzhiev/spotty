//
//  ShowsViewModel.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 21.06.22.
//

import UIKit

// TODO: Create protocol
class ShowsViewModel {
    
    let savedShows: Observable<[Show]> = Observable([Show]())
    let savedEpisodes: Observable<[Episode]> = Observable([Episode]())
    
    private let webRepository = WebRepository()
    
    init() {
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
