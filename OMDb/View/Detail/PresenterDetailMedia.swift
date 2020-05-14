//
//  PresenterDetailMedia.swift
//  OMDb
//
//  Created by Daniel Torres on 5/13/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

protocol PresenterDetailMediaProtocol: PresenterCollectionProtocol{
    var mediaDetails: MediaDetailsProtocol? {get set}
}

class PresenterDetailMedia: NSObject, PresenterDetailMediaProtocol {
    private var datasource: UICollectionViewDataSource?
    private var delegate: UICollectionViewDelegate?
    var layout: UICollectionViewFlowLayout = DetailCollectionFlowLayout()
    
    weak var collectionView: UICollectionView?
    
    private let cellIdentifier = "MediaAttributeCollectionViewCell"
    private let reusableViewIdentifier = "HeaderMediaDetailCollectionReusableView"
    private let api: OMBDB_API_Contract
    
    var media: Media
    var mediaDetails: MediaDetailsProtocol?
    
    init(media: Media, api: OMBDB_API_Contract) {
        self.api = api
        self.media = media
        super.init()
    }
    
    func setUp() {
        collectionView?.register(MediaAttributeCollectionViewCell.self,
                                 forCellWithReuseIdentifier: cellIdentifier)
        collectionView?.register(HeaderMediaDetailCollectionReusableView.self,
                                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                 withReuseIdentifier: reusableViewIdentifier)
        delegate = PresenterDetailMediaCollectionViewDelegate(cellIdentifier: cellIdentifier,
                                                              reusableViewIdentifier: reusableViewIdentifier)
        collectionView?.collectionViewLayout = layout
        collectionView?.delegate = delegate
        searchMediaDetails(media: media)
    }
    
    func searchMediaDetails(media: Media){
        api.getMedia(byTitle: media.name) { [weak self] (mediaDetails) in
            guard let self = self, let mediaDetails = mediaDetails else {return }
            DispatchQueue.main.async {
                self.datasource = PresenterDetailMediaCollectionViewDataSource(media: mediaDetails,
                                                                               cellIdentifier: self.cellIdentifier,
                                                                               reusableViewIdentifier: self.reusableViewIdentifier)
                self.collectionView?.dataSource = self.datasource
                self.collectionView?.reloadData()
            }
        }
    }
}

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
        let jsonEncoder = JSONEncoder()
        
        if let media = media as? MediaDetails, let mediaEncoded = try? jsonEncoder.encode(media),
            let jsonMediaDetails = try? JSONSerialization.jsonObject(with: mediaEncoded, options: .allowFragments),
            let dictMediaDetails = jsonMediaDetails as? [String: String]{
            self.dictMediaDetails = dictMediaDetails
            dictMediaDetailsKeys = Array(dictMediaDetails.keys).sorted(by: { $0 < $1})
        } else {
            self.dictMediaDetails = nil
        }
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
