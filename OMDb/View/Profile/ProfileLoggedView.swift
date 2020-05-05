//
//  UserLoggedView.swift
//  OMDb
//
//  Created by Daniel Torres on 5/4/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

protocol ProfileLoggedViewProtocol: UIView {
    var tableView: UITableView { get }
}

class ProfileLoggedView: UIView, ProfileLoggedViewProtocol {
    @IBOutlet var contentView: UIView!
    @IBOutlet var contentTableView: UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("ProfileLoggedView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    var tableView: UITableView {
        return contentTableView
    }
}
