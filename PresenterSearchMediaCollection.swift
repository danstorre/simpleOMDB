//
//  PresenterSearchMediaCollection.swift
//  OMDb
//
//  Created by Daniel Torres on 5/6/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

class PresenterSearchMediaCollection: NSObject {
    
    private var datasource: SearchMediaCollectionViewDataSourceProtocol?
    private var delegate: UICollectionViewDelegate?
    private var layout: UICollectionViewFlowLayout {
        return MediaSearchCollectionFlowLayout()
    }
    
    weak var collectionView: UICollectionView?
    weak var navigationController: UINavigationController?
    
    private let cellIdentifier = "SearchCollectionViewCell"
    
    var mediaArray: [Media]? {
        didSet {
            datasource?.mediaArray = mediaArray?.sanitize()
        }
    }
    
    var searchMode: FilterTypes = .all {
        didSet {
            datasource?.searchMode = searchMode
        }
    }
    
    init(collectionView: UICollectionView, mediaArray: [Media]? = nil, navigationController: UINavigationController?){
        self.collectionView = collectionView
        self.datasource = nil
        self.mediaArray = mediaArray
        self.navigationController = navigationController
        super.init()
        setUp()
    }
    
    func setUp(){
        collectionView?.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        datasource = MediaSearchCollectionViewDataSource(withArray: mediaArray,
                                                         withCellIdentifier: cellIdentifier,
                                                         navigationController: navigationController)
        delegate = MediaSearchCollectionViewDelegate()
        collectionView?.dataSource = datasource
        collectionView?.delegate = delegate
        collectionView?.collectionViewLayout = layout
    }
    
}


extension PresenterSearchMediaCollection: PropertyObserver{
    func didChange(propertyName: String, oldPropertyValue: Any?) {
    }
    
    func willChange(propertyName: String, newPropertyValue: Any?) {
        if propertyName == ContentMediaPresenterAPIObservable.ContentMediaPresenterAPIKeys.filtertTypeKey,
            let filterType = newPropertyValue as? FilterTypes {
            searchMode = filterType
        }
    }
}
