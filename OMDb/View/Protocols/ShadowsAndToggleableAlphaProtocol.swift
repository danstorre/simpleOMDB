//
//  shadowsAndAlpha.swift
//  OMDb
//
//  Created by Daniel Torres on 5/6/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

protocol ViewNibProtocol: UIView {
    var contentView: UIView! {get set}
    func commonInit()
}

protocol ViewCollectionViewCellNibProtocol: UICollectionViewCell {
    var cellContentView: UIView! {get set}
    func commonInit()
}

protocol ShadowsAndToggleableAlphaProtocol: ShadowsAdable, AnimatableAlpha {
}

protocol AnimatableAlpha: class {
    func hideAnimation(completionHandler: @escaping (Bool) -> Void)
    func showAnimation(completionHandler: @escaping (Bool) -> Void)
}

extension AnimatableAlpha where Self: UIView {
    func hideAnimation(completionHandler: @escaping ((Bool) -> Void)) {
        UIView.animate(withDuration: 0.3,
                       animations: {
            self.alpha = 0
        }) { (terminated) in
            completionHandler(terminated)
        }
    }
    
    func showAnimation(completionHandler: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: 0.6,
                       animations: {
            self.alpha = 1
        }) { (terminated) in
            completionHandler(terminated)
        }
    }
}

protocol ShadowsAdable: class {
    func addShadows()
}

extension UIImageView: AnimatableAlpha {}
