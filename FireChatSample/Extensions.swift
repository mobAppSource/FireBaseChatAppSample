//
//  Extensions.swift
//  FireChatSample
//
//  Created by Master on 7/2/16.
//  Copyright © 2016 Master. All rights reserved.
//

import Foundation
import UIKit


extension UIColor{
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat){
        self.init(red: r/255, green: g/255, blue: b/255, alpha: alpha)
    }
}

//hidding keyboard
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
var imgCache = NSCache()
extension UIImageView{
    func loadImageCacheWithURLString(urlString: String)
    {
        self.image = nil
        //check cache for image first
        if let cachedImage = imgCache.objectForKey(urlString) as? UIImage{
            self.image = cachedImage
            return
        }
        // downloading from the database
        let url = NSURL(string: urlString)
        NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: {
            (data, response, error) in
            if error != nil{
                print(error)
                return
            }
            dispatch_async(dispatch_get_main_queue(), {
                print("Image: \(urlString)")
                if let downloadImg = UIImage(data: data!){
                    imgCache.setObject(downloadImg, forKey: urlString)
                    self.image = downloadImg
                    
                }
            })
        }).resume()
    }
}