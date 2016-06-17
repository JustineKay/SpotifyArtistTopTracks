//
//  SARequestManager.swift
//  SpotifyArtistTopTracks
//
//  Created by Justine Kay on 6/14/16.
//  Copyright © 2016 Justine Kay. All rights reserved.
//

import Foundation

enum RequestManager: ErrorType {
    case UnexpectedvarResponse
}

enum TopTracksResponse {
    case Success(topTracks: [Track])
    case Failure(error: ErrorType)
}

enum ArtistsResponse {
    case Success(artists: [Mappable])
    case Failure(error: ErrorType)
}

class SARequestManager {
    
    static let sharedService = SARequestManager()
    
    private let session: NSURLSession = {
        let sessionConfig: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        //Headers?
        
        let session = NSURLSession(configuration: sessionConfig)
        return session
    }()
    
    func getArtistTopTracksWithCompletion(artist: SpotifyArtist, completion: ((TopTracksResponse) -> Void)) {
        let artistID = artist.spotifyID
        let path = "https://api.spotify.com/v1/artists/\(artistID)/top-tracks?country=US"
        guard let url = NSURL(string: path) else {
            return
        }
        
        let task = session.dataTaskWithURL(url) { (data: NSData?, response: NSURLResponse?, error: NSError?) in
            var result: TopTracksResponse
            
            // We have to handle a few cases here:
            
            if let error = error {
                result = TopTracksResponse.Failure(error: error)
            } else if let data = data {
                do {
                    let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary
                    
                    var returnedTracks = [Track]()
                    
                    if let results = jsonResult?["tracks"] as? NSArray {
                        //returnedTracks = self.createTracks(artist, results: results as! [NSDictionary])
                    }
                    
                    result = TopTracksResponse.Success(topTracks: returnedTracks)
                    
                } catch let error as NSError {
                    result = TopTracksResponse.Failure(error: error)
                }
            } else {
                result = TopTracksResponse.Success(topTracks: [Track]())
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                completion(result)
            }
        }
        task.resume()
    }
    
    func getArtist(artistName: String) -> SpotifyArtist {
        let artist = SpotifyArtist(name: artistName)
        return artist
    }
    
    func artistsURL(artistName: String) -> NSURL
    {
        let path = "https://api.spotify.com/v1/search?query=\(artistName)&offset=0&limit=20&type=artist&market=US"
        let url = NSURL(string: path)!
        
        return url
    }
    
    func getDataWithCompletion(url: NSURL, mappable: Mappable, completion: ((ArtistsResponse) -> Void))
    {
        let task = session.dataTaskWithURL(url) { (data: NSData?, response: NSURLResponse?, error: NSError?) in
        var result: ArtistsResponse
            
        if let error = error {
            result = ArtistsResponse.Failure(error: error)
        } else if let data = data {
            do {
                let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary
                
                var returnedArtists = [Mappable]()
                returnedArtists = mappable.map(jsonResult!)
                result = ArtistsResponse.Success(artists: returnedArtists)
                
            } catch let error as NSError {
                result = ArtistsResponse.Failure(error: error)
            }
        } else {
            result = ArtistsResponse.Success(artists: [Mappable]())
        }
            dispatch_async(dispatch_get_main_queue()) {
                completion(result)
            }
        }
        task.resume()
    }
    
    
    
}