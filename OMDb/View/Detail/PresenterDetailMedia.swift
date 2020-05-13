//
//  PresenterDetailMedia.swift
//  OMDb
//
//  Created by Daniel Torres on 5/13/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

protocol PresenterDetailMediaProtocol: PresenterCollectionProtocol{
    var mediaDetails: MediaDetailsProtocol? {get set}
}

class PresenterDetailMedia: NSObject, PresenterDetailMediaProtocol {
    private var datasource: UICollectionViewDataSource?
    private var delegate: UICollectionViewDelegate?
    var layout: UICollectionViewFlowLayout = DetailCollectionFlowLayout()
    
    weak var collectionView: UICollectionView?
    
    private let cellIdentifier = "MediaAttributeCollectionViewCell"
    private let reusableViewIdentifier = "HeaderMediaDetailCollectionReusableView"
    private let api: OMBDB_API_Contract
    
    var media: Media
    var mediaDetails: MediaDetailsProtocol?
    
    init(media: Media, api: OMBDB_API_Contract) {
        self.api = api
        self.media = media
        super.init()
    }
    
    func setUp() {
        collectionView?.register(MediaAttributeCollectionViewCell.self,
                                 forCellWithReuseIdentifier: cellIdentifier)
        collectionView?.register(HeaderMediaDetailCollectionReusableView.self,
                                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                 withReuseIdentifier: reusableViewIdentifier)
        collectionView?.collectionViewLayout = layout
        searchMediaDetails(media: media)
    }
    
    func searchMediaDetails(media: Media){
        api.getMedia(byTitle: media.name) { [weak self] (mediaDetails) in
            guard let self = self, let mediaDetails = mediaDetails else {return }
            DispatchQueue.main.async {
                self.datasource = PresenterDetailMediaCollectionViewDataSource(media: mediaDetails,
                                                                               cellIdentifier: self.cellIdentifier,
                                                                               reusableViewIdentifier: self.reusableViewIdentifier)
                self.collectionView?.dataSource = self.datasource
                self.collectionView?.reloadData()
            }
        }
    }
}

class PresenterDetailMediaCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    var media: MediaDetailsProtocol
    var cellIdentifier: String
    var reusableViewIdentifier: String
    init(media: MediaDetailsProtocol,  cellIdentifier: String, reusableViewIdentifier: String) {
        self.media = media
        self.cellIdentifier = cellIdentifier
        self.reusableViewIdentifier = reusableViewIdentifier
        super.init()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                                 withReuseIdentifier: reusableViewIdentifier,
                                                                                 for: indexPath)
            as? MediaHeaderReusableView else {
                return UICollectionReusableView()
        }
        
        
        
        return reusableView
    }
}
