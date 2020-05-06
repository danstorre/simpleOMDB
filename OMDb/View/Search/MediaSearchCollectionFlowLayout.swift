//
//  MediaSearchCollectionFlowLayout.swift
//  OMDb
//
//  Created by Daniel Torres on 5/6/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

class MediaSearchCollectionFlowLayout: UICollectionViewFlowLayout {
    
    lazy var cellTest: UIView = MediaViewCollectionViewCell().cellContentView
    
    override func prepare() {
        super.prepare()
        
        guard let cv = collectionView else {
            return
        }
        let availableWidth = cv.bounds.insetBy(dx: cv.layoutMargins.left, dy: 0).width
        scrollDirection = .vertical
        itemSize = CGSize(width: availableWidth, height: 220)
        
        self.sectionInset = UIEdgeInsets(top: 10,
                                         left: 0,
                                         bottom: 10,
                                         right: 0)
        
        self.sectionInsetReference = .fromSafeArea
        
    }
}
