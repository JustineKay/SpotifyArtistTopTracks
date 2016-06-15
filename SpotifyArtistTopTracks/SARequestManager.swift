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
    case Success(topTracks: [SpotifyArtist.Track])
    case Failure(error: ErrorType)
}

enum ArtistsResponse {
    case Success(artists: [SpotifyArtist])
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
        let path = "https://api.spotify.com/v1/artists/\(artistID)/top-tracks"
        guard let url = NSURL(string: path) else {
            return
        }
        
        let task = session.dataTaskWithURL(url) { (data: NSData?, response: NSURLResponse?, error: NSError?) in
            var result: TopTracksResponse
            
            // We have to handle a few cases here:
            
            if let error = error {
                // 1. Something went wrong with the request. We pass along the error.
                result = TopTracksResponse.Failure(error: error)
            } else if let data = data {
                // We got back some data. We'll attempt to parse it as JSON.
                do {
                    let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary
                    
                    // 2. We were able to parse the data. We need to map the JSON into Track objects.
                    
                    //map to JSON
                    print(jsonResult)
                    
                    //create Tracks
//                    let returnedTracks = self.createTracks(artist, results: jsonResult!)
//                    
//                    result = TopTracksResponse.Success(topTracks: returnedTracks)
                    
                } catch let error as NSError {
                    // 3. Got back something that wasn't valid JSON.
                    result = TopTracksResponse.Failure(error: error)
                }
            } else {
                // 4. Successful response, but no data returned... we'll treat this as an empty list.
                result = TopTracksResponse.Success(topTracks: [SpotifyArtist.Track()])
            }
            
            // Call our completion handler on the main queue
//            dispatch_async(dispatch_get_main_queue()) {
//                completion(result)
//            }
        }
        task.resume()
    }
    
    func getArtistsWithCompletion(artistName: String, completion: ((ArtistsResponse) -> Void)) {
        let path = "https://api.spotify.com/v1/search?query=\(artistName)&offset=0&limit=20&type=artist&market=US"
        guard let url = NSURL(string: path) else {
            return
        }
        
        let task = session.dataTaskWithURL(url) { (data: NSData?, response: NSURLResponse?, error: NSError?) in
            var result: ArtistsResponse
            
            // We have to handle a few cases here:
            
            if let error = error {
                // 1. Something went wrong with the request. We pass along the error.
                result = ArtistsResponse.Failure(error: error)
            } else if let data = data {
                // We got back some data. We'll attempt to parse it as JSON.
                do {
                    let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary
                    
                    // 2. We were able to parse the data. We need to map the JSON into SpotifyArtist objects.
                    
                    //map to JSON
                    print(jsonResult)
                    
                    //create artists
//                    let returnedArtists = self.createArtists(jsonResult!)
//                    
//                    result = ArtistsResponse.Success(artists: returnedArtists)
                    
                } catch let error as NSError {
                    // 3. Got back something that wasn't valid JSON.
                    result = ArtistsResponse.Failure(error: error)
                }
            } else {
                // 4. Successful response, but no data returned... we'll treat this as an empty list.
                result = ArtistsResponse.Success(artists: [SpotifyArtist]())
            }
            
            // Call our completion handler on the main queue
//            dispatch_async(dispatch_get_main_queue()) {
//                completion(result)
//            }
        }
        task.resume()
    }
    
    func createArtists(results: NSDictionary) -> [SpotifyArtist]
    {
        var spotifyArtists = [SpotifyArtist]()
        for _ in results {
            let artist = SpotifyArtist()
            artist.name = results["name"] as! String
            artist.spotifyID = results["id"] as! String
            spotifyArtists.append(artist)
        }
        return spotifyArtists
    }
    
    func createTracks(selectedArtist: SpotifyArtist, results: NSDictionary) -> [SpotifyArtist.Track]
    {
        let artistTopTracks = [SpotifyArtist.Track()]
        for _ in results {
            let track = SpotifyArtist.Track()
            track.name = results["name"] as! String
        }
        
        selectedArtist.topTracks = artistTopTracks
        
        return artistTopTracks
    }
    
}