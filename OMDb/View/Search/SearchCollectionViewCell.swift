//
//  SearchCollectionViewCell.swift
//  OMDb
//
//  Created by Daniel Torres on 5/6/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

protocol SearchCollectionViewCellProtocol: UICollectionViewCell {
    var mediaCollectionView: UICollectionView! { get }
}

class SearchCollectionViewCell: UICollectionViewCell, SearchCollectionViewCellProtocol {
    @IBOutlet var mediaCollectionView: UICollectionView!
    @IBOutlet var cellContentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("SearchCollectionViewCell", owner: self, options: nil)
        addSubview(cellContentView)
        cellContentView.frame = self.bounds
        cellContentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}
