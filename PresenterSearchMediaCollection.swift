//
//  PresenterSearchMediaCollection.swift
//  OMDb
//
//  Created by Daniel Torres on 5/6/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

class PresenterSearchMediaCollection: NSObject, PresenterSearchMediaCollectionProtocol {
    private var datasource: SearchMediaCollectionViewDataSourceProtocol?
    private var delegate: UICollectionViewDelegate?
    var layout: UICollectionViewFlowLayout = MediaSearchCollectionFlowLayout()
    
    weak var collectionView: UICollectionView?
    weak var navigationObject: NavigationProtocol?
    
    private let cellIdentifier = "SearchCollectionViewCell"
    private let reusableIdentifier = "HeaderSearchCollectionView"
    
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
    
    init(collectionView: UICollectionView, mediaArray: [Media]? = nil, navigationObject: NavigationProtocol?){
        self.collectionView = collectionView
        self.datasource = nil
        self.mediaArray = mediaArray
        self.navigationObject = navigationObject
        super.init()
        setUp()
    }
    
    func setUp(){
        collectionView?.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView?.register(SearchHeaderCollectionReusableView.self,
                                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                 withReuseIdentifier: reusableIdentifier)
        datasource = MediaSearchCollectionViewDataSource(withArray: mediaArray,
                                                         withCellIdentifier: cellIdentifier,
                                                         withReusableViewIdentifier: reusableIdentifier,
                                                         navigationObject: navigationObject)
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
