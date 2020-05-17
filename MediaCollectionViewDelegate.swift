//
//  MediaCollectionViewDelegate.swift
//  OMDb
//
//  Created by Daniel Torres on 5/5/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

protocol MediaCollectionViewDelegateProtocol: UICollectionViewDelegate {
    var mediaArray: [Media]? {get set}
}

protocol MediaCollectionViewDelegateProtocolNavigatable: MediaCollectionViewDelegateProtocol, HasNavigation {}

final class MediaCollectionViewDelegate: NSObject, MediaCollectionViewDelegateProtocolNavigatable {
    
    weak var navigationObject: NavigationProtocol?
    var mediaArray: [Media]?
    
    init(with navigationObject: NavigationProtocol?, and mediaArray: [Media]?) {
        self.navigationObject = navigationObject
        self.mediaArray = mediaArray
        super.init()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if let mediaArray = mediaArray {
            navigationObject?.goTo(navigationOption: .detail(media: mediaArray[indexPath.row]), presentModally: false)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? ShadowsAndToggleableAlphaProtocol else { return }
        cell.addShadows()
        cell.showAnimation(){ _ in }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? MediaViewViewCellProtocol else { return }
        cell.contentView.alpha = 0
    }
    
}
