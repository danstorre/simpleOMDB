//
//  UpdaterResults.swift
//  OMDb
//
//  Created by Daniel Torres on 4/4/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit


protocol Searchable {
    
}

protocol PagerDelegate: class {
    func page()
}

protocol UpdaterResultsDelegate: class{
    func didReceivedNew(items: [Searchable], forQuery: String?)
    func didPressButtonSearch()
}

protocol UpdaterResultsAPI {
    func search(term: String, pager: Pager, searchBar: UISearchBar?, finishedBlock: @escaping ([Searchable]?) -> Void)
}

class UpdaterResults : NSObject, UISearchBarDelegate, PagerDelegate{
    
    
    //an searcher api, takes a term argument and returns a list of decodable objects.
    private let api: UpdaterResultsAPI
    
    //takes care the results of the api consumed.
    weak var delegate: UpdaterResultsDelegate?
    private var pager: Pager = Pager(limit: 0)
    
    init(api: UpdaterResultsAPI) {
        self.api = api
        super.init()
    }
    
    private var searching: Bool = false
    
    //controls the request with a timeinterval defined
    private var throtle = Timer()
    private var queryToSearchString = ""
    private var searchedQueryString = ""
    
    var searchBar: UISearchBar?
    
    private var selectedIndexScope = 0
    private var newIndex = 0
    
    var lastTermSearched: String {
        return searchedQueryString
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchBar = searchBar
        newIndex = searchBar.selectedScopeButtonIndex
        guard let query = searchBar.text else {
            return
        }
        
        
        queryToSearchString = query
        
        guard !throtle.isValid else {
            return
        }
        
        throtle = Timer.scheduledTimer(timeInterval: 1,
                                       target: self,
                                       selector: #selector(resetTimer),
                                       userInfo: nil,
                                       repeats: false)
    }
    
    
    @objc
    private func resetTimer(){
        
        throtle.invalidate()
        guard (searchedQueryString != queryToSearchString ||
            selectedIndexScope != newIndex ) else {
            return
        }
        selectedIndexScope = newIndex
        searchedQueryString = queryToSearchString
        search(query: queryToSearchString)
    }
    
    private func search(query: String) {
        searching = true
        api.search(term: query, pager: pager, searchBar: searchBar) { [weak self] (items) -> Void in
            guard let `self` = self else{
                return
            }
            
            guard let items = items else {
                //send empty
                DispatchQueue.main.async {
                    `self`.delegate?.didReceivedNew(items: [Searchable](), forQuery: query)
                    `self`.searching = false
                }
                return
            }
            
            //excute update UI in the main thread.
            DispatchQueue.main.async {
                `self`.delegate?.didReceivedNew(items: items, forQuery: query)
                `self`.searching = false
            }
        }
    }
    
    func page() {
        if  !searching && !pager.limitReached
        {
            pager.doPage()
            search(query: searchedQueryString)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        delegate?.didPressButtonSearch()
    }
}

struct Pager{
    
    init(limit: Int){
        self.limit = limit
    }
    
    var cuurentPage: Int = 0
    
    var limitReached: Bool {
        return cuurentPage == limit
    }
    
    private var limit: Int = 0
    
    mutating func doPage(){
        guard !limitReached else{
            return
        }
        cuurentPage += 1
    }
    
}
