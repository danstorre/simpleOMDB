//
//  SearchHeaderCollectionReusableView.swift
//  OMDb
//
//  Created by Daniel Torres on 5/6/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

protocol SearchHeaderCollectionReusableViewProtocol {
    var titleLabel: UILabel! {get set}
    var button: UIButton! {get set}
}

protocol SearchHeaderCollectionReusableViewProtocolDelegate {
    func buttonAllSelected()
}

class SearchHeaderCollectionReusableView: UICollectionReusableView, SearchHeaderCollectionReusableViewProtocol {
        
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var button: UIButton!
    @IBOutlet var contentViewCell: UIView!
    
    var delegate: SearchHeaderCollectionReusableViewProtocolDelegate?
    
    @IBAction
    func buttonAllSelectedPressed(){
        delegate?.buttonAllSelected()
    }
    
    
}
