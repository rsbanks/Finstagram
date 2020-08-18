//
//  LocalStorageService.swift
//  PhotoApp
//
//  Created by Rebecca Banks on 16/06/2020.
//  Copyright © 2020 Rebecca Banks. All rights reserved.
//

import Foundation

class LocalStorageService {
    
    static func saveUser(userID:String?, username:String?) {
        
        // Get a reference to user defaults
        let defaults = UserDefaults.standard
        
        // Save the user id and username to defaults
        defaults.set(userID, forKey: Constants.LocalStorage.userIDKey)
        defaults.set(username, forKey: Constants.LocalStorage.usernameKey)
    }
    
    static func loadUser() -> PhotoUser? {
        
        // Get a reference to user defaults
        let defaults = UserDefaults.standard
        
        // Get the username and ID
        let userID = defaults.value(forKey: Constants.LocalStorage.userIDKey) as? String
        let username = defaults.value(forKey: Constants.LocalStorage.usernameKey) as? String
        
        
        // Return the result
        if userID != nil && username != nil {
            // Return saved user
            return PhotoUser(userID: userID, username: username)
        }
        else {
            // there was no saved user
            return nil
        }
        
        
    }
    
    static func clearUser() {
        
        // Get a reference to user defaults
        let defaults = UserDefaults.standard
        
        // Clear the values for the keys
        defaults.set(nil, forKey: Constants.LocalStorage.usernameKey)
        defaults.set(nil, forKey: Constants.LocalStorage.userIDKey)
    }
}
