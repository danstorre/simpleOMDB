//
//  UserLoggedView.swift
//  OMDb
//
//  Created by Daniel Torres on 5/4/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

protocol ProfileLoggedProtocol: UIView {
    var tableView: UITableView { get }
}

class ProfileLoggedView: UIView, ProfileLoggedProtocol {
    @IBOutlet var contentView: UITableView!
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
        Bundle.main.loadNibNamed("UserLoggedView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    var tableView: UITableView {
        return contentTableView
    }
}
