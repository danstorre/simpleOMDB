//
//  ImageProvider.swift
//  OMDb
//
//  Created by Daniel Torres on 4/4/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

enum ImageDownloader{
    static func getImageFrom(urllink: URL) throws -> UIImage?{
        do{
            let data = try Data(contentsOf: URL(string: urllink.absoluteString)! )
            guard let uiimage = UIImage(data: data) else {
                return nil
            }
            return uiimage
        }catch{
            return nil
        }
    }
}


struct ImageProvider {
    
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
            
            do {
                let image = try ImageDownloader.getImageFrom(urllink: urllink)
                DispatchQueue.main.async {
                    finishedBlock(image, indexPath)
                }
            }catch let error{
                print(error)
                DispatchQueue.main.async {
                    finishedBlock(nil, indexPath)
                }
            }
        }
    }
    
    
}
