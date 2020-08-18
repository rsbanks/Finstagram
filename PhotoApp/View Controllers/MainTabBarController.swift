//
//  MainTabBarController.swift
//  PhotoApp
//
//  Created by Rebecca Banks on 17/06/2020.
//  Copyright © 2020 Rebecca Banks. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        // Detect which tab was tapped on
        if item.tag == 2 {
            
            // Camera tag was tapped on
            
            // Create the action sheet
            let actionSheet = UIAlertController(title: "Add a Photo", message: "Select a source:", preferredStyle: .actionSheet)
           
            // Only add camera button if its availible
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                // Create and add the Camera button
                let cameraButton = UIAlertAction(title: "Camera", style: .default) { (action) in
                    
                    // Display the UIImagePickerController set to camera mode
                    self.showImagePickerController(mode: .camera)
                    
                }
                actionSheet.addAction(cameraButton)
            }
            
            // Only add the library button if it is availible
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                
                // Create and add the Photo Libary button
                let libraryButton = UIAlertAction(title: "Photo Library", style: .default) { (action) in
                    
                    // Display the UIImagePickerController set to  library mode
                    self.showImagePickerController(mode: .photoLibrary)
                }
                actionSheet.addAction(libraryButton)
            }
            
            // Create and add the cancel button
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            actionSheet.addAction(cancelButton)
            
            // Display the action sheet
            present(actionSheet, animated: true, completion: nil)
        }
        
        
    }
    
    func showImagePickerController(mode: UIImagePickerController.SourceType) {
        
        // Create the picker and set the mode
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = mode
        
        // Set the tab bar controller as the delegate
        imagePicker.delegate = self
        
        // Present the image picker
        present(imagePicker, animated: true, completion: nil)
    }

}

extension MainTabBarController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        // Dismiss the image picker
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // Get a reference to the selected photo
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        // Check that the selected image isnt nil
        if let selectedImage = selectedImage {
            
            // Get a reference to the camera view controller
            let cameraVC = self.selectedViewController as? CameraViewController
            
            if let cameraVC = cameraVC {
                
                // Upload it
                cameraVC.savePhoto(image: selectedImage)
            }
            
        }
        
        // Dismiss the image picker
        dismiss(animated: true, completion: nil)
        
    }
    
    func goToFeed() {
        
        // Switch tab to the first one
        selectedIndex = 0
    }
    
}
