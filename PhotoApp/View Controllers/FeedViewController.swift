//
//  FeedViewController.swift
//  PhotoApp
//
//  Created by Rebecca Banks on 11/06/2020.
//  Copyright © 2020 Rebecca Banks. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var photos = [Photo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view controller as the delegate and datasource
        tableView.delegate = self
        tableView.dataSource = self
        
        // Add pull to refresh
        addRefreshControl()
        
        // Call the photo service to retrieve the photos
        PhotoService.retrievePhotos { (retrivedPhotos) in
            
            // Set out photos array to the retrieved photos
            self.photos = retrivedPhotos
            
            // Reload the table view
            self.tableView.reloadData()
        }
    }
    
    func addRefreshControl() {
        
        // Create refresh control
        let refresh = UIRefreshControl()
        
        // Set target
        refresh.addTarget(self, action: #selector(refreshFeed(refreshControl:)), for: .valueChanged)
        
        // Add to table view
        self.tableView.addSubview(refresh)
        
    }
    
    @objc func refreshFeed(refreshControl: UIRefreshControl) {
        
        // Call the photo service
        PhotoService.retrievePhotos { (newPhotos) in
            
            // Assign new photos to our photos property
            self.photos = newPhotos
            
            DispatchQueue.main.async {
                
                // Refresh table view
                self.tableView.reloadData()
                
                // Stop the spinner
                refreshControl.endRefreshing()
            }
        }
    }

}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return photos.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Get a photo cell
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Storyboard.photoCellID, for: indexPath) as? PhotoCell
        
        // Get the photo the cell is displaying
        let photo = self.photos[indexPath.row]
        
        // Call display photo method of the cell
        cell?.displayPhoto(photo: photo)
        
        // Return the cell
        return cell!
    }
    
    
}
