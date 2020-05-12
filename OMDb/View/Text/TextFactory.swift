//
//  TextFactory.swift
//  OMDb
//
//  Created by Daniel Torres on 4/27/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

protocol TextPresenter {
    var attributedText: NSAttributedString {get}
}

struct HeaderTextPresenter: TextPresenter {
    
    let string: String
    
    var attributedText: NSAttributedString {
        
        let mutuableAttString = NSMutableAttributedString(string: string)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.86
        
        let attributes = [NSAttributedString.Key.kern: 0.41,
                        NSAttributedString.Key.paragraphStyle: paragraphStyle,
                        NSAttributedString.Key.foregroundColor: UIColor.init(named: "Text")!,
                        NSAttributedString.Key.font: UIFont(name: "DINAlternate-Bold", size: 48)!] as [NSAttributedString.Key : Any]

        // Line height: 48 pt
        mutuableAttString.addAttributes(attributes, range: NSRange(location: 0,
                                                                   length: string.count))
        return mutuableAttString
    }
}


struct Header2TextPresenter: TextPresenter {
    
    let string: String
    
    var attributedText: NSAttributedString {
        
        let mutuableAttString = NSMutableAttributedString(string: string)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.07
        
        let attributes = [NSAttributedString.Key.kern: 0.38,
                        NSAttributedString.Key.paragraphStyle: paragraphStyle,
                        NSAttributedString.Key.foregroundColor: UIColor.init(named: "Text")!,
                        NSAttributedString.Key.font: UIFont(name: "DINAlternate-Bold", size: 20)!] as [NSAttributedString.Key : Any]
        
        mutuableAttString.addAttributes(attributes, range: NSRange(location: 0,
                                                                   length: string.count))
        return mutuableAttString
    }
}

struct Body3TextPresenter: TextPresenter {
    
    let string: String
    
    var attributedText: NSAttributedString {
        let mutuableAttString = NSMutableAttributedString(string: string)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1
        
        let attributes = [NSAttributedString.Key.kern: -0.41,
                        NSAttributedString.Key.paragraphStyle: paragraphStyle,
                        NSAttributedString.Key.foregroundColor: UIColor.init(named: "Text")!,
                        NSAttributedString.Key.font: UIFont(name: "DINAlternate-Bold", size: 15)!] as [NSAttributedString.Key : Any]

        mutuableAttString.addAttributes(attributes, range: NSRange(location: 0,
                                                                   length: string.count))
        return mutuableAttString
    }
}

struct Body2TextPresenter: TextPresenter {
    
    let string: String
    
    var attributedText: NSAttributedString {
        let mutuableAttString = NSMutableAttributedString(string: string)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.57
        
        let attributes = [NSAttributedString.Key.kern: -0.41,
                        NSAttributedString.Key.paragraphStyle: paragraphStyle,
                        NSAttributedString.Key.foregroundColor: UIColor.init(named: "Text")!,
                        NSAttributedString.Key.font: UIFont(name: "DINAlternate-Bold", size: 12)!] as [NSAttributedString.Key : Any]

        mutuableAttString.addAttributes(attributes, range: NSRange(location: 0,
                                                                   length: string.count))
        return mutuableAttString
    }
}


struct BodyTextPresenter: TextPresenter {
    
    let string: String
    
    var attributedText: NSAttributedString {
        let mutuableAttString = NSMutableAttributedString(string: string)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.11
        
        let attributes = [NSAttributedString.Key.kern: 0.41,
                        NSAttributedString.Key.paragraphStyle: paragraphStyle,
                        NSAttributedString.Key.foregroundColor: UIColor.init(named: "Text")!,
                        NSAttributedString.Key.font: UIFont(name: "DINAlternate-Bold", size: 17)!] as [NSAttributedString.Key : Any]

        mutuableAttString.addAttributes(attributes, range: NSRange(location: 0,
                                                                   length: string.count))
        return mutuableAttString
    }
}

struct ColorTextPresenter: TextPresenter {
    
    let attString: NSAttributedString
    let color: UIColor
    
    var attributedText: NSAttributedString {
        let mutuableAttString = NSMutableAttributedString(attributedString: attString)
        let attributes = [NSAttributedString.Key.foregroundColor: color]
        mutuableAttString.addAttributes(attributes,
                                        range: NSRange(location: 0,
                                                       length: attString.string.count))
        return mutuableAttString
    }
}

enum TextPresenterOptions {
    case body3(string: String, withColor: UIColor? = nil)
    case body2(string: String, withColor: UIColor? = nil)
    case body(string: String, withColor: UIColor? = nil)
    case header2(string: String, withColor: UIColor? = nil)
    case headerDualColor(string1: String, string2: String, color: UIColor)
}

enum TextFactory {
    
    static func attributedText(for option: TextPresenterOptions) -> NSAttributedString {

        switch option {
        case .body3(let string, withColor: let color):
        let body3Text = Body3TextPresenter(string: string).attributedText
        if let color = color {
            let mutableString = NSMutableAttributedString(attributedString: body3Text)
            let coloredHeader = ColorTextPresenter(attString: mutableString, color: color).attributedText
            return coloredHeader
        }
        return body3Text
        case .body2(let string, withColor: let color):
            let body2Text = Body2TextPresenter(string: string).attributedText
            if let color = color {
                let mutableString = NSMutableAttributedString(attributedString: body2Text)
                let coloredHeader = ColorTextPresenter(attString: mutableString, color: color).attributedText
                return coloredHeader
            }
            return body2Text
        case .body(let string, withColor: let color):
            let bodyText = BodyTextPresenter(string: string).attributedText
            if let color = color {
                let mutableString = NSMutableAttributedString(attributedString: bodyText)
                let coloredHeader = ColorTextPresenter(attString: mutableString, color: color).attributedText
                return coloredHeader
            }
            return bodyText
        case .header2(let string, withColor: let color):
            let headerText = Header2TextPresenter(string: string).attributedText
            if let color = color {
                let mutableString = NSMutableAttributedString(attributedString: headerText)
                let coloredHeader = ColorTextPresenter(attString: mutableString, color: color).attributedText
                return coloredHeader
            }
            return headerText
        case .headerDualColor(let string1, let string2, let color):
            let mutableString = NSMutableAttributedString(attributedString: HeaderTextPresenter(string: string1)
                .attributedText)
            let mutableString2 = NSMutableAttributedString(attributedString: HeaderTextPresenter(string: string2)
            .attributedText)
            let coloredHeader = ColorTextPresenter(attString: mutableString2, color: color).attributedText
            mutableString.append(coloredHeader)
            return mutableString
        }
    }
}
