//
//  SpotifyArtist.swift
//  SpotifyArtistTopTracks
//
//  Created by Justine Kay on 6/14/16.
//  Copyright © 2016 Justine Kay. All rights reserved.
//

import Foundation

class SpotifyArtist
{
    var spotifyID = String()
    var name = String()
    var topTracks = [Track]()
    
    class Track
    {
        var name = String()
    }
}