//
//  MusicViewModel.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 16.06.22.
//

import UIKit

protocol MusicViewModelProtocol {
    
    var sections: Observable<[AudioTrackSection]> { get }
    
    func loadSections()
}

class MusicViewModel: MusicViewModelProtocol {
    
    let sections: Observable<[AudioTrackSection]> = Observable([AudioTrackSection]())
    
    private let webRepository = WebRepository()
    
    func loadSections() {
        webRepository.getRecentlyPlayedTracks { result in
            switch result {
            case .success(let items):
                let wrappedAudioTracks = items.value
                let tracks = wrappedAudioTracks.map { $0.track }
                let section = AudioTrackSection(
                    id: 1,
                    type: "recentlyPlayed",
                    title: "Recently played tracks",
                    subtitle: "",
                    items: tracks)
                self.sections.value?.append(section)
            case .failure(let error):
                dump(error.localizedDescription)
            }
        }
    }
}
