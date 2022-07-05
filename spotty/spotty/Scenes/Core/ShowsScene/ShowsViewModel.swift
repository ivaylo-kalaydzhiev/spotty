//
//  ShowsViewModel.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 21.06.22.
//

import UIKit

protocol ShowsViewModelProtocol {
    
    var savedShows: Observable<[Show]> { get }
    var savedEpisodes: Observable<[Episode]> { get }
    var screenTitle: String { get }
    
    func didSelectShow(at index: Int)
    func didSelectEpisode(at index: Int)
    func didTapProfileButton()
}

class ShowsViewModel: ShowsViewModelProtocol {
    
    let savedShows = Observable([Show]())
    let savedEpisodes = Observable([Episode]())
    let screenTitle = Constant.SceneTitle.show
    
    weak var delegate: CoreViewModelCoordinatorDelegate?
    
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
    
    func didSelectShow(at index: Int) {
        guard let show = savedShows.value?[safeAt: index] else { fatalError() }
        delegate?.displayDetailListView(with: show)
    }
    
    func didSelectEpisode(at index: Int) {
        guard let episode = savedEpisodes.value?[safeAt: index] else { fatalError() }
        delegate?.displayDetailItemView(with: episode)
    }
    
    func didTapProfileButton() {
        delegate?.displayProfileScene()
    }
}
