//
//  ListMediaMediaCollectionDataSource.swift
//  OMDb
//
//  Created by Daniel Torres on 5/11/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

protocol ListMediaMediaCollectionDataSourceProtocol: MediaCollectionDataSourceProtocol, HasNavigation {
    init(withArray: [Media]?, withCellIdentifier: String, navigationObject: NavigationProtocol?)
}

final class ListMediaMediaCollectionDataSource: NSObject, ListMediaMediaCollectionDataSourceProtocol{
    var mediaArray: [Media]?
    var navigationObject: NavigationProtocol?
    private let cellIdentifier: String
    
    required init(withArray mediaArray: [Media]?,
                  withCellIdentifier cellIdentifier: String, navigationObject: NavigationProtocol?) {
        self.mediaArray = mediaArray
        self.cellIdentifier = cellIdentifier
        self.navigationObject = navigationObject
        super.init()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier,
                                                            for: indexPath) as? ListItemMediaViewCollectionViewCell
        else {
                return UICollectionViewCell()
        }
        
        return cell
    }
}
