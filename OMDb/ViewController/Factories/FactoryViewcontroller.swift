//
//  NavigationFactories.swift
//  OMDb
//
//  Created by Daniel Torres on 5/9/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

protocol NavigationPresenterProtocol {
    var vc: UIViewController {get}
}

struct ListMediaViewControllerPresenter: NavigationPresenterProtocol {
    var mediaArray: [Media]
    var navigationObject: NavigationProtocol
    var vc: UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let listVc = storyboard.instantiateViewController(withIdentifier: "ListMediaCollectionViewController") as? ListMediaCollectionViewController {
            listVc.presenter = ListMediaCollectionPresenter(collectionViewFlowLayout: ListCollectionViewLayout(),
                                                            navigationObject: navigationObject,
                                                            api: OMBDB_API(session: SessionsCoordinator.cacheSession),
                                                            mediaArray: mediaArray)
            if let first = mediaArray.first, let type = first.type {
                listVc.title = type.description
            }
            
            return listVc
        }
        return UIViewController()
    }
}

struct DetailMediaViewControllerPresenter: NavigationPresenterProtocol {
    var media: Media
    var vc: UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailVc = storyboard.instantiateViewController(withIdentifier: "DetailMediaViewController") as? DetailMediaViewController {
            detailVc.media = media
            detailVc.api = OMBDB_API()
            return detailVc
        }
        return UIViewController()
    }
}


enum NavigationOptions {
    case list(media: [Media], navigationObject: NavigationProtocol)
    case detail(media: Media)
}

enum ViewControllerFactory{
    
    static func vc(for option: NavigationOptions) -> UIViewController {
        switch option {
        case .list(let mediaArray, let navigationObject):
            return ListMediaViewControllerPresenter(mediaArray: mediaArray,
                                                    navigationObject: navigationObject).vc
        case .detail(let media): return DetailMediaViewControllerPresenter(media: media).vc
        }
        
    }
}
