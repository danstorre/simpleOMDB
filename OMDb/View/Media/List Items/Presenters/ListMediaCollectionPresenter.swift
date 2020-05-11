//
//  ListMediaCollectionPresenter.swift
//  OMDb
//
//  Created by Daniel Torres on 5/11/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

class ListMediaCollectionPresenter: NSObject, PresenterMediaCollectionProtocol {
    var navigationObject: NavigationProtocol?
    var mediaArray: [Media]?
    weak var collectionView: UICollectionView?
    var layout: UICollectionViewFlowLayout
    
    private let cellIdentifier = "ListItemMediaViewCollectionViewCell"
    private var datasource: ListMediaMediaCollectionDataSourceProtocol?
    private var delegate: UICollectionViewDelegate?
    
    init(collectionView: UICollectionView,
         collectionViewFlowLayout: UICollectionViewFlowLayout,
         navigationObject: NavigationProtocol?,
         mediaArray: [Media]?) {
        self.collectionView = collectionView
        self.navigationObject = navigationObject
        self.layout = collectionViewFlowLayout
        self.mediaArray = mediaArray
        super.init()
    }
    
    func setUp(){
        collectionView?.register(ListItemMediaViewCollectionViewCell.self,
                                 forCellWithReuseIdentifier: cellIdentifier)
        datasource = ListMediaMediaCollectionDataSource(withArray: mediaArray,
                                                        withCellIdentifier: cellIdentifier,
                                                        navigationObject: navigationObject)
//        delegate = MediaSearchCollectionViewDelegate()
        collectionView?.dataSource = datasource
        collectionView?.delegate = delegate
        collectionView?.collectionViewLayout = layout
    }
    
}
