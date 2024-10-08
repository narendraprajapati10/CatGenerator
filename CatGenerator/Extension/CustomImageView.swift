//
//  CustomImageView.swift
//  CatGenerator
//
//  Created by WhyQ on 08/10/24.
//

import UIKit

let imageCache = NSCache<AnyObject,AnyObject>()

class CustomImageView : UIImageView {
    var task:URLSessionDataTask!
    var spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    func loadImage(from url: URL) {
        image = nil
        
        addSpinner()
        
        if let task = task {
            task.cancel()
        }
    //Custom way to handle Logic for imageCache
        if let imageFromCache = imageCache.object(forKey: url.absoluteString as AnyObject) as? UIImage {
            image = imageFromCache
            removeSpinner()
            return
        }
 // Download image from URL
        task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let data = data,
                let newImage = UIImage(data: data)
            else {
                print("could not load image from url : \(url)")
                return
            }
            
            imageCache.setObject(newImage, forKey: url.absoluteString as AnyObject)
            
            DispatchQueue.main.async {
                self.image = newImage
                self.removeSpinner()
            }
        }
        task.resume()
    }
    
    func addSpinner() {
        addSubview(spinner)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        spinner.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        spinner.startAnimating()
    }
    
    func removeSpinner() {
        spinner.removeFromSuperview()
    }
}

