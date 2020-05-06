//
//  PresenterMediaCollection.swift
//  OMDb
//
//  Created by Daniel Torres on 5/6/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

class PresenterMediaCollection: NSObject {
    
    private var delegate: MediaCollectionViewDelegate?
    private var datasource: MediaCollectionDataSourceProtocol?
    private var layout: UICollectionViewFlowLayout = PostersCarouselFlowLayout()
    weak var navigationController: UINavigationController?
    weak var collectionView: UICollectionView?
    
    var mediaArray: [Media]? {
        didSet {
            datasource?.mediaArray = mediaArray
        }
    }
    
    private let cellIdentifier = "MediaPosterCollectionViewCell"
    
    init(collectionView: UICollectionView, mediaArray: [Media]? = nil, navigationController: UINavigationController){
        self.collectionView = collectionView
        self.datasource = nil
        self.delegate = nil
        self.mediaArray = mediaArray
        self.navigationController = navigationController
        super.init()
        setUp()
    }
    
    func setUp(){
        collectionView?.collectionViewLayout = layout
        collectionView?.register(MediaPosterCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        datasource = MediaCollectionDataSource(withArray: mediaArray,
                                               withCellIdentifier: cellIdentifier)
        collectionView?.dataSource = datasource
        delegate = MediaCollectionViewDelegate(with: navigationController)
        collectionView?.delegate = delegate
    }
}
