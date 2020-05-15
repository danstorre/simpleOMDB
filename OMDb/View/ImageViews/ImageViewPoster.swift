//
//  ImageViewPoster.swift
//  OMDb
//
//  Created by Daniel Torres on 5/11/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

class ImageViewPoster: UIView, ImageViewPosterProtocol {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var markViewImage: UIView!
    @IBOutlet var posterImage: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit(){
        Bundle.main.loadNibNamed("ImageViewPoster", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        posterImage.contentMode = .scaleAspectFill
        posterImage.layer.cornerRadius = 14
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            finished = false
        }
    }
    
    var finished = false
    
    func addShadows(){
        guard !finished else {
            return
        }
        
        markViewImage.layer.frame = markViewImage.frame
        markViewImage.layer.shadowColor = UIColor(named: "ShadowColor")!.cgColor
        markViewImage.layer.shadowRadius = 4
        markViewImage.layer.shadowOpacity = 1
        markViewImage.layer.shadowOffset = CGSize(width: 3, height: 4)
        markViewImage.layer.cornerRadius = 14
        
        let shadowPath = UIBezierPath(roundedRect: markViewImage.bounds, cornerRadius: 14).cgPath
        
        markViewImage.layer.shadowPath = shadowPath
        
        finished = true
    }
    func hideAnimation() {
        UIView.animate(withDuration: 0.3) {
            self.contentView.alpha = 0
        }
    }
    
    func showAnimation() {
        UIView.animate(withDuration: 0.6) {
            self.contentView.alpha = 1
        }
    }
}
