//
//  UIImage+OpenTweet.swift
//  OpenTweet
//
//  Created by Myke on 3/31/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

import Foundation
import UIKit

class WebImage {
    
    private var session: URLSession?
    private lazy var imagePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    
    /// Will look for a local cahced image or downlod it from the web if cached copy is not found.
    /// - Parameters:
    ///   - imageURL: URL of where to get the image from.
    ///   - completion: Callback for when the image is ready or to notify of an error in retrieving the image.
    func loadImage(from imageURL: String, completion: @escaping (UIImage?, Error?) -> Void) {
        // In the real world I would not force unwrap any of these but for speed here we are.
        // First check if we have already downloaded the image. If so use the cached version.
        // Simple cache system is using an MD5 of the image url as a file name.
        let url = NSURL(fileURLWithPath: imagePath)
        let fileName = try! MD5(imageURL)
        let filePath = url.appendingPathComponent(fileName)
        
        if  FileManager.default.fileExists(atPath: filePath!.absoluteString) {
            guard let file = filePath?.absoluteString else {
                let error = NSError(domain: "Error loading file", code: 408, userInfo: ["description" : "Error loading cached file."])
                completion(nil, error)
                return
            }
            completion(UIImage(contentsOfFile: file), nil)
        } else {
            downloadImage(from: imageURL, completion: completion)
        }
        
    }

    
    /// Cancels the download request.
    func cancel() {
        session?.invalidateAndCancel()
        session = nil
    }
    
    
    /// Downloads the image from the web and saves a local cache copy in the Documents folder.
    /// - Parameters:
    ///   - imageURL: URL of where to get the image from.
    ///   - completion: Callback for when the image is done downloading or to return a netowrk error.
    fileprivate func downloadImage(from imageURL: String, completion: @escaping(UIImage?, Error?) -> Void) {
        let request = URLRequest(url: URL(string: imageURL)!)
        session = URLSession(configuration: .default)
        session?.dataTask(with: request) { data, response, error in
            guard let imageData = data,
                  error == nil
            else {
                completion(nil, error)
                return
            }
            
            let url = NSURL(fileURLWithPath: self.imagePath)
            let fileName = try! MD5(imageURL)
            let filePath = url.appendingPathComponent(fileName)!
            
            try! imageData.write(to: filePath)
            
            completion(UIImage(data: imageData), nil)
            
        }.resume()
        
        return
    }
    
}
