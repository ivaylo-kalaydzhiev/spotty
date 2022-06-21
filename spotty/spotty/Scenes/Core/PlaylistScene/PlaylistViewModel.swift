//
//  PlaylistViewModel.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 21.06.22.
//

import UIKit

// TODO: Create protocol
class PlayilstViewModel {
    
    let playlists: Observable<[Playlist]> = Observable([Playlist]())
    
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
