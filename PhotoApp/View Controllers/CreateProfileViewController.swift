//
//  CreateProfileViewController.swift
//  PhotoApp
//
//  Created by Rebecca Banks on 11/06/2020.
//  Copyright © 2020 Rebecca Banks. All rights reserved.
//

import UIKit
import FirebaseAuth

class CreateProfileViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func confirmTapped(_ sender: Any) {
        
        // Check that there is a user logged in
        guard Auth.auth().currentUser != nil else {
            
            // No user logged in
            return
        }
        
        // Get the username
        // Check it against whitespaces, new lines, illegal characters
        let username = usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // check that the username isn't nil
        if username == nil || username == "" {
            
            // Show an error message
            return
        }
        
        // Call the user services to create the profile
        UserService.createProfile(userID: Auth.auth().currentUser!.uid, username: username!) { (user) in
            
            // Check if it was created successfully
            if user != nil {
                
                // save the user to local storage
                LocalStorageService.saveUser(userID: user!.userID, username: user!.username)
                
                // Go to the tab bar controller
                let tabBarVC = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.tabBarController)
                self.view.window?.rootViewController = tabBarVC
                self.view.window?.makeKeyAndVisible()
                
            }
            else {
                
                 // Display error
                
            }
        
            
        }
    
        
    }
    
}
