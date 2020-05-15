//
//  ColumnFlowLayout.swift
//  OMDb
//
//  Created by Daniel Torres on 4/4/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

enum ColumnType {
    case two, three
}

class ColumnFlowLayout: UICollectionViewFlowLayout {
    
    
    var layoutType: ColumnType = .two
    
    lazy var cellTest: UIView = MediaViewCollectionViewCell().cellContentView

    
    override func prepare() {
        super.prepare()
        
        guard let cv = collectionView else{
            return
        }
        
        let availableWidth = cv.bounds.insetBy(dx: cv.layoutMargins.left, dy: 0).width
        
        var maxColumns = 1
        switch layoutType {
        case .two:
            maxColumns = 2
        case .three:
            maxColumns = 3
        }
        let maxNumColumn = maxColumns
        let cellWidth = (availableWidth / CGFloat(maxNumColumn)).rounded(.down) - 2
        
        let desiredSize = cellTest
            .systemLayoutSizeFitting(CGSize(width: cellWidth, height: 50), withHorizontalFittingPriority: .fittingSizeLevel,
                                     verticalFittingPriority: .defaultLow)
        
        itemSize = CGSize(width: cellWidth, height: desiredSize.height)
        
        
        self.sectionInset = UIEdgeInsets(top: minimumInteritemSpacing,
                                         left: 0,
                                         bottom: 0,
                                         right: 0)
        
        self.sectionInsetReference = .fromSafeArea
        
    }
}
