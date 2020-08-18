//
//  LoginViewController.swift
//  PhotoApp
//
//  Created by Rebecca Banks on 11/06/2020.
//  Copyright © 2020 Rebecca Banks. All rights reserved.
//

import UIKit
import FirebaseUI

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        
        // Create a Firebase AuthUI object
        let authUI = FUIAuth.defaultAuthUI()
        
        // Check that it isnt nil
        if let authUI = authUI {
            
            // Set self as delegate for the authUI
            authUI.delegate = self
            
            // Set sign in providers
            authUI.providers = [FUIEmailAuth()]
            
            // Get the prebuilt UI view controller
            let authViewController = authUI.authViewController()
            
            // Present it
            present(authViewController, animated: true, completion: nil)
            
        }
        
    }
    
}

extension LoginViewController: FUIAuthDelegate {
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
    
        if error != nil {
            // There was an error
            return
        }
        
        let user = authDataResult?.user
        
        if let user = user {
            
            // Got a user
            // Check on the database side if the user has a profile
            UserService.retrieveProfile(userID: user.uid) { (user) in
                
                // Check if user is nil
                
                if user == nil {
                    // Go to create profile view controller
                    self.performSegue(withIdentifier: Constants.Storyboard.profileSeque, sender: self)
                    
                }
                else {
                    // Go to tab bar controller
                    
                    // Save user to local storage
                    LocalStorageService.saveUser(userID: user!.userID, username: user!.username)
                    
                    // Create an instance of the tab bar controller
                    let tabBarVC = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.tabBarController)
                    
                    guard tabBarVC != nil else {
                        return
                    }
                    
                    // Set it as the root view controller of the window
                    self.view.window?.rootViewController = tabBarVC
                    self.view.window?.makeKeyAndVisible()
                }
            
            }
            
            
        }
        
    }
    
    
}
