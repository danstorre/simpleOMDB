//
//  TextFactoryTextBox.swift
//  OMDb
//
//  Created by Daniel Torres on 4/27/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

protocol TextBoxPresenter {
    var textBox: FeatureTextBoxProtocol {get}
}

struct FeatureTextBoxPresenter: TextBoxPresenter {
    let title: String
    let titleColor: UIColor
    let description: String
    let image: UIImage
    let iconColor: UIColor
    
    var textBox: FeatureTextBoxProtocol {
        let titleAttributed = TextFactory.attributedText(for: .header2(string: title, withColor: titleColor))
        let descriptionAttributed = TextFactory.attributedText(for: .body(string: description))
        let featureBoxView = FeatureTextBox(frame: .zero)
        
        
        let config = UIImage.SymbolConfiguration(pointSize: UIFont.systemFontSize, weight: .bold, scale: .large)
        featureBoxView.iconImageView.image = image
        featureBoxView.iconImageView.preferredSymbolConfiguration = config
        featureBoxView.iconImageView.tintColor = iconColor
        featureBoxView.titleLabel.attributedText = titleAttributed
        featureBoxView.descriptionLabel.attributedText = descriptionAttributed
        return featureBoxView
    }
}

enum TextFactoryTextBoxOptions {
    case featureTextBox(title: String, titleColor: UIColor, description: String, image: UIImage, iconColor: UIColor)
}

enum TextFactoryTextBox {
    
    static func textBox(for option: TextFactoryTextBoxOptions) -> FeatureTextBoxProtocol {
        switch option {
        case .featureTextBox(let title, let titleColor, let description, let image, let iconColor):
            return FeatureTextBoxPresenter(title: title,
                                           titleColor: titleColor,
                                           description: description,
                                           image: image,
                                           iconColor: iconColor).textBox
        }
    }
}

