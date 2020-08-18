//
//  CameraViewController.swift
//  PhotoApp
//
//  Created by Rebecca Banks on 11/06/2020.
//  Copyright © 2020 Rebecca Banks. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController {
    
    @IBOutlet weak var progressLabel: UILabel!
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Hide and reset all elements
        progressBar.alpha = 0
        progressBar.progress = 0
        
        progressLabel.alpha = 0
        
        doneButton.alpha = 0
    }
    
    func savePhoto(image: UIImage) {
        
        // Calls the photo service to store the photo
        PhotoService.savePhoto(image: image) { (percentageComplete) in
            
            DispatchQueue.main.async {
                
                // Update the progress bar
                self.progressBar.alpha = 1
                self.progressBar.progress = Float(percentageComplete)
                
                // Update the label
                let roundedPercent = Int(percentageComplete * 100)
                self.progressLabel.text = "\(roundedPercent)%"
                self.progressLabel.alpha = 1
                
                // Check if it is done
                if roundedPercent == 100{
                    self.doneButton.alpha = 1
                }
            }
        }
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        
        // Get a reference to the tab bar controller
        let tabBarVC = self.tabBarController as? MainTabBarController
        
        if let tabBarVC = tabBarVC {
            
            // Call goToFeed()
            tabBarVC.goToFeed()
            
        }
        
    }
    
}
