//
//  ProfileHeader.swift
//  OMDb
//
//  Created by Daniel Torres on 5/4/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

protocol ProfileHeaderProtocol: UIView{
    var titleLabel: UILabel { get }
    var descriptionLabel: UILabel { get }
    var profileImageView: UIImageView { get }
}

class ProfileHeader: UIView, ProfileHeaderProtocol {

    @IBOutlet var titleLabelFromProfile: UILabel!
    @IBOutlet var descriptionLabelFromProfile: UILabel!
    @IBOutlet var profileImageViewFromProfile: UIImageView!
    @IBOutlet var contentView: UIView!
    
    var titleLabel: UILabel {
        return titleLabelFromProfile
    }
    var descriptionLabel: UILabel {
        return descriptionLabelFromProfile
    }
    var profileImageView: UIImageView {
        return profileImageViewFromProfile
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
        Bundle.main.loadNibNamed("ProfileHeader", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

}
