//
//  OMDB+UISearchBarDelegate.swift
//  OMDb
//
//  Created by Daniel Torres on 4/4/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

enum FilterTypes: Int {
    case all = 0, movies, series, episodes
}

extension MediaStruct: Searchable {}


protocol Observable {
    var observer:PropertyObserver? {get set}
}

protocol ContentMediaPresenterAPIProtocol: UpdaterResultsAPI {
    var api: OMBDB_API_Contract {get set}
    var filter: FilterTypes {get set}
}

class ContentMediaPresenterAPI: NSObject, ContentMediaPresenterAPIProtocol {
    
    var api: OMBDB_API_Contract
    var filter: FilterTypes = FilterTypes.all
    
    init(api: OMBDB_API_Contract) {
        self.api = api
    }
    
    func search(term: String,
                pager: Pager,
                searchBar: UISearchBar?,
                finishedBlock: @escaping ([Searchable]?) -> Void) {
        
        
        if let selectedFilterIndex = searchBar?.selectedScopeButtonIndex {
            filter = FilterTypes(rawValue: selectedFilterIndex) ?? .all
        }
        let typeToSearch: MediaType
        switch filter {
        case .movies:
            typeToSearch = .movie
        case .episodes:
            typeToSearch = .episode
        case .series:
            typeToSearch = .series
        default:
            api.getMedia(searchTerm: term, type: nil, closure: { (media) in
                finishedBlock(media as? [MediaStruct])
            })
            return
        }
        
        api.getMedia(searchTerm: term, type: typeToSearch) { (media) in
            finishedBlock(media as? [MediaStruct])
        }
    }
}

extension UpdaterResults: UISearchResultsUpdating{
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if searchController.searchBar.text != "" {
            searchBar(searchController.searchBar, textDidChange: searchController.searchBar.text ?? "")
        }
    }
}


protocol ContentMediaPresenterAPIObservableProtocol: ContentMediaPresenterAPIProtocol, Observable {
}

class ContentMediaPresenterAPIObservable: NSObject, ContentMediaPresenterAPIObservableProtocol{
    var api: OMBDB_API_Contract
    var filter: FilterTypes {
        willSet(newValue) {
            observer?.willChange(propertyName: ContentMediaPresenterAPIKeys.filtertTypeKey, newPropertyValue: newValue)
        }
        didSet {
            observer?.didChange(propertyName: ContentMediaPresenterAPIKeys.filtertTypeKey, oldPropertyValue: oldValue)
        }
    }
    
    private let contentMediaPresenter: ContentMediaPresenterAPIProtocol
    
    func search(term: String, pager: Pager, searchBar: UISearchBar?, finishedBlock: @escaping ([Searchable]?) -> Void) {
        if let selectedFilterIndex = searchBar?.selectedScopeButtonIndex {
            filter = FilterTypes(rawValue: selectedFilterIndex) ?? .all
        }
        contentMediaPresenter.search(term: term, pager: pager, searchBar: searchBar, finishedBlock: finishedBlock)
    }
    
    init(observedObject: ContentMediaPresenterAPIProtocol) {
        self.api = observedObject.api
        self.filter = observedObject.filter
        self.contentMediaPresenter = observedObject
    }
    
    enum ContentMediaPresenterAPIKeys {
        static let filtertTypeKey = "filtertType"
    }
    
    var observer: PropertyObserver?
    
}
