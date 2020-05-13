//
//  MediaDetail.swift
//  OMDb
//
//  Created by Daniel Torres on 5/12/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

protocol AttributesViewProtocol {
    func addAtribute(_: String)
}


class AttributesPresenter: NSObject, AttributesViewProtocol{
    var stackView: UIStackView
    
    init(stackView: UIStackView) {
        self.stackView = stackView
    }
    
    func setUp(){
        stackView.axis = .vertical
    }
    
    func addAtribute(_ attribute: String) {
        let labelAttribute = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 40)))
        labelAttribute.attributedText = TextFactory.attributedText(for: .body3(string: attribute, withColor: UIColor(named: "Text")!))
        stackView.addArrangedSubview(labelAttribute)
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
