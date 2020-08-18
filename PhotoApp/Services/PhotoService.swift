//
//  PhotoService.swift
//  PhotoApp
//
//  Created by Rebecca Banks on 18/06/2020.
//  Copyright © 2020 Rebecca Banks. All rights reserved.
//

import Foundation
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

class PhotoService {
    
    static func retrievePhotos(completetion: @escaping ([Photo]) -> Void) {
        // Get a database reference
        let db = Firestore.firestore()
        
        // Get all of the documents from the photos collection
        db.collection("photos").getDocuments { (snapshot, error) in
            
            // Check for errors
            if error != nil {
                // There is an error
                return
            }
            
            // Get all of the documents
            let documents = snapshot?.documents
            
            // Check that documents aren't nil
            if let documents = documents {
                
                // Create an array to hold all of the photos
                var photoArray = [Photo]()
                
                // Parse the documents into Photo structs
                for doc in documents {
                    
                    let p = Photo(snapshot: doc)
                    
                    if p != nil {
                        // Store it in the array
                        photoArray.insert(p!, at: 0)
                    }
                    
                }
                // Pass back the photo array
                completetion(photoArray)
                
            }
        
            
            
        }
        
    }
    
    static func savePhoto(image:UIImage, progressUpdate: @escaping (Double) -> Void) {
        
        // Check that there is a user logged in
        if Auth.auth().currentUser == nil {
            return
        }
        
        // Get the data representation of the UIImage
        let photoData = image.jpegData(compressionQuality: 0.1)
        
        guard photoData != nil else {
            // Error, couldnt get the data from the UIImage
            return
        }
        
        // Create a filename
        let filename = UUID().uuidString
        
        // Get the userID of the current user
        let userID = Auth.auth().currentUser!.uid
        
        // Create a firebase storage path/reference
        let ref = Storage.storage().reference().child("images/\(userID)/\(filename).jpg")
        
        // Upload the data
        let uploadTask = ref.putData(photoData!, metadata: nil) { (metadata, error) in
            
            // Check if the upload was successful
            if error == nil {
                // Upon successful upload, creatre the database entry
                self.createDatabseEntry(ref: ref)
            }
        }
        
        uploadTask.observe(.progress) { (taskSnapshot) in
            
            let percentComplete = Double(taskSnapshot.progress!.completedUnitCount) / Double(taskSnapshot.progress!.totalUnitCount)
            
            print(percentComplete)
            
            progressUpdate(percentComplete)
        }
        
        
    }
    
    private static func createDatabseEntry(ref: StorageReference) {
        
        // Download url
        ref.downloadURL { (url, error) in
            
            // Check for an error
            if error == nil {
                // Photo ID
                let photoID = ref.fullPath
                
                // Get the current user
                let photoUser = LocalStorageService.loadUser()
                
                // User ID
                let userID = photoUser?.userID
                
                // Username
                let username = photoUser?.username
                
                // Date
                let df = DateFormatter()
                df.dateStyle = .full
                let dateString = df.string(from: Date())
                
                // Create a dictionary of the photo metadata
                let metadata = ["photoID":photoID, "byID":userID!, "byUsername":username, "date":dateString, "url":url!.absoluteString]
                
                // Save the metadata to the firestore database
                let db = Firestore.firestore()
                
                db.collection("photos").addDocument(data: metadata) { (error) in
                    
                    // Check if the saving of data was sucessful
                    if error == nil {
                        
                        // Saved data to database successfully
                    }
                }
            }
        }
    
        
        
    }
        
    
}
