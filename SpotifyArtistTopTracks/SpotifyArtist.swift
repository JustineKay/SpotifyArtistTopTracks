//
//  SpotifyArtist.swift
//  SpotifyArtistTopTracks
//
//  Created by Justine Kay on 6/14/16.
//  Copyright © 2016 Justine Kay. All rights reserved.
//

import Foundation

struct SpotifyArtist: Mappable
{
    let spotifyID: String
    let name: String
    let topTracks: Array<Track>?
    
    init(spotifyID: String, name: String, topTracks: [Track]? = nil)
    {
        self.spotifyID = spotifyID
        self.name = name
        self.topTracks = topTracks
    }
    
    static func map(json: NSDictionary) -> [Mappable] {
        let jsonID = json["id"] as? String
        let jsonName = json["name"] as? String
        return [SpotifyArtist(spotifyID: jsonID!, name: jsonName!)]
    }
}

struct Track: Mappable
{
    let name: String?
    init (name: String?) {
        self.name = name
    }
    
    static func map(json: NSDictionary) -> [Mappable] {
        let jsonName = json["name"] as? String
        return [Track(name: jsonName)]

    }
}

protocol Mappable
{
    static func map(json: NSDictionary) -> [Mappable]
    
}