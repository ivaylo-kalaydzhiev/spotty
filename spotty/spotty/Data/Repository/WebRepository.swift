//
//  WebRepository.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 13.06.22.
//

import Foundation
typealias Completion<T> = (Result<T, Error>) -> Void

// TODO: One Repository, that implements multiple protocols. Maybe name them like Spotify names them in it Docs.
// TODO: Create SDK to do Playlist CRUD

struct WebRepository {
    
    func getCurrentUserProfile(completion: @escaping Completion<UserProfile>) {
        let urlRequest = SpotifyEndpoint.getCurrentUserProfile.urlRequest
        Network.performAuthorizedRequest(with: urlRequest, completion: completion)
    }
    
    func getCurrentUserTopTracks(completion: @escaping Completion<ItemsResponse<AudioTrack>>) {
        let urlRequest = SpotifyEndpoint.getCurrentUserTopTracks(limit: 49).urlRequest
        Network.performAuthorizedRequest(with: urlRequest, completion: completion)
    }
    
    func getCurrentUserTopArtists(completion: @escaping Completion<ItemsResponse<Artist>>) {
        let urlRequest = SpotifyEndpoint.getCurrentUserTopArtists(limit: 49).urlRequest
        Network.performAuthorizedRequest(with: urlRequest, completion: completion)
    }
    
    func getCurrentUserPlaylists(completion: @escaping Completion<ItemsResponse<Playlist>>) {
        let urlRequest = SpotifyEndpoint.getCurrentUserPlaylists(limit: 49).urlRequest
        Network.performAuthorizedRequest(with: urlRequest, completion: completion)
    }
    
    func getRecentlyPlayedTracks(completion: @escaping Completion<ItemsResponse<AudioTrackWrapper>>) {
        
        let fiveDaysAgo: TimeInterval = -432000
        let date = Date().addingTimeInterval(fiveDaysAgo)
        let dateAsNumber = Int(date.timeIntervalSince1970)
        let urlRequest = SpotifyEndpoint.getRecentlyPlayedTracks(limit: 49, since: dateAsNumber).urlRequest
        Network.performAuthorizedRequest(with: urlRequest, completion: completion)
    }
    
    func getUserSavedEpisodes(completion: @escaping Completion<ItemsResponse<EpisodeWrapper>>) {
        let urlRequest = SpotifyEndpoint.getUserSavedEpisodes(limit: 49).urlRequest
        Network.performAuthorizedRequest(with: urlRequest, completion: completion)
    }
    
    func getUserSavedShows(completion: @escaping Completion<ItemsResponse<ShowWrapper>>) {
        let urlRequest = SpotifyEndpoint.getUserSavedShows(limit: 49).urlRequest
        Network.performAuthorizedRequest(with: urlRequest, completion: completion)
    }
    
    func searchAllItems(for searchTerm: String,
                        completion: @escaping Completion<ItemsResponse<ShowWrapper>>) {
        let urlRequest = SpotifyEndpoint.searchAllItems(limit: 10, query: searchTerm).urlRequest
        Network.performAuthorizedRequest(with: urlRequest, completion: completion)
    }
    
    func getFeaturedPlaylists(completion: @escaping Completion<FeaturedPlaylistsResponse>) {
        let urlRequest = SpotifyEndpoint.getFeaturedPlaylists(limit: 49).urlRequest
        Network.performAuthorizedRequest(with: urlRequest, completion: completion)
    }
    
    func getArtist(artistId: String = "0EmeFodog0BfCgMzAIvKQp",
                   completion: @escaping Completion<Artist>) {
        let urlRequest = SpotifyEndpoint.getArtist(artistId: artistId).urlRequest
        Network.performAuthorizedRequest(with: urlRequest, completion: completion)
    }
    
    func getArtistTopTracks(artistId: String = "0EmeFodog0BfCgMzAIvKQp",
                            completion: @escaping Completion<AudioTracksWrapper>) {
        let urlRequest = SpotifyEndpoint.getArtistTopTracks(artistId: artistId).urlRequest
        Network.performAuthorizedRequest(with: urlRequest, completion: completion)
    }
    
    func getShow(showId: String = "38bS44xjbVVZ3No3ByF1dJ",
                 completion: @escaping Completion<Show>) {
        let urlRequest = SpotifyEndpoint.getShow(showId: showId).urlRequest
        Network.performAuthorizedRequest(with: urlRequest, completion: completion)
    }
    
    func getShowEpisodes(showId: String = "38bS44xjbVVZ3No3ByF1dJ",
                         completion: @escaping Completion<ItemsResponse<Episode>>) {
        let urlRequest = SpotifyEndpoint.getShowEpisodes(showId: showId, limit: 49).urlRequest
        Network.performAuthorizedRequest(with: urlRequest, completion: completion)
    }
    
    func getPlaylist(playlistId: String = "3cEYpjA9oz9GiPac4AsH4n",
                     completion: @escaping Completion<Playlist>) {
        let urlRequest = SpotifyEndpoint.getPlaylist(playlistId: playlistId).urlRequest
        Network.performAuthorizedRequest(with: urlRequest, completion: completion)
    }
    
    func getPlaylistTracks(playlistId: String = "3cEYpjA9oz9GiPac4AsH4n",
                           completion: @escaping Completion<ItemsResponse<AudioTrackWrapper>>) {
        let urlRequest = SpotifyEndpoint.getPlaylistTracks(playlistId: playlistId, limit: 49).urlRequest
        Network.performAuthorizedRequest(with: urlRequest, completion: completion)
    }
    
    func getAudioTrack(audioTrackId: String = "11dFghVXANMlKmJXsNCbNl",
                       completion: @escaping Completion<AudioTrack>) {
        let urlRequest = SpotifyEndpoint.getAudioTrack(trackId: audioTrackId).urlRequest
        Network.performAuthorizedRequest(with: urlRequest, completion: completion)
    }
    
    func getEpisode(episodeId: String = "512ojhOuo1ktJprKbVcKyQ",
                    completion: @escaping Completion<Episode>) {
        let urlRequest = SpotifyEndpoint.getEpisode(episodeId: episodeId).urlRequest
        Network.performAuthorizedRequest(with: urlRequest, completion: completion)
    }
    
    func createPlaylist(userId: String = "ivailo.s.k",
                        name: String,
                        description: String,
                        completion: @escaping Completion<Playlist>) {
        
        let urlRequest = SpotifyEndpoint.createPlaylist(userId: userId,
                                                        name: name,
                                                        description: description).urlRequest
        Network.performAuthorizedRequest(with: urlRequest, completion: completion)
    }
    
    func deleteSongsFromPlaylist(playlistId: String = "2Ugi1MOIyBezH0e4sARgD8",
                                 trackURIs: [String] = ["spotify:track:5iddrTFG7zJ4g9UkgpPxJv"],
                                 playlistSnapshotId: String = "NCxkYWQwMWY4YzYxMzcwZDNhYzI2ZTMzMjg2M2I0NjY5MzRmODBlODQ2",
                                 completion: @escaping Completion<PlaylistChangedResponse>) {
        
        let urlRequest = SpotifyEndpoint.deleteSongsFromPlaylist(playlistId: playlistId,
                                                                 trackURIs: trackURIs,
                                                                 playlistSnapshotId: playlistSnapshotId).urlRequest
        
        Network.performAuthorizedRequest(with: urlRequest, completion: completion)
    }
    
    func addTracksToPlaylist(playlistId: String = "2Ugi1MOIyBezH0e4sARgD8",
                             trackURIs: [String] = ["spotify:track:5iddrTFG7zJ4g9UkgpPxJv"],
                             position: Int? = nil,
                             completion: @escaping Completion<PlaylistChangedResponse>) {
        
        let urlRequest = SpotifyEndpoint.addTracksToPlaylist(playlistId: playlistId,
                                                             trackURIs: trackURIs,
                                                             position: position).urlRequest
        
        Network.performAuthorizedRequest(with: urlRequest, completion: completion)
    }
    
}

//case searchAllItems(limit: Int, query: String)

// Repos
// PlaylistRepo
//      - Get Current User Playlists
//      - Get Featured Playlists
//      - Get Playlist
//      - Get Playlist Tracks
//      - Create Playlist
//      - Add Items to Playlist
//      - Reorder Items in Playlist - NOT IMPLEMENTED
//      - Remove Items from Playlist
// AudioTracksRepo
//      - Get Recently Played Tracks
// ArtistRepo
// ShowRepository
// EpisodeRepository
// ProfileRepository
//      - Get Current User Profile
