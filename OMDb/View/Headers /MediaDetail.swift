//
//  MediaDetail.swift
//  OMDb
//
//  Created by Daniel Torres on 5/12/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

protocol AttributesViewProtocol {
    func reset()
    func addAtribute(_: String)
}


class ShadowView: UIView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
    }
}

class BubbleLabel: UILabel {
    var topInset: CGFloat = 4.0
    var bottomInset: CGFloat = 4.0
    var leftInset: CGFloat = 8.0
    var rightInset: CGFloat = 8.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit(){
        layer.backgroundColor = UIColor(named: "bubble")!.cgColor
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor(red: 0.783, green: 0.783, blue: 0.783, alpha: 1).cgColor
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let shadowPath0 = UIBezierPath(roundedRect: rect, cornerRadius: 10)
        layer.shadowPath = shadowPath0.cgPath
        layer.shadowColor = UIColor(named: "ShadowColor")!.cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 4)
    }
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
}


class AttributesPresenter: NSObject, AttributesViewProtocol{
    var stackView: UIStackView
    
    init(stackView: UIStackView) {
        self.stackView = stackView
    }
    
    func setUp(){
        stackView.axis = .vertical
    }
    
    func reset() {
        for arrangeSubView in stackView.arrangedSubviews {
            arrangeSubView.removeFromSuperview()
        }
    }
    
    func addAtribute(_ attribute: String) {
        let labelAttribute = BubbleLabel(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 40)))
        labelAttribute.textAlignment = .center
        labelAttribute.numberOfLines = 0
        labelAttribute.attributedText = TextFactory.attributedText(for: .body3(string: attribute, withColor: UIColor(named: "Text")!))
        labelAttribute.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(labelAttribute)
        let targeSize = CGSize(width: stackView.bounds.size.width - 50, height: 10)
        
        let resultHeight =  labelAttribute.systemLayoutSizeFitting(targeSize,
                                               withHorizontalFittingPriority: .required,
            verticalFittingPriority: .defaultHigh).height + 10
        
        labelAttribute.heightAnchor.constraint(equalToConstant: resultHeight).isActive = true
        labelAttribute.setNeedsLayout()
        labelAttribute.layoutIfNeeded()
    }
}

protocol MediaDetailViewProtocol: ViewNibProtocol {
    var imagePosterView: ImageViewPosterProtocol! {get set}
    var title: UILabel! {get set}
    var attributesPresenter: AttributesViewProtocol! {get set}
}

class MediaDetail: UIView, MediaDetailViewProtocol {
    var imagePosterView: ImageViewPosterProtocol! {
        get {
            return imageViewMediaOutlet
        }
        set {
        }
    }
    @IBOutlet var title: UILabel!
    @IBOutlet var attributeStackView: UIStackView!
    @IBOutlet var contentView: UIView!
    @IBOutlet var imageViewMediaOutlet: ImageViewPoster!
    var attributesPresenter: AttributesViewProtocol!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("MediaDetail", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        attributesPresenter = AttributesPresenter(stackView: attributeStackView)
    }
}
