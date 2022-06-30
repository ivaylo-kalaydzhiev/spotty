//
//  ProfileViewModel.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 30.06.22.
//

import Foundation

protocol ProfileViewModelProtocol {
    
    var tracks: Observable<[AudioTrack]> { get }
    var artists: Observable<[Artist]> { get }
    
    func didSelectAudioTrack(at index: Int)
    func didSelectArtist(at index: Int)
    
    func dismissView()
}
