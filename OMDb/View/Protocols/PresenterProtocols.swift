//
//  PresenterProtocols.swift
//  OMDb
//
//  Created by Daniel Torres on 5/11/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

protocol PresenterCollectionProtocol: AnyObject {
    var collectionView: UICollectionView? {get set}
    var layout: UICollectionViewFlowLayout {get set}
    //sets up everything about the collectionView, including delgate, datasource, and cell registration.
    func setUp()
}

protocol PresenterMediaCollectionProtocol: PresenterCollectionProtocol, HasNavigation{
    var navigationObject: NavigationProtocol? {get set}
    var mediaArray: [Media]? {get set}
}

protocol PresenterSearchMediaCollectionProtocol: PresenterMediaCollectionProtocol {
    var searchMode: FilterTypes {get set}
}
