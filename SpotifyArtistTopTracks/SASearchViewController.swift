//
//  SASearchViewController.swift
//  SpotifyArtistTopTracks
//
//  Created by Justine Kay on 6/14/16.
//  Copyright © 2016 Justine Kay. All rights reserved.
//

import UIKit

class SASearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{

    @IBOutlet weak var artistNameTextField: UITextField!
    @IBOutlet weak var searchResultsTableView: UITableView!
    
    var results = [SpotifyArtist]()
    let artistCellReuseIdentifier = "artistCellReuseIdentifier"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.searchResultsTableView.delegate = self
        self.searchResultsTableView.dataSource = self
    }
    
    //MARK: - Actions
    
    @IBAction func performSearch(sender: UIButton)
    {
        SARequestManager.sharedService.getArtistsWithCompletion(artistNameTextField.text!) { (response) in
            switch response {
            case .Failure(error: let error):
                print("Error fetching artists: \(error)")
            case .Success(artists: let returnedArtists):
                print("Success: \(returnedArtists)")
                self.results = returnedArtists
                self.searchResultsTableView.reloadData()
            }
        }
    }
    
    //MARK: - TableView delegate methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return results.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(artistCellReuseIdentifier, forIndexPath: indexPath)
        
        // Configure the cell...
        let spotifyArtist = results[indexPath.row]
        cell.textLabel?.text = spotifyArtist.name
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let indexPath = self.searchResultsTableView.indexPathForSelectedRow
        let selectedArtist = results[indexPath!.row]
        let destination = segue.destinationViewController as? UITableViewController
        if let topTracksVC = destination as? SATopTracksTableViewController {
            topTracksVC.spotifyArtist = selectedArtist
        }
        
    }
    
}
