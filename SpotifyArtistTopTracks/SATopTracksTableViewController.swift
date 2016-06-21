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

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var artistNameLabel: UILabel!
    
    var spotifyArtist = SpotifyArtist()
    var results = [Mappable]()
    let trackCellReuseIdentifier = "TrackTableViewCellIdentifier"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        fetchArtistTopTracks()
        setUpSelectedArtistProfileUI()
        setUpCustomTableViewCell()
        setUpTableView()
    }
    
    //MARK: - UI
    
    func setUpSelectedArtistProfileUI()
    {
        artistNameLabel.text = spotifyArtist.name
        artistImageView.layer.cornerRadius = 75.0
        
        if let image = spotifyArtist.profileImage {
            let spotifyArtistImageURL = NSURL(string: image)
            artistImageView.sd_setImageWithURL(spotifyArtistImageURL)
            backgroundImageView.sd_setImageWithURL(spotifyArtistImageURL)
        }
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = backgroundImageView.bounds
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight] // for supporting device rotation
        backgroundImageView.addSubview(blurEffectView)
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
        cell!.albumNameLabel.text = track!.albumName
        if let image = track!.albumCoverImage {
            let albumCoverImageURL = NSURL(string: image)
            cell!.albumCoverImageView.sd_setImageWithURL(albumCoverImageURL)
        }

        return cell!
    }
    
    @IBAction func popVC(sender: UIButton)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
