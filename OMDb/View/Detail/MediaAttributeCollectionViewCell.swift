//
//  MediaAttributeCollectionViewCell.swift
//  OMDb
//
//  Created by Daniel Torres on 5/12/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

protocol  MediaAttributeCollectionViewCellProtocol: ViewCollectionViewCellNibProtocol  {
    var titleAttribute: UILabel! {get set}
    var valueAtribute: UILabel! {get set}
}

class MediaAttributeCollectionViewCell: UICollectionViewCell, MediaAttributeCollectionViewCellProtocol {
    @IBOutlet var titleAttribute: UILabel!
    @IBOutlet var valueAtribute: UILabel!
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
        Bundle.main.loadNibNamed("MediaAttributeCollectionViewCell", owner: self, options: nil)
        addSubview(cellContentView)
        cellContentView.frame = bounds
        cellContentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}
