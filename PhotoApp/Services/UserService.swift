//
//  UserService.swift
//  PhotoApp
//
//  Created by Rebecca Banks on 16/06/2020.
//  Copyright © 2020 Rebecca Banks. All rights reserved.
//

import Foundation
import FirebaseFirestore

class UserService {
    
    static func createProfile(userID:String, username:String, completion: @escaping (PhotoUser?) -> Void) {
        
        // Create a dictionary for the profile data
        let profileData = ["username":username]
        
        // Get a firestore reference
        let db = Firestore.firestore()
        
        // Create the document for the user id
        db.collection("users").document(userID).setData(profileData) { (error) in
            
            // Check for errors
            if error == nil {
                
                // Profile was created successfully
                // Create and return a photo user
                var user = PhotoUser()
                user.username = username
                user.userID = userID
                
                completion(user)
            }
            else {
                
                // Could not create profile
                // Return nil
                completion(nil)
            }
        }
        
        // return result
        
        
    }
    
    static func retrieveProfile(userID:String, completion: @escaping (PhotoUser?) -> Void) {
        
        // Get a firestore reference
        let db = Firestore.firestore()
        
        // Check for a profile given the userID
        db.collection("users").document(userID).getDocument { (snapshot, error) in
            
            if error != nil || snapshot == nil {
                // Something wrong happened
                return
            }
            if let profile = snapshot!.data() {
               // Profile was found, create a new photo user
                var user = PhotoUser()
                user.userID = snapshot!.documentID
                user.username = profile["username"] as? String
                
                // Return the user
                completion(user)
            }
            else {
                // Couldn't get profile
                // Return nil
                completion(nil)
            }
        }
        
        
        
    }
    
}
