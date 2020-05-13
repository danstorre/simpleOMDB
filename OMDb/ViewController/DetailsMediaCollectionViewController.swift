//
//  DetailsMediaCollectionViewController.swift
//  OMDb
//
//  Created by Daniel Torres on 5/12/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

protocol DetailsCollectionScreen: AnyObject {
    var collectionView: UICollectionView! {get set}
    var presenter: PresenterCollectionProtocol? {get set}
}

class DetailsMediaCollectionViewController: UIViewController, DetailsCollectionScreen {
    @IBOutlet var collectionView: UICollectionView!
    var presenter: PresenterCollectionProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.collectionView = collectionView
        presenter?.setUp()
    }

}
