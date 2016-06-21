//
//  SpotifyArtist.swift
//  SpotifyArtistTopTracks
//
//  Created by Justine Kay on 6/14/16.
//  Copyright © 2016 Justine Kay. All rights reserved.
//

import Foundation

struct SpotifyArtist: Mappable {
    let spotifyID: String?
    let name: String?
    let topTracks: Array<Track>?
    let profileImage: String?
    
    init(spotifyID: String? = nil, name: String? = nil, topTracks: [Track]? = nil, profileImage: String? = nil)
    {
        self.spotifyID = spotifyID
        self.name = name
        self.topTracks = topTracks
        self.profileImage = profileImage
    }
    
    func map(json: NSDictionary) -> [Mappable]
    {
        var spotifyArtists = [Mappable]()
        
        if let results = json["artists"] as? NSDictionary {
            if let artistResults = results["items"] as? NSArray {
                spotifyArtists = createArtists(artistResults as! [NSDictionary])
            }
        }
        return spotifyArtists
    }
    
    func createArtists(artistResults: [NSDictionary]) -> [Mappable]
    {
        var spotifyArtists = [Mappable]()
        for result in artistResults {
            let artistResult = result as? NSDictionary
            guard let artistName = artistResult?["name"] as? String! else {continue}
            guard let artistSpotifyID = artistResult?["id"] as? String else {continue}
            guard let artistImages = artistResult?["images"] as? [NSDictionary] else {continue}
            guard let artistProfileImage = artistImages.first else {continue}
            guard let artistProfileImageURLString = artistProfileImage["url"] as? String? else {continue}
            let artist = SpotifyArtist(spotifyID: artistSpotifyID, name: artistName, profileImage: artistProfileImageURLString)
            spotifyArtists.append(artist)
        }
        
        return spotifyArtists
    }
}

struct Track: Mappable
{
    let name: String?
    let albumCoverImage: String?
    let albumName: String?
    let trackPreviewURLString: String?
    
    init (name: String? = nil, albumCoverImage: String? = nil, albumName: String? = nil, trackPreviewURLString: String? = nil) {
        self.name = name
        self.albumCoverImage = albumCoverImage
        self.albumName = albumName
        self.trackPreviewURLString = trackPreviewURLString
    }
    
    func map(json: NSDictionary) -> [Mappable]
    {
        var tracks = [Mappable]()
        if let results = json["tracks"] as? NSArray {
            tracks = createTracks(results as! [NSDictionary])
        }
        return tracks
    }
    
    func createTracks(results: [NSDictionary]) -> [Mappable]
    {
        var tracks = [Mappable]()
        for result in results {
            let trackResult = result as? NSDictionary
            guard let trackName = trackResult?["name"] as? String else {continue}
            guard let trackAlbum = trackResult?["album"] as? NSDictionary else {continue}
            guard let trackAlbumCoverImages = trackAlbum["images"] as? [NSDictionary] else {continue}
            guard let trackAlbumCoverImage = trackAlbumCoverImages.first else {continue}
            guard let trackAlbumCoverImageURLString = trackAlbumCoverImage["url"] as? String else {continue}
            guard let trackAlbumName = trackAlbum["name"] as? String else {continue}
            guard let trackPreviewURLString = trackResult?["preview_url"] as? String else {continue}
            
            let track = Track(name: trackName, albumCoverImage: trackAlbumCoverImageURLString, albumName: trackAlbumName, trackPreviewURLString: trackPreviewURLString)
            tracks.append(track)
            print("\(tracks)")
        }
        return tracks
    }

}

protocol Mappable
{
    func map(json: NSDictionary) -> [Mappable]
}