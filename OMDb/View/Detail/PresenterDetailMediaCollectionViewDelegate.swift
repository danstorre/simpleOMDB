//
//  PresenterDetailMediaCollectionViewDelegate.swift
//  OMDb
//
//  Created by Daniel Torres on 5/13/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

class PresenterDetailMediaCollectionViewDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var cellIdentifier: String
    var reusableViewIdentifier: String
    
    init(cellIdentifier: String, reusableViewIdentifier: String) {
        self.cellIdentifier = cellIdentifier
        self.reusableViewIdentifier = reusableViewIdentifier
        super.init()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width: CGFloat = collectionView.bounds.size.width
        let height: CGFloat = 210
        
        return CGSize(width: width, height: height)
    }
}
