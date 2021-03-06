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
        let availableWidth = cv.bounds.size.width
        scrollDirection = .vertical
        itemSize = CGSize(width: availableWidth, height: 190)
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        let height: CGFloat = 44
        headerReferenceSize = CGSize(width: availableWidth, height: height)
        self.sectionInset = UIEdgeInsets(top: 0,
                                         left: 0,
                                         bottom: 0,
                                         right: 0)
        
        self.sectionInsetReference = .fromSafeArea
        
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String,
                                              at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let layoutAttributes = super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)
        
        guard let cv = collectionView else {
            return layoutAttributes
        }
        let availableWidth = cv.bounds.size.width
        let height: CGFloat = 44
        layoutAttributes?.bounds.size = CGSize(width: availableWidth, height: height)
        
        return layoutAttributes
    }
}
