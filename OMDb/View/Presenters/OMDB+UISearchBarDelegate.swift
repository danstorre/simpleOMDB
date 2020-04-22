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

extension Media: Searchable {}


class ContentMediaPresenterAPI: NSObject, UpdaterResultsAPI {
    
    let api: OMBDB_API_Contract
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
                finishedBlock(media)
            })
            return
        }
        
        api.getMedia(searchTerm: term, type: typeToSearch) { (media) in
            finishedBlock(media)
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
