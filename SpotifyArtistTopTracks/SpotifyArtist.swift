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
    
    init(spotifyID: String? = nil, name: String? = nil, topTracks: [Track]? = nil)
    {
        self.spotifyID = spotifyID
        self.name = name
        self.topTracks = topTracks
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
            let artist = SpotifyArtist(spotifyID: artistSpotifyID, name: artistName)
            spotifyArtists.append(artist)
        }
        
        return spotifyArtists
    }

}

struct Track: Mappable
{
    let name: String?
    init (name: String?) {
        self.name = name
    }
    
    func map(json: NSDictionary) -> [Mappable]
    {
        
        
        let jsonName = json["name"] as? String
        return [Track(name: jsonName)]
    }
    
    func createTracks(results: [NSDictionary]) -> [Track]
    {
        var tracks = [Track]()
        for result in results {
            let trackResult = result as? NSDictionary
            guard let trackName = trackResult?["name"] as? String else {continue}
            let track = Track(name: trackName)
            tracks.append(track)
        }
        
        return tracks
    }

}

protocol Mappable
{
    func map(json: NSDictionary) -> [Mappable]
    
}