//
//  MediaCollectionDataSource.swift
//  OMDb
//
//  Created by Daniel Torres on 5/5/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

protocol MediaCollectionDataSourceProtocol: UICollectionViewDataSource{
    var mediaArray: [Media]? {get set}
}

final class MediaCollectionDataSource: NSObject, MediaCollectionDataSourceProtocol {

    var mediaArray: [Media]?
    
    private let cellIdentifier: String
    
    init(withArray medias: [Media]?, withCellIdentifier cellIdentifier: String) {
        self.cellIdentifier = cellIdentifier
        super.init()
        mediaArray = medias
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier,
                                                      for: indexPath) as! MediaViewViewCellProtocol
        
        guard let mediaArray = mediaArray else {
            return cell
        }
        let media = mediaArray[indexPath.row]
        cell.titleLabel.text = media.name
        cell.yearLabel.text = media.year
        cell.typeLabel.text = media.type?.rawValue
        cell.tag = indexPath.row
        
        cell.posterImage.alpha = 0
        
        ImageProvider.getImage(media: media,
                               indexPath: indexPath) { [weak cell] (image, indexPath) in
            DispatchQueue.main.async {
                guard let cell = cell else {
                    return
                }
                if cell.tag == indexPath.row {
                    cell.posterImage.image = image
                    cell.posterImage.showAnimation()
                }
            }
        }
        return cell
    }
    
}
