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
    var vc: UIViewController {
        
        return UIViewController()
    }
}

struct DetailMediaViewControllerPresenter: NavigationPresenterProtocol {
    var media: Media
    var vc: UIViewController {
        return UIViewController()
    }
}


enum NavigationOptions {
    case list(media: [Media])
    case detail(media: Media)
}

enum ViewControllerFactory{
    
    static func vc(for option: NavigationOptions) -> UIViewController {
        switch option {
        case .list(let mediaArray):  return ListMediaViewControllerPresenter(mediaArray: mediaArray).vc
        case .detail(let media): return DetailMediaViewControllerPresenter(media: media).vc
        }
        
    }
}
