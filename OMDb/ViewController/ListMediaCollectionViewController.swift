//
//  ListMediaCollectionViewController.swift
//  OMDb
//
//  Created by Daniel Torres on 5/11/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

protocol ListMediaScreen: AnyObject {
    var collectionView: UICollectionView! {get set}
    var presenter: PresenterMediaCollectionProtocol? {get set}
}

class ListMediaCollectionViewController: UIViewController, ListMediaScreen {
    
    @IBOutlet var collectionView: UICollectionView!
    var presenter: PresenterMediaCollectionProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.setUp()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            collectionView.reloadData()
        }
    }
    
}
