//
//  SARequestManager.swift
//  SpotifyArtistTopTracks
//
//  Created by Justine Kay on 6/14/16.
//  Copyright © 2016 Justine Kay. All rights reserved.
//

import Foundation

enum RequestManager: ErrorType
{
    case UnexpectedvarResponse
}

enum Response
{
    case Success(mappables: [Mappable])
    case Failure(error: ErrorType)
}

class SARequestManager
{
    static let sharedService = SARequestManager()
    
    private let session: NSURLSession = {
        let sessionConfig: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionConfig)
        return session
    }()
    
    func tracksURL(artist: SpotifyArtist) -> NSURL
    {
        var path = String()
        if let spotifyID = artist.spotifyID {
            path = "https://api.spotify.com/v1/artists/\(spotifyID)/top-tracks?country=US"            
        }
        let url = NSURL(string: path)!
        
        return url
    }
    
    func artistsURL(artistName: String) -> NSURL
    {
        let path = "https://api.spotify.com/v1/search?query=\(artistName)&offset=0&limit=20&type=artist&market=US"
        let url = NSURL(string: path)!
        
        return url
    }
    
    func getDataWithCompletion(url: NSURL, mappable: Mappable, completion: ((Response) -> Void))
    {
        let task = session.dataTaskWithURL(url) { (data: NSData?, response: NSURLResponse?, error: NSError?) in
            var result: Response
            
            if let error = error {
                result = Response.Failure(error: error)
            } else if let data = data {
                do {
                    let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary
                    
                    var returnedMappables = [Mappable]()
                    returnedMappables = mappable.map(jsonResult!)
                    result = Response.Success(mappables: returnedMappables)
                    
                } catch let error as NSError {
                    result = Response.Failure(error: error)
                }
            } else {
                result = Response.Success(mappables: [Mappable]())
            }
            dispatch_async(dispatch_get_main_queue()) {
                completion(result)
            }
        }
        task.resume()
    }
    
}