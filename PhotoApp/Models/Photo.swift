//
//  Photo.swift
//  PhotoApp
//
//  Created by Rebecca Banks on 18/06/2020.
//  Copyright © 2020 Rebecca Banks. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Photo {
    
    var photoID:String?
    var byID:String?
    var byUsername:String?
    var date:String?
    var url:String?
    
    init? (snapshot:QueryDocumentSnapshot){
        // Parse the data out
        let data = snapshot.data()
        
        let photoID = data["photoID"] as? String
        let userID = data["byID"] as? String
        let username = data["byUsername"] as? String
        let date = data["date"] as? String
        let url = data["url"] as? String
        
        // Check for missing data
        if photoID == nil || userID == nil || username == nil || date == nil || url == nil {
            return nil
        }
        
        // Set our properties
        self.photoID = photoID
        self.byID = userID
        self.byUsername = username
        self.date = date
        self.url = url
    }
    
}
