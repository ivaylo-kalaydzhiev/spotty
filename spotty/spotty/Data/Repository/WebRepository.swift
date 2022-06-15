//
//  WebRepository.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 13.06.22.
//

import Foundation

// TODO: One Repository, that implements multiple protocols. Maybe name them like Spotify names them in it Docs.
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
    
    func getRecentlyPlayedTracks(completion: @escaping (Result<ItemsResponse<AudioTrackWrapperRequest>, Error>) -> Void) {
        
        let fiveDaysAgo: TimeInterval = -432000
        let date = Date().addingTimeInterval(fiveDaysAgo)
        let dateAsNumber = Int(date.timeIntervalSince1970)
        let urlRequest = SpotifyEndpoint.getRecentlyPlayedTracks(limit: 49, since: dateAsNumber).urlRequest
        Network.performAuthorizedRequest(with: urlRequest, completion: completion)
    }
}

//case getCurrentUserProfile
//case getCurrentUserTopTracks(limit: Int)
//case getCurrentUserTopArtists(limit: Int)
//case getCurrentUserPlaylists(limit: Int)
//case getRecentlyPlayedTracks(limit: Int, since: Int)
//case getUserSavedEpisodes(limit: Int)
//case getUserSavedShows(limit: Int)
//case searchAllItems(limit: Int, query: String)
//case getFeaturedPlaylists(limit: Int)

//case createPlaylist(userId: String, name: String)

//case getArtist(artistId: String)
//case getArtistTopTracks(artistId: String)
//case getShow(showId: String)
//case getShowEpisodes(showId: String, limit: Int)
//case getPlaylist(playlistId: String)
//case getPlaylistTracks(playlistId: String, limit: Int)

//case deleteSongsFromPlaylist(playlistId: String, tracks: [AudioTrackRequest], playlistSnapshotId: String)

//case getTrack(trackId: String)
//case getEpisode(episodeId: String)
