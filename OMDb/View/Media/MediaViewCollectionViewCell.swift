//
//  MediaCollectionViewCell.swift
//  OMDb
//
//  Created by Daniel Torres on 4/4/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

protocol MediaViewViewProtocol: UIView {
    var titleLabel: UILabel! { get }
    var yearLabel: UILabel! { get }
    var typeLabel: UILabel! { get }
    var posterImage: UIImageView! { get }
}

protocol MediaViewViewCellProtocol: UICollectionViewCell, MediaViewViewProtocol {
}

class MediaViewCollectionViewCell: UICollectionViewCell, MediaViewViewCellProtocol {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var yearLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var posterImage: UIImageView!
    
    @IBOutlet var cellContentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit(){
        Bundle.main.loadNibNamed("MediaViewCollectionViewCell", owner: self, options: nil)
        addSubview(cellContentView)
        cellContentView.frame = self.bounds
        cellContentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}
