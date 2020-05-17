//
//  ListImeMediaViewCollectionViewCell.swift
//  OMDb
//
//  Created by Daniel Torres on 5/11/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

protocol ListItemMediaViewProtocol: UIView {
    var titleMedia: UILabel! {get set}
    var authorMedia: UILabel! {get set}
    var descriptionMedia: UILabel! {get set}
    var yearReleasedMedia: UILabel! {get set}
    var imageViewMedia: ImageViewPosterProtocol! {get set}
}

protocol ListItemMediaViewProtocolCollectionViewCellProtocol: UICollectionViewCell,
                                                              ShadowsAndToggleableAlphaProtocol,
                                                              ListItemMediaViewProtocol {
}

class ListItemMediaViewCollectionViewCell: UICollectionViewCell, ListItemMediaViewProtocolCollectionViewCellProtocol {
    
    @IBOutlet var cellContentView: UIView!
    @IBOutlet var titleMedia: UILabel!
    @IBOutlet var authorMedia: UILabel!
    @IBOutlet var descriptionMedia: UILabel!
    @IBOutlet var yearReleasedMedia: UILabel!
    @IBOutlet var imageViewMediaOutlet: ImageViewPoster!
    @IBOutlet var accessoryImageView: UIImageView!
    
    var imageViewMedia: ImageViewPosterProtocol! {
        get {
            return imageViewMediaOutlet
        }
        set {
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit(){
        Bundle.main.loadNibNamed("ListItemMediaViewCollectionViewCell", owner: self, options: nil)
        addSubview(cellContentView)
        cellContentView.frame = self.bounds
        cellContentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageViewMedia.commonInit()
        imageViewMedia.showAnimation(){ _ in }
    }
    
    func addShadows() {
        imageViewMediaOutlet.addShadows()
    }

}

