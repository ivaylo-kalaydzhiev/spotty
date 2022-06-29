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
    
    weak var delegate: CoreViewModelCoordinatorDelegate?
    
    private let webRepository: WebRepository
    
    init(webRepository: WebRepository = WebRepository(), of show: Show) {
        self.webRepository = webRepository
        configure(with: show)
    }
    
    func configure(with show: Show) {
        webRepository.getShow(showId: show.id) { [weak self] result in
            switch result {
            case .success(let show):
                self?.imageURL.value = show.imageURL
                self?.setEpisodes(id: show.id)
            case .failure(let error):
                dump(error.localizedDescription)
            }
        }
    }
    
    private func setEpisodes(id: String) {
        webRepository.getShowEpisodes(showId: id) { [weak self] result in
            switch result {
            case .success(let episodes):
                self?.items.value = episodes.value
            case .failure(let error):
                dump(error.localizedDescription)
            }
        }
    }
    
    func dismissView() {
        delegate?.dismissDetailView()
    }
    
    func didSelectItem(at index: Int) {
        guard let episode = items.value?[safeAt: index] else { fatalError() }
        delegate?.displayDetailItemView(with: episode)
    }
}
