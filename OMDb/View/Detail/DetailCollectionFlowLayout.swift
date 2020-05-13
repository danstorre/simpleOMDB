//
//  DetailCollectionFlowLayout.swift
//  OMDb
//
//  Created by Daniel Torres on 5/13/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit


class DetailCollectionFlowLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        
        guard let cv = collectionView else {
            return
        }
        let availableWidth = cv.bounds.size.width
        scrollDirection = .vertical
        estimatedItemSize = CGSize(width: availableWidth, height: 144)
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        headerReferenceSize = CGSize(width: availableWidth, height: 292)
        self.sectionInset = UIEdgeInsets(top: 0,
                                         left: 0,
                                         bottom: 0,
                                         right: 0)
        
        self.sectionInsetReference = .fromSafeArea
    }
    
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String,
                                              at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let layoutAttributes = super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath) else {
            return nil
        }
        
        guard let cv = collectionView else {
            return layoutAttributes
        }
        let availableWidth = cv.bounds.width
        let height: CGFloat = 189
        layoutAttributes.bounds.size = CGSize(width: availableWidth, height: height)
        
        
        return layoutAttributes
    }
    
    override func shouldInvalidateLayout(forPreferredLayoutAttributes preferredAttributes: UICollectionViewLayoutAttributes, withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes) -> Bool {
        super.shouldInvalidateLayout(forPreferredLayoutAttributes: preferredAttributes, withOriginalAttributes: originalAttributes)
        return preferredAttributes.frame.size != originalAttributes.frame.size
    }
}
