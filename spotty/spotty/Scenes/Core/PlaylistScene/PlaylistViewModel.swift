//
//  PlaylistViewModel.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 21.06.22.
//

import UIKit

protocol PlaylistViewModelProtocol {
    
    var playlists: Observable<[Playlist]> { get }
}

class PlaylistViewModel: PlaylistViewModelProtocol {
    
    let playlists = Observable([Playlist]())
    
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
}
