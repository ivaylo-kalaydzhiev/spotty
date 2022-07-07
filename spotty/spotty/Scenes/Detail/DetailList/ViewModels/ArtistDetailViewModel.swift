//
//  ArtistDetailViewModel.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 24.06.22.
//

import Foundation

class ArtistDetailViewModel: DetailListViewModelProtocol {
    
    var imageURL = Observable("")
    var title = Observable("Top Tracks")
    var items: Observable<[BusinessModel]> = Observable([AudioTrack]())
    
    weak var delegate: CoreViewModelCoordinatorDelegate?
    
    private let webRepository: WebRepository
    
    init(webRepository: WebRepository = WebRepository(), of artist: Artist) {
        self.webRepository = webRepository
        configure(with: artist)
    }

    func dismissView() {
        delegate?.dismissView()
    }
    
    func didSelectItem(at index: Int) {
        guard let audioTrack = items.value?[safeAt: index] else { fatalError() }
        delegate?.displayDetailItemView(with: audioTrack)
    }

    private func configure(with artist: Artist) {
        webRepository.getArtist(artistId: artist.id) { [weak self] result in
            switch result {
            case .success(let artist):
                self?.imageURL.value = artist.imageURL
                self?.setTracks(id: artist.id)
            case .failure(let error):
                dump(error.localizedDescription)
            }
        }
    }
    
    private func setTracks(id: String) {
        webRepository.getArtistTopTracks(artistId: id) { [weak self] result in
            switch result {
            case .success(let tracks):
                let unwrappedAudioTracks = tracks.tracks
                self?.items.value = unwrappedAudioTracks
            case .failure(let error):
                dump(error.localizedDescription)
            }
        }
    }
}
