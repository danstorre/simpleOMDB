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
    func hideAnimation()
    func showAnimation()
}

extension AnimatableAlpha where Self: UIView {
    func hideAnimation() {
        UIView.animate(withDuration: 0.3) {
            self.alpha = 0
        }
    }
    
    func showAnimation() {
        UIView.animate(withDuration: 0.6) {
            self.alpha = 1
        }
    }
}

protocol ShadowsAdable: class {
    func addShadows()
}

extension UIImageView: AnimatableAlpha {}
