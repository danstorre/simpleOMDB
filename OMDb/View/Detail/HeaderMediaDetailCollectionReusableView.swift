//
//  HeaderMediaDetailCollectionReusableView.swift
//  OMDb
//
//  Created by Daniel Torres on 5/12/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

protocol MediaHeaderReusableView: UICollectionReusableView, ViewNibProtocol {
    var headerMedia: MediaDetailProtocol {get set}
}

class HeaderMediaDetailCollectionReusableView: UICollectionReusableView, MediaHeaderReusableView {
    
    @IBOutlet var headerMediaOutlet: MediaDetail!
    @IBOutlet var contentView: UIView!
    
    var headerMedia: MediaDetailProtocol {
        get{
            return headerMediaOutlet
        }
        set{}
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("HeaderMediaDetailCollectionReusableView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
}
