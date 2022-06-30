//
//  PlaylistViewModel.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 21.06.22.
//

import UIKit

protocol PlaylistViewModelProtocol {
    
    var playlists: Observable<[Playlist]> { get }
    
    func didSelectPlaylist(at index: Int)
    func didTapProfileButton()
}

class PlaylistViewModel: PlaylistViewModelProtocol {
    
    let playlists = Observable([Playlist]())
    
    weak var delegate: CoreViewModelCoordinatorDelegate?
    
    private let webRepository: WebRepository
    
    init(webRepository: WebRepository = WebRepository()) {
        self.webRepository = webRepository
        
        webRepository.getCurrentUserPlaylists { [weak self] result in
            switch result {
            case .success(let items):
                let playlists = items.value
                self?.playlists.value? = playlists
            case .failure(let error):
                dump(error.localizedDescription)
            }
        }
    }
    
    func didSelectPlaylist(at index: Int) {
        guard let playlist = playlists.value?[safeAt: index] else { fatalError() }
        delegate?.displayDetailListView(with: playlist)
    }
    
    func didTapProfileButton() {
        delegate?.displayProfileScene()
    }
}
