//
//  MusicViewModel.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 16.06.22.
//

import SFBaseKit

protocol MusicViewModelProtocol: CoordinatableViewModel {
    
    var featuredPlaylists: Observable<[Playlist]> { get }
    var recentlyPlayedTracks: Observable<[AudioTrack]> { get }
    var recentlyPlayedArtists: Observable<[Artist]> { get }
    var screenTitle: String { get }
    
    func didSelectPlaylist(at index: Int)
    func didSelectAudioTrack(at index: Int)
    func didSelectArtist(at index: Int)
    func didTapProfileButton()
}

class MusicViewModel: MusicViewModelProtocol {

    let featuredPlaylists = Observable([Playlist]())
    let recentlyPlayedTracks = Observable([AudioTrack]())
    let recentlyPlayedArtists = Observable([Artist]())
    let screenTitle = Constant.SceneTitle.music
    
    weak var delegate: CoreViewModelCoordinatorDelegate?

    private let webRepository: WebRepository
    
    init(webRepository: WebRepository = WebRepository()) {
        self.webRepository = webRepository
    } //TODO: Remove default value
    
    func didSelectPlaylist(at index: Int) {
        guard let playlist = featuredPlaylists.value?[safeAt: index] else { fatalError() }
        delegate?.displayDetailListView(with: playlist)
    }
    
    func didSelectAudioTrack(at index: Int) {
        guard let audioTrack = recentlyPlayedTracks.value?[safeAt: index] else { fatalError() }
        delegate?.displayDetailItemView(with: audioTrack)
    }
    
    func didSelectArtist(at index: Int) {
        guard let artist = recentlyPlayedArtists.value?[safeAt: index] else { fatalError() }
        delegate?.displayDetailListView(with: artist)
    }
    
    func didTapProfileButton() {
        delegate?.displayProfileScene()
    }
    
    private func loadRecentlyPlayedTracks() {
        webRepository.getRecentlyPlayedTracks { [weak self] result in
            switch result {
            case .success(let items):
                let wrappedAudioTracks = items.value
                let tracksWithDuplicates = wrappedAudioTracks.map { $0.track }
                let tracks = tracksWithDuplicates.uniqued()
                self?.recentlyPlayedTracks.value? = tracks
                let artistWithoutImages = tracks.map { $0.artists[0] }.uniqued()
                self?.getArtistModelsWithImages(artists: artistWithoutImages)
            case .failure(let error):
                dump(error.localizedDescription)
            }
        }
    }
    
    private func getArtistModelsWithImages(artists: [Artist]) {
        for artist in artists {
            webRepository.getArtist(artistId: artist.id) { [weak self] result in
                switch result {
                case .success(let artist):
                    self?.recentlyPlayedArtists.value?.append(artist)
                case .failure(let error):
                    dump(error.localizedDescription)
                }
            }
        }
    }
    
    private func loadFeaturedPlaylists() {
        webRepository.getFeaturedPlaylists { [weak self] result in
            switch result {
            case .success(let playlistResponse):
                self?.featuredPlaylists.value? = playlistResponse.playlists.value
            case .failure(let error):
                dump(error.localizedDescription)
            }
        }
    }
}

extension MusicViewModel {
    
    func start() {
        loadRecentlyPlayedTracks()
        loadFeaturedPlaylists()
    }
}
