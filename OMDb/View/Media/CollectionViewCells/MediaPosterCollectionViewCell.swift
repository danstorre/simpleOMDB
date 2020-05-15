//
//  MediaPosterCollectionViewCell.swift
//  OMDb
//
//  Created by Daniel Torres on 5/5/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

class MediaPosterCollectionViewCell: UICollectionViewCell, MediaCollectionViewCellPresentableProtocol {
    var titleLabel: UILabel! {
        return UILabel()
    }
    
    var yearLabel: UILabel! {
        return UILabel()
    }
    
    var typeLabel: UILabel! {
        return UILabel()
    }
    
    var posterImage: UIImageView! {
        return imageViewPoster.posterImage
    }
    
    @IBOutlet var cellContentView: UIView!
    @IBOutlet var imageViewPoster: ImageViewPoster!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit(){
        Bundle.main.loadNibNamed("MediaPosterCollectionViewCell", owner: self, options: nil)
        addSubview(cellContentView)
        cellContentView.frame = self.bounds
        cellContentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageViewPoster.commonInit()
    }
    
    func addShadows(){
        imageViewPoster.addShadows()
    }
    
    func hideAnimation() {
        imageViewPoster.hideAnimation()
    }
    
    func showAnimation() {
        imageViewPoster.showAnimation()
    }
}
