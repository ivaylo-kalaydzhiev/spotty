//
//  ProfileViewModel.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 30.06.22.
//

import SFBaseKit

protocol ProfileViewModelProtocol: CoordinatableViewModel {
    
    var profileImageURL: Observable<String> { get }
    var tracks: Observable<[AudioTrack]> { get }
    var artists: Observable<[Artist]> { get }
    
    func didSelectAudioTrack(at index: Int)
    func didSelectArtist(at index: Int)
    func dismissView()
}

class ProfileViewModel: ProfileViewModelProtocol {
    
    let profileImageURL = Observable("")
    let tracks = Observable([AudioTrack]())
    let artists = Observable([Artist]())
    
    weak var delegate: CoreViewModelCoordinatorDelegate?
    
    private let webRepository: WebRepository
    
    init(webRepository: WebRepository = WebRepository()) {
        self.webRepository = webRepository
    }
    
    func didSelectAudioTrack(at index: Int) {
        guard let audioTrack = tracks.value?[safeAt: index] else { fatalError() }
        delegate?.displayDetailItemView(with: audioTrack)
    }
    
    func didSelectArtist(at index: Int) {
        guard let artist = artists.value?[safeAt: index] else { fatalError() }
        delegate?.displayDetailListView(with: artist)
    }
    
    func dismissView() {
        delegate?.dismissView()
    }
    
    private func loadProfileImage() {
        webRepository.getCurrentUserProfile { [weak self] result in
            switch result {
            case .success(let user):
                self?.profileImageURL.value = user.imageURL
            case .failure(let error):
                dump(error.localizedDescription)
            }
        }
    }
    
    private func loadCurrentUserTopTracks() {
        webRepository.getCurrentUserTopTracks { [weak self] result in
            switch result {
            case .success(let wrappedTracks):
                self?.tracks.value = wrappedTracks.value
            case .failure(let error):
                dump(error.localizedDescription)
            }
        }
    }
    
    private func loadCurrentUserTopArtists() {
        webRepository.getCurrentUserTopArtists { [weak self] result in
            switch result {
            case .success(let wrappedArtists):
                self?.artists.value = wrappedArtists.value
            case .failure(let error):
                dump(error.localizedDescription)
            }
        }
    }
}

extension ProfileViewModel {
    
    func start() {
        loadProfileImage()
        loadCurrentUserTopTracks()
        loadCurrentUserTopArtists()
    }
}
