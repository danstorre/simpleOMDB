//
//  FactoryButton.swift
//  OMDb
//
//  Created by Daniel Torres on 4/27/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

protocol ButtonPresenterProtocol {
    var button: NormalButtonProtocol {get}
}

struct NormalButtonPresenter: ButtonPresenterProtocol {
    let title: String
    
    var button: NormalButtonProtocol {
        let normalButton = NormalButton(frame: .zero)
        
        normalButton.button.setAttributedTitle(TextFactory.attributedText(for: .body(string: title,
                                                                                     withColor: .white)),
                                               for: .normal)
        normalButton.button.backgroundColor = UIColor(named: "ButtonColor")
        
        normalButton.button.contentEdgeInsets = UIEdgeInsets(top: 4, left: 26, bottom: 4, right: 26)
        normalButton.button.layer.cornerRadius = 10
        
        return normalButton
    }
}

enum ButtonFactoryOptions {
    case normalButton(text: String, color: UIColor? = nil)
}

enum ButtonFactory {
    
    static func button(for option: ButtonFactoryOptions) -> NormalButtonProtocol {
        switch option {
        case .normalButton(let title, _):
            return NormalButtonPresenter(title: title).button
        }
    }
}
