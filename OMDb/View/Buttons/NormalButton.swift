//
//  NormalButton.swift
//  OMDb
//
//  Created by Daniel Torres on 4/27/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

protocol NormalButtonProtocol: UIView {
    var button: UIButton {get}
}

class NormalButton: UIView, NormalButtonProtocol {
    
    @IBOutlet var buttonControl: UIButton!
    @IBOutlet var contentView: UIView!
    
    var button: UIButton {
        return buttonControl
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("NormalButton", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
}
