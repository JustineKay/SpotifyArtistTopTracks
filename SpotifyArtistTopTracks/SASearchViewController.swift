//
//  SASearchViewController.swift
//  SpotifyArtistTopTracks
//
//  Created by Justine Kay on 6/14/16.
//  Copyright © 2016 Justine Kay. All rights reserved.
//

import UIKit

class SASearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate
{

    @IBOutlet weak var artistNameTextField: UITextField!
    @IBOutlet weak var searchResultsTableView: UITableView!
    
    var results = [Mappable]()
    let artistCellReuseIdentifier = "artistCellReuseIdentifier"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.searchResultsTableView.delegate = self
        self.searchResultsTableView.dataSource = self
        self.artistNameTextField.delegate = self
        
        artistNameTextField.clearsOnBeginEditing = true
        artistNameTextField.addTarget(self, action: #selector(SASearchViewController.textFieldDidChange), forControlEvents: UIControlEvents.EditingChanged)
        
        searchResultsTableView.backgroundColor = UIColor.blackColor()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        artistNameTextField.text = nil
    }
    
    //MARK: - Actions
    
    private func performSearch()
    {
        let artist = SARequestManager.sharedService.getArtist(artistNameTextField.text!)
        let url = SARequestManager.sharedService.artistsURL(artist.name!)
        
        
        SARequestManager.sharedService.getDataWithCompletion(url, mappable: artist) { (response) in
            switch response {
            case .Failure(error: let error):
                print("Error fetching artists: \(error)")
            case .Success(artists: let returnedArtists):
                //print("Success: \(returnedArtists)")
                self.results = returnedArtists
                self.searchResultsTableView.reloadData()
            }
        }
    }
    
    //MARK: - Table view data source
    
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
        
        let spotifyArtist = results[indexPath.row] as? SpotifyArtist
        cell.textLabel?.text = spotifyArtist!.name
        cell.textLabel?.textColor = UIColor.init(colorLiteralRed: 230.0/255, green: 230.0/255, blue: 230.0/255, alpha: 1)
        cell.textLabel?.font = UIFont.init(name: "Montserrat", size: 17.0)
        cell.backgroundColor = UIColor.blackColor()
        
        
        return cell
    }
    
    //MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        let indexPath = self.searchResultsTableView.indexPathForSelectedRow
        let selectedArtist = results[indexPath!.row] as? SpotifyArtist
        let destination = segue.destinationViewController as? UITableViewController
        if let topTracksVC = destination as? SATopTracksTableViewController {
            topTracksVC.spotifyArtist = selectedArtist!
        }
    }
    
    //MARK: - Text field delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        performSearch()
        self.view.endEditing(true)
        return true
    }
    
    func textFieldDidChange()
    {
        performSearch()
    }
    
}
