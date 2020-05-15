//
//  PresenterMediaCollection.swift
//  OMDb
//
//  Created by Daniel Torres on 5/6/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

class PresenterMediaCollection: NSObject, HasNavigation {
    private var delegate: MediaCollectionViewDelegate?
    private var datasource: MediaCollectionDataSourceProtocol?
    private var layout: UICollectionViewFlowLayout = PostersCarouselFlowLayout()
    weak var navigationObject: NavigationProtocol?
    weak var collectionView: UICollectionView?
    
    var mediaArray: [Media]?
    
    private let cellIdentifier = "MediaPosterCollectionViewCell"
    
    init(collectionView: UICollectionView, mediaArray: [Media]? = nil, navigationObject: NavigationProtocol?){
        self.collectionView = collectionView
        self.datasource = nil
        self.delegate = nil
        self.mediaArray = mediaArray
        self.navigationObject = navigationObject
        super.init()
        setUp()
    }
    
    func setUp(){
        collectionView?.collectionViewLayout = layout
        collectionView?.register(MediaPosterCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        datasource = MediaCollectionDataSource(withArray: mediaArray,
                                               withCellIdentifier: cellIdentifier)
        collectionView?.dataSource = datasource
        delegate = MediaCollectionViewDelegate(with: navigationObject, and: mediaArray)
        collectionView?.delegate = delegate
    }
}
