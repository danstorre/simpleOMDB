//
//  ListCollectionViewLayout.swift
//  OMDb
//
//  Created by Daniel Torres on 5/11/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

class ListCollectionViewLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        
        guard let cv = collectionView else {
            return
        }
        let availableWidth = cv.bounds.size.width
        scrollDirection = .vertical
        itemSize = CGSize(width: availableWidth, height: 204)
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        self.sectionInset = UIEdgeInsets(top: 0,
                                         left: 0,
                                         bottom: 0,
                                         right: 0)
        
        self.sectionInsetReference = .fromSafeArea
    }
}

