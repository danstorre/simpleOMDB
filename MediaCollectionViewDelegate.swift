//
//  MediaCollectionViewDelegate.swift
//  OMDb
//
//  Created by Daniel Torres on 5/5/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

class MediaCollectionViewDelegate: NSObject, UICollectionViewDelegate {
    
    weak var nav: UINavigationController?
    var selectedIndexPath: IndexPath
    
    init(with nav: UINavigationController?) {
        self.nav = nav
        selectedIndexPath = IndexPath(row: 0, section: 0)
        super.init()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        selectedIndexPath = indexPath
        nav?.performSegue(withIdentifier: "detail", sender: nil)
    }
    
}