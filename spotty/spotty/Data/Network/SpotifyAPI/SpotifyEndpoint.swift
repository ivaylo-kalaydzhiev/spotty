//
//  SpotifyEndpoint.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 10.06.22.
//

import Foundation

enum SpotifyEndpoint {
    
    // MARK: - Cases
    
    case getCurrentUserProfile
    case getCurrentUserTopTracks(limit: Int)
    case getCurrentUserTopArtists(limit: Int)
    case getCurrentUserPlaylists(limit: Int)
    case getRecentlyPlayedTracks(limit: Int, since: Int)
    case getUserSavedEpisodes(limit: Int)
    case getUserSavedShows(limit: Int)
    case searchAllItems(limit: Int, query: String)
    case getFeaturedPlaylists(limit: Int)
    case createPlaylist(userId: String, name: String)
    case getArtist(artistId: String)
    case getArtistTopTracks(artistId: String)
    case getShow(showId: String)
    case getShowEpisodes(showId: String, limit: Int)
    case getPlaylist(playlistId: String)
    case getPlaylistTracks(playlistId: String, limit: Int)
    case deleteSongsFromPlaylist(playlistId: String, tracks: [AudioTrackRequest], playlistSnapshotId: String)
    case getTrack(trackId: String)
    case getEpisode(episodeId: String)
    
    // MARK: - Private properties
    
    private var scheme: String {
        switch self {
        default:
            return "https"
        }
    }
    
    private var host: String {
        switch self {
        default:
            return "api.spotify.com"
        }
    }
    
    private var httpMethod: String {
        switch self {
        case .createPlaylist:
            return HTTPMethod.POST.rawValue
        case .deleteSongsFromPlaylist:
            return HTTPMethod.DELETE.rawValue
        default:
            return HTTPMethod.GET.rawValue
        }
    }
    
    private var path: String {
        switch self {
        case .getCurrentUserProfile:
            return "/v1/me"
        case .getCurrentUserTopTracks:
            return "/v1/me/top/tracks"
        case .getCurrentUserTopArtists:
            return "/v1/me/top/artists"
        case .getCurrentUserPlaylists:
            return "/v1/me/playlists"
        case .getRecentlyPlayedTracks:
            return "/v1/me/player/recently-played"
        case .getUserSavedEpisodes:
            return "/v1/me/episodes"
        case .getUserSavedShows:
            return "/v1/me/shows"
        case .searchAllItems:
            return "/v1/search"
        case .getFeaturedPlaylists:
            return "/v1/browse/featured-playlists"
        case .createPlaylist(let userId, _):
            return "/v1/users/\(userId)/playlists"
        case .getArtist(let artistId):
            return "/v1/artists/\(artistId)"
        case .getArtistTopTracks(let artistId):
            return "/v1/artists/\(artistId)/top-tracks"
        case .getShow(let showId):
            return "/v1/shows/\(showId)"
        case .getShowEpisodes(let showId, _):
            return "/v1/shows/\(showId)/episodes"
        case .getPlaylist(let playlistId):
            return "/v1/playlists/\(playlistId)"
        case .getPlaylistTracks(let playlistId, _),
                .deleteSongsFromPlaylist(let playlistId, _, _):
            return "/v1/playlists/\(playlistId)/tracks"
        case .getTrack(let trackId):
            return "/v1/tracks/\(trackId)"
        case .getEpisode(let episodeId):
            return "/v1/episodes/\(episodeId)"
        }
    }
    
    private var queryItems: [URLQueryItem] {
        switch self {
        case .getCurrentUserProfile,
                .getArtist,
                .getArtistTopTracks,
                .getShow,
                .getPlaylist,
                .getTrack,
                .getEpisode:
            return []
        case .getCurrentUserTopTracks(let limit),
                .getCurrentUserTopArtists(let limit):
            return [
                URLQueryItem(name: "time_range", value: "long_term"),
                URLQueryItem(name: "limit", value: String(limit))
            ]
        case .getCurrentUserPlaylists(let limit),
                .getUserSavedEpisodes(let limit),
                .getUserSavedShows(let limit),
                .getFeaturedPlaylists(let limit),
                .getShowEpisodes(_, let limit),
                .getPlaylistTracks(_, let limit):
            return [
                URLQueryItem(name: "limit", value: String(limit))
            ]
        case .getRecentlyPlayedTracks(let limit, let after):
            return [
                URLQueryItem(name: "limit", value: String(limit)),
                URLQueryItem(name: "after", value: String(after))
            ]
        case .searchAllItems(let limit, let query):
            return [
                URLQueryItem(name: "limit", value: String(limit)),
                URLQueryItem(name: "q", value: query),
                URLQueryItem(name: "type", value: "artist,playlist,track,show,episode")
            ]
        case .createPlaylist(let userId, let name):
            return [
                URLQueryItem(name: "name", value: name),
                URLQueryItem(name: "description", value: "Created by: \(userId)")
            ]
        case .deleteSongsFromPlaylist(_, let tracks, let snapshotId):
            guard let jsonData = try? JSONEncoder().encode(tracks) else { fatalError("Could not edit playlist.") }
            let jsonString = String(data: jsonData, encoding: .utf16)
            return [
                URLQueryItem(name: "tracks", value: jsonString),
                URLQueryItem(name: "snapshot_id", value: snapshotId)
            ]
        }
    }
    
    // MARK: - Exposed properties
    
    var urlRequest: URLRequest {
        var components = URLComponents()
        components.scheme = self.scheme
        components.host = self.host
        components.path = self.path
        components.queryItems = self.queryItems
        
        guard let url = components.url else { fatalError("URL Creation failed") }
        var request = URLRequest(url: url)
        request.httpMethod = self.httpMethod
        return request
    }
}
