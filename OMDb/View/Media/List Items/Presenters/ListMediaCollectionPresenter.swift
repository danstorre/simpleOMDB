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
    var api: OMBDB_API_Contract
    
    private let cellIdentifier = "ListItemMediaViewCollectionViewCell"
    private var datasource: ListMediaMediaCollectionDataSourceProtocol?
    private var delegate: MediaCollectionViewDelegateProtocolNavigatable?
    
    init(collectionView: UICollectionView,
         collectionViewFlowLayout: UICollectionViewFlowLayout,
         navigationObject: NavigationProtocol?,
         api: OMBDB_API_Contract,
         mediaArray: [Media]?) {
        self.collectionView = collectionView
        self.navigationObject = navigationObject
        self.layout = collectionViewFlowLayout
        self.mediaArray = mediaArray
        self.api = api
        super.init()
    }
    
    func setUp(){
        collectionView?.register(ListItemMediaViewCollectionViewCell.self,
                                 forCellWithReuseIdentifier: cellIdentifier)
        datasource = ListMediaMediaCollectionDataSource(withArray: mediaArray,
                                                        withCellIdentifier: cellIdentifier,
                                                        mediaListCellPresenter: MediaDetailsPresenter(api: api),
                                                        navigationObject: navigationObject)
        delegate = MediaCollectionViewDelegate(with: navigationObject, and: mediaArray)
        collectionView?.dataSource = datasource
        collectionView?.delegate = delegate
        collectionView?.collectionViewLayout = layout
    }
    
}
