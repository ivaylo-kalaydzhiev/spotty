//
//  WebRepository.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 13.06.22.
//

import Foundation

// TODO: One Repository, that implements multiple protocols. Maybe name them like Spotify names them in it Docs.
// TODO: Typealias Result
// TODO: Use SDK to do Playlist CRUD
struct WebRepository {
    
    func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        let urlRequest = SpotifyEndpoint.getCurrentUserProfile.urlRequest
        Network.performAuthorizedRequest(with: urlRequest, completion: completion)
    }
    
    func getCurrentUserTopTracks(completion: @escaping (Result<ItemsResponse<AudioTrack>, Error>) -> Void) {
        let urlRequest = SpotifyEndpoint.getCurrentUserTopTracks(limit: 49).urlRequest
        Network.performAuthorizedRequest(with: urlRequest, completion: completion)
    }
    
    func getCurrentUserTopArtists(completion: @escaping (Result<ItemsResponse<Artist>, Error>) -> Void) {
        let urlRequest = SpotifyEndpoint.getCurrentUserTopArtists(limit: 49).urlRequest
        Network.performAuthorizedRequest(with: urlRequest, completion: completion)
    }
    
    func getCurrentUserPlaylists(completion: @escaping (Result<ItemsResponse<Playlist>, Error>) -> Void) {
        let urlRequest = SpotifyEndpoint.getCurrentUserPlaylists(limit: 49).urlRequest
        Network.performAuthorizedRequest(with: urlRequest, completion: completion)
    }
    
    func getRecentlyPlayedTracks(completion: @escaping (Result<ItemsResponse<AudioTrackWrapper>, Error>) -> Void) {
        
        let fiveDaysAgo: TimeInterval = -432000
        let date = Date().addingTimeInterval(fiveDaysAgo)
        let dateAsNumber = Int(date.timeIntervalSince1970)
        let urlRequest = SpotifyEndpoint.getRecentlyPlayedTracks(limit: 49, since: dateAsNumber).urlRequest
        Network.performAuthorizedRequest(with: urlRequest, completion: completion)
    }
    
    func getUserSavedEpisodes(completion: @escaping (Result<ItemsResponse<EpisodeWrapper>, Error>) -> Void) {
        let urlRequest = SpotifyEndpoint.getUserSavedEpisodes(limit: 49).urlRequest
        Network.performAuthorizedRequest(with: urlRequest, completion: completion)
    }
    
    func getUserSavedShows(completion: @escaping (Result<ItemsResponse<ShowWrapper>, Error>) -> Void) {
        let urlRequest = SpotifyEndpoint.getUserSavedShows(limit: 49).urlRequest
        Network.performAuthorizedRequest(with: urlRequest, completion: completion)
    }
    
    func searchAllItems(for searchTerm: String, completion: @escaping (Result<ItemsResponse<ShowWrapper>, Error>) -> Void) {
        let urlRequest = SpotifyEndpoint.searchAllItems(limit: 10, query: searchTerm).urlRequest
        Network.performAuthorizedRequest(with: urlRequest, completion: completion)
    }
    
    func getFeaturedPlaylists(completion: @escaping (Result<FeaturedPlaylistsResponse, Error>) -> Void) {
        let urlRequest = SpotifyEndpoint.getFeaturedPlaylists(limit: 49).urlRequest
        Network.performAuthorizedRequest(with: urlRequest, completion: completion)
    }
    
    func getArtist(artistId: String = "0EmeFodog0BfCgMzAIvKQp", completion: @escaping (Result<Artist, Error>) -> Void) {
        let urlRequest = SpotifyEndpoint.getArtist(artistId: artistId).urlRequest
        Network.performAuthorizedRequest(with: urlRequest, completion: completion)
    }
    
    func getArtistTopTracks(artistId: String = "0EmeFodog0BfCgMzAIvKQp", completion: @escaping (Result<AudioTracksWrapper, Error>) -> Void) {
        let urlRequest = SpotifyEndpoint.getArtistTopTracks(artistId: artistId).urlRequest
        Network.performAuthorizedRequest(with: urlRequest, completion: completion)
    }
    
    func getShow(showId: String = "38bS44xjbVVZ3No3ByF1dJ", completion: @escaping (Result<Show, Error>) -> Void) {
        let urlRequest = SpotifyEndpoint.getShow(showId: showId).urlRequest
        Network.performAuthorizedRequest(with: urlRequest, completion: completion)
    }
    
    func getShowEpisodes(showId: String = "38bS44xjbVVZ3No3ByF1dJ", completion: @escaping (Result<ItemsResponse<Episode>, Error>) -> Void) {
        let urlRequest = SpotifyEndpoint.getShowEpisodes(showId: showId, limit: 49).urlRequest
        Network.performAuthorizedRequest(with: urlRequest, completion: completion)
    }
    
    func getPlaylist(playlistId: String = "3cEYpjA9oz9GiPac4AsH4n", completion: @escaping (Result<Playlist, Error>) -> Void) {
        let urlRequest = SpotifyEndpoint.getPlaylist(playlistId: playlistId).urlRequest
        Network.performAuthorizedRequest(with: urlRequest, completion: completion)
    }
    
    func getPlaylistTracks(playlistId: String = "3cEYpjA9oz9GiPac4AsH4n", completion: @escaping (Result<ItemsResponse<AudioTrackWrapper>, Error>) -> Void) {
        let urlRequest = SpotifyEndpoint.getPlaylistTracks(playlistId: playlistId, limit: 49).urlRequest
        Network.performAuthorizedRequest(with: urlRequest, completion: completion)
    }
    
    func getAudioTrack(audioTrackId: String = "11dFghVXANMlKmJXsNCbNl", completion: @escaping (Result<AudioTrack, Error>) -> Void) {
        let urlRequest = SpotifyEndpoint.getAudioTrack(trackId: audioTrackId).urlRequest
        Network.performAuthorizedRequest(with: urlRequest, completion: completion)
    }
    
    func getEpisode(episodeId: String = "512ojhOuo1ktJprKbVcKyQ", completion: @escaping (Result<Episode, Error>) -> Void) {
        let urlRequest = SpotifyEndpoint.getEpisode(episodeId: episodeId).urlRequest
        Network.performAuthorizedRequest(with: urlRequest, completion: completion)
    }
    
    func createPlaylist(userId: String = "ivailo.s.k",
                        name: String,
                        description: String,
                        completion: @escaping (Result<Playlist, Error>) -> Void) {
        
        let urlRequest = SpotifyEndpoint.createPlaylist(userId: userId,
                                                        name: name,
                                                        description: description).urlRequest
        Network.performAuthorizedRequest(with: urlRequest, completion: completion)
    }
}

//case searchAllItems(limit: Int, query: String)

//case createPlaylist(userId: String, name: String)

//case deleteSongsFromPlaylist(playlistId: String, tracks: [AudioTrackRequest], playlistSnapshotId: String)
