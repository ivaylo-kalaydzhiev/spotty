//
//  SearchViewModel.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 7.07.22.
//

import SFBaseKit

protocol SearchViewModelProtocol: CoordinatableViewModel {
    
    var tracks: Observable<[AudioTrack]> { get }
    var artists: Observable<[Artist]> { get }
    var playlists: Observable<[Playlist]> { get }
    var episodes: Observable<[Episode]> { get }
    var shows: Observable<[Show]> { get }
    
    func search(for term: String)
    
    func didSelectAudioTrack(at index: Int)
    func didSelectArtist(at index: Int)
    func didSelectPlaylist(at index: Int)
    func didSelectEpisode(at index: Int)
    func didSelectShow(at index: Int)
    func dismissView()
}

class SearchViewModel: SearchViewModelProtocol {
    
    var tracks = Observable([AudioTrack]())
    var artists = Observable([Artist]())
    var playlists = Observable([Playlist]())
    var episodes = Observable([Episode]())
    var shows = Observable([Show]())
    
    weak var delegate: CoreViewModelCoordinatorDelegate?
    
    private let webRepository: WebRepository
    
    init(webRepository: WebRepository = WebRepository()) {
        self.webRepository = webRepository
    }
    
    func search(for term: String) {
        webRepository.searchAllItems(for: term) { result in
            switch result {
            case .success(let items): // TODO: Somehow parse the response
                print("cool")
//                for item in items {
//                    if let item as? AudioTrack {
//                        tracks.value?.append(item)
//                    } else if let item as? Artist {
//                        artists.value?.append(item)
//                    } else if let item as? Episode {
//                        episodes.value?.append(item)
//                    } else if let item as? Show {
//                        shows.value?.append(item)
//                    } else {
//                        fatalError()
//                    }
//                }
            case .failure(let error):
                dump(error.localizedDescription)
            }
        }
    }
    
    func didSelectAudioTrack(at index: Int) {
        guard let audioTrack = tracks.value?[safeAt: index] else { fatalError() }
        delegate?.displayDetailItemView(with: audioTrack)
    }
    
    func didSelectArtist(at index: Int) {
        guard let artist = artists.value?[safeAt: index] else { fatalError() }
        delegate?.displayDetailListView(with: artist)
    }
    
    func didSelectPlaylist(at index: Int) {
        guard let playlist = playlists.value?[safeAt: index] else { fatalError() }
        delegate?.displayDetailListView(with: playlist)
    }
    
    func didSelectEpisode(at index: Int) {
        guard let episode = episodes.value?[safeAt: index] else { fatalError() }
        delegate?.displayDetailItemView(with: episode)
    }
    
    func didSelectShow(at index: Int) {
        guard let show = shows.value?[safeAt: index] else { fatalError() }
        delegate?.displayDetailListView(with: show)
    }
    
    func dismissView() {
        delegate?.dismissView()
    }
}

extension SearchViewModel {
    
    func start() {
        print("ViewModel Start is not implemented")
    }
}

