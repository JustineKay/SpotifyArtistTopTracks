//
//  SATopTracksTableViewController.swift
//  SpotifyArtistTopTracks
//
//  Created by Justine Kay on 6/14/16.
//  Copyright © 2016 Justine Kay. All rights reserved.
//

import UIKit
import SDWebImage

class SATopTracksTableViewController: UITableViewController {

    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var artistNameLabel: UILabel!
    
    var spotifyArtist = SpotifyArtist()
    var results = [Mappable]()
    let trackCellReuseIdentifier = "TrackTableViewCellIdentifier"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        fetchArtistTopTracks()
        setUpSelectedArtistUI()
        setUpCustomTableViewCell()
        setUpTableView()
    }
    
    //MARK: - UI
    
    func setUpSelectedArtistUI()
    {
        artistNameLabel.text = spotifyArtist.name
        if let image = spotifyArtist.profileImage {
            let spotifyArtistImageURL = NSURL(string: image)
            artistImageView.sd_setImageWithURL(spotifyArtistImageURL)
        }
    }
    
    func setUpCustomTableViewCell()
    {
        let nib = UINib.init(nibName: "TrackTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: trackCellReuseIdentifier)
    }
    
    func setUpTableView()
    {
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44.0
        self.tableView.backgroundColor = UIColor.blackColor()
    }
    
    //MARK: - Networking
    
    private func fetchArtistTopTracks()
    {
        let url = SARequestManager.sharedService.tracksURL(spotifyArtist)
        let track = Track()
        SARequestManager.sharedService.getDataWithCompletion(url, mappable: track) { (response) in
            switch response {
            case .Failure(error: let error):
                print("Error fetching top tracks: \(error)")
            case .Success(mappables: let returnedTracks):
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
        let cell = tableView.dequeueReusableCellWithIdentifier(trackCellReuseIdentifier, forIndexPath: indexPath) as? TrackTableViewCell
        
        let track = results[indexPath.row] as? Track
        cell!.trackNameLabel.text = track!.name

        return cell!
    }
    
    @IBAction func popVC(sender: UIButton)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
