//
//  PresenterDetailMedia.swift
//  OMDb
//
//  Created by Daniel Torres on 5/13/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

protocol PresenterDetailMediaProtocol: PresenterCollectionProtocol{
    var mediaDetails: MediaDetailsProtocol {get set}
}

class PresenterDetailMedia: NSObject, PresenterCollectionProtocol {
    private var datasource: UICollectionViewDataSource?
    private var delegate: UICollectionViewDelegate?
    var layout: UICollectionViewFlowLayout = MediaSearchCollectionFlowLayout()
    
    weak var collectionView: UICollectionView?
    
    private let cellIdentifier = "MediaAttributeCollectionViewCell"
    private let reusableIdentifier = "HeaderMediaDetailCollectionReusableView"
    
    var media: MediaDetailsProtocol
    
    init(collectionView: UICollectionView, media: MediaDetailsProtocol){
        self.collectionView = collectionView
        self.media = media
        super.init()
        setUp()
    }
    
    func setUp(){
        collectionView?.register(MediaAttributeCollectionViewCell.self,
                                 forCellWithReuseIdentifier: cellIdentifier)
        collectionView?.register(HeaderMediaDetailCollectionReusableView.self,
                                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                 withReuseIdentifier: reusableIdentifier)
        datasource = PresenterDetailMediaCollectionViewDataSource(media: media)
        collectionView?.dataSource = datasource
        collectionView?.collectionViewLayout = layout
    }
}


class PresenterDetailMediaCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    var media: MediaDetailsProtocol
    init(media: MediaDetailsProtocol) {
        self.media = media
        super.init()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    
}
