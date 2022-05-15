//
//  UIImageView+Extension.swift
//  PosterHoster
//
//  Created by Kartik Gupta on 14/05/22.
//

import Foundation
import UIKit

let imageCache = NSCache<AnyObject, UIImage>()

class LazyImageView: UIImageView {
        
    var imageURLName: String?
    
    func downloadFromLink(name: String, contentMode: UIView.ContentMode) {
        
        imageURLName = name
        self.image = UIImage(named: "placeholder_for_missing_posters")
        
        if let cachedImage = imageCache.object(forKey: name as AnyObject) {
            print("downloaded from cache for \(name)")
            self.image = cachedImage
            return
        }
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.5, execute: {
            DispatchQueue.main.async {
                print("downloaded from server for \(name)")
                if let imageData = UIImage(named: name) {
                    imageCache.setObject(imageData, forKey: name as AnyObject)
                } else {
                    let imageData = UIImage(named: "placeholder_for_missing_posters")
                    imageCache.setObject(imageData!, forKey: name as AnyObject)
                }
                if self.imageURLName == name {
                    self.image = UIImage(named: name) ?? UIImage(named: "placeholder_for_missing_posters")
                }
            }
        })
    }
}
