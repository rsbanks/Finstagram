//
//  PhotoCell.swift
//  PhotoApp
//
//  Created by Rebecca Banks on 21/06/2020.
//  Copyright © 2020 Rebecca Banks. All rights reserved.
//

import UIKit

class PhotoCell: UITableViewCell {
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    var photo:Photo?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func displayPhoto(photo:Photo) {
        
        // Reset the image
        self.photoImageView.image = nil
        
        // Set photo property
        self.photo = photo
        
        // Set the username
        usernameLabel.text = photo.byUsername
        
        // Set the date
        dateLabel.text = photo.date
        
        // Check that there is a valid download url
        if photo.url == nil {
            return
        }
        
        // Check if the image is in our image cache. If it is, use it
        if let cachedImage = ImageCacheService.getImage(url: photo.url!) {
            
            // Use the cached image
            self.photoImageView.image = cachedImage
            
            return
        }
        
        // Download the image
        let url = URL(string: photo.url!)
        
        // Check that the url object was created
        if url == nil {
            return
        }
        
        // Use URL session to download the image asynchronously
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: url!) { (data, response, error) in
            
            // Check for errors and data
            if error == nil && data != nil {
                
                // Set the image view
                let image = UIImage(data: data!)
                
                // Store the image data in cache
                ImageCacheService.saveImage(url: url!.absoluteString, image: image)
                
                // Check that the image data we downloaded matches the photo this cell is meant to be displaying
                if url!.absoluteString != self.photo?.url! {
                    return
                }
                
                DispatchQueue.main.async {
                    self.photoImageView.image = image
                }
            }
            
        }
        dataTask.resume()
        
    }

}
