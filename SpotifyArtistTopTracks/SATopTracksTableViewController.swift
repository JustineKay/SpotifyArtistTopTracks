//
//  SATopTracksTableViewController.swift
//  SpotifyArtistTopTracks
//
//  Created by Justine Kay on 6/14/16.
//  Copyright © 2016 Justine Kay. All rights reserved.
//

import UIKit

class SATopTracksTableViewController: UITableViewController {

    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var artistNameLabel: UILabel!
    
    var spotifyArtist = SpotifyArtist()
    var results = [SpotifyArtist.Track()]
    let trackCellReuseIdentifier = "trackCellReuseIdentifier"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        fetchArtistTopTracks()
        self.tableView.backgroundColor = UIColor.blackColor()
        artistNameLabel.text = spotifyArtist.name
    }
    
    //MARK: - Network request
    
    private func fetchArtistTopTracks()
    {
        SARequestManager.sharedService.getArtistTopTracksWithCompletion(self.spotifyArtist) { (response) in
            switch response {
            case .Failure(error: let error):
                print("Error fetching top tracks: \(error)")
            case .Success(topTracks: let returnedTracks):
                print("Success: \(returnedTracks)")
                self.results = returnedTracks
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return results.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(trackCellReuseIdentifier, forIndexPath: indexPath)
        
        let track = results[indexPath.row]
        cell.textLabel?.text = track.name
        cell.textLabel?.textColor = UIColor.init(colorLiteralRed: 230.0/255, green: 230.0/255, blue: 230.0/255, alpha: 1)
        cell.textLabel?.font = UIFont.init(name: "Montserrat", size: 17.0)
        cell.backgroundColor = UIColor.blackColor()

        return cell
    }
    
    @IBAction func popVC(sender: UIButton)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
