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
        contentView.addSubview(cellContentView)
        cellContentView.frame = contentView.bounds
        cellContentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        self.contentView.bounds = layoutAttributes.bounds
        self.contentView.setNeedsLayout()
        self.contentView.layoutIfNeeded()
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let layoutAttr = super.preferredLayoutAttributesFitting(layoutAttributes)
        var targeSize = layoutAttr.bounds.size
        targeSize.height = 0
        var prefferedSize = targeSize
        prefferedSize.height += self.contentView.systemLayoutSizeFitting(targeSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .defaultHigh).height
    
        layoutAttr.frame.size = prefferedSize
        return layoutAttr
    }
}
