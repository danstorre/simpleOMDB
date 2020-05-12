//
//  SearchHeaderCollectionReusableView.swift
//  OMDb
//
//  Created by Daniel Torres on 5/6/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

protocol SearchHeaderCollectionReusableViewProtocol: UICollectionReusableView {
    var titleLabel: UILabel! {get set}
    var button: UIButton! {get set}
}

protocol SearchHeaderCollectionReusableViewProtocolDelegate {
    func buttonAllSelected(sender: AnyObject)
}

class SearchHeaderCollectionReusableView: UICollectionReusableView, SearchHeaderCollectionReusableViewProtocol {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var button: UIButton!
    @IBOutlet var contentViewCell: UIView!
    
    var delegate: SearchHeaderCollectionReusableViewProtocolDelegate?
    
    @IBAction
    func buttonAllSelectedPressed(){
        delegate?.buttonAllSelected(sender: self)
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
        Bundle.main.loadNibNamed("SearchHeaderCollectionReusableView", owner: self, options: nil)
        addSubview(contentViewCell)
        contentViewCell.frame = self.bounds
        contentViewCell.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
}
