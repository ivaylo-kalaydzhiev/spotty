//
//  PlaylistDetailViewModel.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 22.06.22.
//

import Foundation

class PlaylistDetailViewModel: DetailListViewModelProtocol {
    
    var imageURL = Observable("")
    var title = Observable("Tracks")
    var items: Observable<[BusinessModel]> = Observable([AudioTrack]())
    
    weak var delegate: CoreViewModelCoordinatorDelegate?
    
    private let webRepository: WebRepository
    
    init(webRepository: WebRepository = WebRepository(), of playlist: Playlist) {
        self.webRepository = webRepository
        configure(with: playlist)
    }
    
    private func configure(with playlist: Playlist) {
        webRepository.getPlaylist(playlistId: playlist.id) { [weak self] result in
            switch result {
            case .success(let playlist):
                self?.imageURL.value = playlist.imageURL
                self?.setTracks(id: playlist.id)
            case .failure(let error):
                dump(error.localizedDescription)
            }
        }
    }
    
    private func setTracks(id: String) {
        webRepository.getPlaylistTracks(playlistId: id) { [weak self] result in
            switch result {
            case .success(let tracks):
                let wrappedTracks = tracks.value
                let unwrappedTracks = wrappedTracks.map { $0.track }
                self?.items.value = unwrappedTracks
            case .failure(let error):
                dump(error.localizedDescription)
            }
        }
    }
    
    func dismissView() {
        delegate?.dismissDetailView()
    }
    
    func didSelectItem(at index: Int) {
        guard let audioTrack = items.value?[safeAt: index] else { fatalError() }
        delegate?.displayDetailItemView(with: audioTrack)
    }
}
