//
//  MediaCellProtocols.swift
//  OMDb
//
//  Created by Daniel Torres on 5/11/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

protocol MediaViewViewProtocol: UIView {
    var titleLabel: UILabel! { get }
    var yearLabel: UILabel! { get }
    var typeLabel: UILabel! { get }
    var posterImage: UIImageView! { get }
}

protocol MediaViewViewCellProtocol: ViewCollectionViewCellNibProtocol, MediaViewViewProtocol {
}

protocol MediaCollectionViewCellPresentableProtocol: MediaViewViewCellProtocol, ShadowsAndToggleableAlphaProtocol {
}

protocol ImageViewPosterProtocol: ViewNibProtocol, ShadowsAndToggleableAlphaProtocol {
    var posterImage: UIImageView! {get set}
}
