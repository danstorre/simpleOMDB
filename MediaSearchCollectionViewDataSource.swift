//
//  MediaSearchCollectionViewDataSource.swift
//  OMDb
//
//  Created by Daniel Torres on 5/6/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

protocol SearchMediaCollectionViewDataSourceProtocol: MediaCollectionDataSourceProtocol{
    var searchMode: FilterTypes {get set}
}

class MediaSearchCollectionViewDataSource: NSObject, SearchMediaCollectionViewDataSourceProtocol, Navigationable {
    weak var navigationController: UINavigationController?
    var mediaArray: [Media]?
    var searchMode: FilterTypes = .all
    private let cellIdentifier: String
    
    init(withArray medias: [Media]?, withCellIdentifier cellIdentifier: String, navigationController: UINavigationController?) {
        self.cellIdentifier = cellIdentifier
        self.navigationController = navigationController
        super.init()
        mediaArray = medias
    }
    
    private func returnNumberOfSectionsFrom(searchMode: FilterTypes) -> Int {
        var numberToReturn = 0
        switch searchMode {
        case .movies, .episodes, .series:
            numberToReturn = 1
        case .all:
            numberToReturn = 3
        }
        return numberToReturn
    }
    
    private func returnMediaFor(searchMode: FilterTypes, in mediaArray: [Media]) ->  [Media] {
        switch searchMode {
        case .movies:
            return mediaArray.filter { (media) -> Bool in
                return media.type! == .movie
            }
        case .episodes:
            return mediaArray.filter { (media) -> Bool in
                return media.type! == .episode
            }
        case .series:
            return mediaArray.filter { (media) -> Bool in
                return media.type! == .series
            }
        case .all:
            return mediaArray
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return returnNumberOfSectionsFrom(searchMode: searchMode)
    }
    var presenters: [IndexPath: PresenterMediaCollection] = [IndexPath: PresenterMediaCollection]()
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier,
                                                      for: indexPath) as! SearchCollectionViewCellProtocol
        
        guard let mediaArray = mediaArray else {
            return cell
        }
        var mediaArrayToBeUsed: [Media] = [Media]()
        
        func setCollectionView(){
            if let navigationController = navigationController {
                let presenter = PresenterMediaCollection(collectionView: cell.mediaCollectionView,
                                                         mediaArray: mediaArrayToBeUsed,
                                                         navigationController: navigationController)
                presenters[indexPath] = presenter
                presenter.setUp()
            }
        }
        
        if searchMode != .all  {
            mediaArrayToBeUsed = returnMediaFor(searchMode: searchMode, in: mediaArray)
            setCollectionView()
            return cell
        }
        
        if let filterForSection = FilterTypes(rawValue: indexPath.section + 1) {
            mediaArrayToBeUsed = returnMediaFor(searchMode: filterForSection, in: mediaArray)
        }
        setCollectionView()
        return cell
    }
}
