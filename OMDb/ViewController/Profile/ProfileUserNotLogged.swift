//
//  ProfileUserNotLogged.swift
//  OMDb
//
//  Created by Daniel Torres on 4/28/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

protocol ProfileNotLoggedProtocol{
    var headLabel: UILabel {get}
    var featuresView: UIStackView {get}
    var loginButtons: UIStackView {get}
    var descriptionLabel: UILabel {get}
}

class ProfileUserNotLogged: UIView, ProfileNotLoggedProtocol{

    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var featureStackView: UIStackView!
    @IBOutlet var loginButtonsStackView: UIStackView!
    @IBOutlet var captionLabel: UILabel!
    
    @IBOutlet var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("ProfileUserNotLogged", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    var headLabel: UILabel {
        return headerLabel
    }
    var featuresView: UIStackView {
        return featureStackView
    }
    var loginButtons: UIStackView {
        return loginButtonsStackView
    }
    var descriptionLabel: UILabel {
        return captionLabel
    }
}
