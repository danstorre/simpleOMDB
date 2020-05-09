//
//  ViewController.swift
//  OMDb
//
//  Created by Daniel Torres on 4/4/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit
import GoogleSignIn

class ViewController: UIViewController, UpdaterResultsDelegate, HasNavigation {
    @IBOutlet var collectionView: UICollectionView!
    var updater : UpdaterResults!
    var mediaArray: [Media]? = [Media]() {
        didSet{
            searchMediaPresenter?.mediaArray = mediaArray
        }
    }
    var session: SessionProtocol?
    private let api = OMBDB_API()
    private let cellIdentifier = "MediaViewViewCellProtocol"
    
    var dataSource: MediaCollectionDataSourceProtocol?
    var delegate: UICollectionViewDelegate?
    
    var searchMediaPresenter: PresenterSearchMediaCollection?
    var navigationObject: NavigationProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchMediaPresenter = PresenterSearchMediaCollection(collectionView: collectionView,
                                                              mediaArray: mediaArray,
                                                              navigationObject: navigationObject)
        searchMediaPresenter?.setUp()
        
        let observableContentMediaPresenter = ContentMediaPresenterAPIObservable(observedObject:
            ContentMediaPresenterAPI(api: api))
        observableContentMediaPresenter.observer = searchMediaPresenter
        updater = UpdaterResults(api: observableContentMediaPresenter)
        setupNavigationBar()
        setUpSearchBar()
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            collectionView.reloadData()
        }
    }
    
    func setupNavigationBar() {
        title = "Discover"
        if let user = session?.user {
            let profileBarItem = ProfileImageBarButtonItem(title: "", style: .plain, target: self, action: #selector(login))
            profileBarItem.setStateFor(user: user)
            navigationItem.rightBarButtonItem = profileBarItem
            
            if let sessionObserverMediator = session?.observer as? ObserverCollection {
                sessionObserverMediator.addObserver(observer: profileBarItem)
            }
        }
    }
    
    @objc
    func login(){
        let messageLogin = "Would you like to login?"
        let messageLogout = "Would you like to logout?"
        let alertController = UIAlertController(title: "Login",
                                                message: "",
                                                preferredStyle: .actionSheet)
        let LoginGoogle = UIAlertAction(title: "Login with Google", style: .default) { (action) in
            GIDSignIn.sharedInstance()?.presentingViewController = self
            GIDSignIn.sharedInstance()?.signIn()
        }
        
        let LogoutGoogle = UIAlertAction(title: "Logout", style: .default) {  (action) in
            GIDSignIn.sharedInstance()?.disconnect()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default) {  (action) in
        }
        
        if let user = session?.user, user is UserNotLogged {
            alertController.addAction(LoginGoogle)
            alertController.addAction(cancel)
            alertController.message = messageLogin
        } else {
            alertController.addAction(LogoutGoogle)
            alertController.addAction(cancel)
            alertController.message = messageLogout
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    func setUpSearchBar(){
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchResultsUpdater = updater
        searchController.showsSearchResultsController = true
        updater.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = false
        // Include the search bar within the navigation bar.
        searchController.searchBar.scopeButtonTitles = ["All", "Movies", "Series", "Episodes"]
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        
    }
    
    func didReceivedNew(items: [Searchable], forQuery: String?) {
        mediaArray = items.map({ (item) -> Media in
            return item as! Media
        })
        collectionView.reloadData()
    }
    
    func didPressButtonSearch() {
        navigationController?.navigationItem.searchController?.searchBar.resignFirstResponder()
    }
    
}



