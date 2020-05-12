//
//  ListMediaMediaCollectionDataSource.swift
//  OMDb
//
//  Created by Daniel Torres on 5/11/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

protocol ListMediaMediaCollectionDataSourceProtocol: MediaCollectionDataSourceProtocol, HasNavigation {
    init(withArray: [Media]?, withCellIdentifier: String, mediaListCellPresenter: MediaDetailsPresenterProtocol, navigationObject: NavigationProtocol?)
}

protocol ListMediaCollectionDataSourceProtocolPresentable: ListMediaMediaCollectionDataSourceProtocol {
    var mediaListCellPresenter: MediaDetailsPresenterProtocol {get set}
}

protocol MediaDetailsPresenterProtocol {
    var api: OMBDB_API_Contract {get set}
    func getMediaDetail(from: Media, completionHandler: (@escaping (MediaDetailsProtocol?)->()))
}

class MediaDetailsPresenter: NSObject, MediaDetailsPresenterProtocol {
    var api: OMBDB_API_Contract
    
    init(api: OMBDB_API_Contract){
        self.api = api
    }
    
    func getMediaDetail(from media: Media, completionHandler: @escaping ((MediaDetailsProtocol?) -> ())) {
        api.getMedia(byTitle: media.name) { (mediaDetails) in
            completionHandler(mediaDetails)
        }
    }
}

final class ListMediaMediaCollectionDataSource: NSObject, ListMediaCollectionDataSourceProtocolPresentable{
    
    var mediaArray: [Media]?
    var navigationObject: NavigationProtocol?
    var mediaListCellPresenter: MediaDetailsPresenterProtocol
    private let cellIdentifier: String
    
    required init(withArray mediaArray: [Media]?,
                  withCellIdentifier cellIdentifier: String,
                  mediaListCellPresenter: MediaDetailsPresenterProtocol,
                  navigationObject: NavigationProtocol?) {
        self.mediaArray = mediaArray
        self.cellIdentifier = cellIdentifier
        self.navigationObject = navigationObject
        self.mediaListCellPresenter = mediaListCellPresenter
        super.init()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier,
                                                            for: indexPath) as? ListItemMediaViewCollectionViewCell
        else {
                return UICollectionViewCell()
        }
        guard let media = mediaArray?[indexPath.row] else {
            return cell
        }
        cell.titleMedia.attributedText = TextFactory.attributedText(for: .header2(string: media.name,
                                                                                  withColor: UIColor(named: "Text")!))
        cell.yearReleasedMedia.attributedText = TextFactory
            .attributedText(for: .header2(string: media.year,
                                          withColor: UIColor(named: "Gray2")!))
        cell.tag = indexPath.row
        cell.imageViewMedia.posterImage.alpha = 0
        ImageProvider.getImage(media: media,
                               indexPath: indexPath) { [weak cell] (image, indexPath) in
            DispatchQueue.main.async {
                guard let cell = cell else {
                    return
                }
                if cell.tag == indexPath.row {
                    cell.imageViewMedia.posterImage.image = image
                    cell.imageViewMedia.posterImage.showAnimation()
                }
            }
        }
        cell.descriptionMedia.text = ""
        cell.authorMedia.text = ""
        
        mediaListCellPresenter.getMediaDetail(from: media, completionHandler: { [weak cell] (details) in
            guard let details = details else {
                return
            }
            DispatchQueue.main.async {
                guard let cell = cell else {
                    return
                }
                if cell.tag == indexPath.row {
                    cell.descriptionMedia.attributedText = TextFactory.attributedText(for: .body(string: details.plot, withColor: UIColor(named: "Gray2")!))
                    cell.authorMedia.attributedText = TextFactory.attributedText(for: .body(string: details.director, withColor: UIColor(named: "Text")!))
                }
            }
        })
        return cell
    }
}
