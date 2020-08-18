//
//  ImageCacheService.swift
//  PhotoApp
//
//  Created by Rebecca Banks on 21/06/2020.
//  Copyright © 2020 Rebecca Banks. All rights reserved.
//

import Foundation
import UIKit

class ImageCacheService {
    
    static var imageCache = [String:UIImage]()
    
    static func saveImage(url:String?, image:UIImage?) {
        
        // Check against nil
        if url == nil || image == nil {
            return
        }
        
        // Save the image
        imageCache[url!] = image!
    }
    
    static func getImage(url:String?) -> UIImage? {
        
        // Check that url isnt nil
        if url == nil {
            return nil
        }
        
        // Check the image cache for the url
        return imageCache[url!]
    }
    
}
