//
//  PostersCarouselFlowLayout.swift
//  OMDb
//
//  Created by Daniel Torres on 5/5/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

class PostersCarouselFlowLayout: UICollectionViewFlowLayout {
    
    lazy var cellTest: UIView = MediaViewCollectionViewCell().cellContentView
    
    override func prepare() {
        super.prepare()
        
        guard let cv = collectionView else {
            return
        }
        
        itemSize = CGSize(width: 119, height: 189)
        
        self.sectionInset = UIEdgeInsets(top: minimumInteritemSpacing,
                                         left: 0,
                                         bottom: 0,
                                         right: 0)
        
        self.sectionInsetReference = .fromSafeArea
        
    }
}
