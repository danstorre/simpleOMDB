//
//  FeatureTextBox.swift
//  OMDb
//
//  Created by Daniel Torres on 4/27/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

protocol FeatureTextBoxProtocol: UIView{
    var titleLabel: UILabel {get }
    var descriptionLabel: UILabel  {get }
    var iconImageView: UIImageView  {get }
}

class FeatureTextBox: UIView, FeatureTextBoxProtocol{
    
    @IBOutlet var titleLabe: UILabel!
    @IBOutlet var descriptionLabe: UILabel!
    @IBOutlet var iconImageVie: UIImageView!
    
    @IBOutlet var contentView: UIView!
    var titleLabel: UILabel {
        return titleLabe
    }
    
    var descriptionLabel: UILabel {
        return descriptionLabe
    }
    
    var iconImageView: UIImageView {
        return iconImageVie
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("FeatureTextBox", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}
