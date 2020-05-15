//
//  PresenterDetailMediaCollectionViewDataSource.swift
//  OMDb
//
//  Created by Daniel Torres on 5/13/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

class PresenterDetailMediaCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    var media: MediaDetailsProtocol
    var cellIdentifier: String
    var reusableViewIdentifier: String
    private var dictMediaDetails: [String: String]?
    private var dictMediaDetailsKeys: [String] = [String]()
    
    init(media: MediaDetailsProtocol,  cellIdentifier: String, reusableViewIdentifier: String) {
        self.media = media
        self.cellIdentifier = cellIdentifier
        self.reusableViewIdentifier = reusableViewIdentifier
        dictMediaDetails = MediaAttributesFactory.attributes(for: .attributes(media: media))
        dictMediaDetailsKeys = Array(dictMediaDetails!.keys).sorted(by: { $0 < $1})
        super.init()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dictMediaDetails?.keys.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? MediaAttributeCollectionViewCellProtocol,
            let dictMediaDetails = dictMediaDetails else {
            return UICollectionViewCell()
        }
        
        let property = dictMediaDetailsKeys[indexPath.row]
        cell.titleAttribute.attributedText = TextFactory.attributedText(for: .header2(string: property, withColor: UIColor(named: "Text")))
        if let value = dictMediaDetails[property] {
            cell.valueAtribute.attributedText = TextFactory.attributedText(for: .body3(string: value, withColor: UIColor(named: "Gray2")))
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                                 withReuseIdentifier: reusableViewIdentifier,
                                                                                 for: indexPath)
            as? MediaHeaderReusableView else {
                return UICollectionReusableView()
        }
        
        reusableView.headerMedia.title.attributedText = TextFactory.attributedText(for: .header2(string: media.name,
                                                                                                 withColor: UIColor(named: "Text")))
        reusableView.headerMedia.attributesPresenter.reset()
        reusableView.headerMedia.attributesPresenter.addAtribute(media.genre)
        reusableView.headerMedia.attributesPresenter.addAtribute(media.runtime)
        reusableView.headerMedia.attributesPresenter.addAtribute(media.year)
        
        ImageProvider.getImage(media: media) { (imagePoster) in
            DispatchQueue.main.async {
                reusableView.headerMedia.imagePosterView.posterImage.image = imagePoster
                reusableView.headerMedia.imagePosterView.addShadows()
            }
        }
        
        return reusableView
    }
}
