//
//  ImageProvider.swift
//  OMDb
//
//  Created by Daniel Torres on 4/4/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

enum ImageDownloader{
    static func getImageFrom(urllink: URL, completionHandler: @escaping ( (UIImage?) -> ())){
        let task = SessionsCoordinator.cacheSession.dataTask(with: urllink) { (data, urlResponse, error) in
            
            guard let data = data else {
                completionHandler(nil)
                return
            }
            guard let uiimage = UIImage(data: data) else {
                completionHandler(nil)
                return
            }
            
            completionHandler(uiimage)
        }
        task.resume()
    }
}


struct ImageProvider {
    
    static func getImage(media: Media,
                         finishedBlock: @escaping ((UIImage?) -> ())) {

        
        DispatchQueue.global(qos: .userInteractive).async {
            let urlImage = media.poster
            
            guard let urllink = URL(string: urlImage) else{
                DispatchQueue.main.async {
                    finishedBlock(nil)
                }
                return
            }
            
            ImageDownloader.getImageFrom(urllink: urllink, completionHandler: {image in
                DispatchQueue.main.async {
                    finishedBlock(image)
                }
            })
        }
    }
    
    static func getImage(media: Media,
                         indexPath: IndexPath,
                         finishedBlock: @escaping ((UIImage?, IndexPath) -> ())) {

        
        DispatchQueue.global(qos: .userInteractive).async {
            let urlImage = media.poster
            
            guard let urllink = URL(string: urlImage) else{
                DispatchQueue.main.async {
                    finishedBlock(nil, indexPath)
                }
                return
            }
            
            ImageDownloader.getImageFrom(urllink: urllink, completionHandler: {image in
                DispatchQueue.main.async {
                    finishedBlock(image, indexPath)
                }
            })
        }
    }
    
    
}
