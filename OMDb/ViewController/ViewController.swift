//
//  ViewController.swift
//  OMDb
//
//  Created by Daniel Torres on 4/4/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit
import GoogleSignIn


extension Array: Sanitazable where Element == Media {
    func sanitize() -> [Element] {
        return self.filter { (media) -> Bool in
            
            if let url = NSURL(string: media.poster) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
            
            return false
        }.filter { (media) -> Bool in
            return media.type != nil
        }
    }
}

class PresenterMediaCollection: NSObject {
    
    private var delegate: MediaCollectionViewDelegate?
    private var datasource: MediaCollectionDataSourceProtocol?
    private var layout: UICollectionViewFlowLayout = PostersCarouselFlowLayout()
    weak var navigationController: UINavigationController?
    weak var collectionView: UICollectionView?
    
    var mediaArray: [Media]? {
        didSet {
            datasource?.mediaArray = mediaArray
        }
    }
    
    private let cellIdentifier = "MediaPosterCollectionViewCell"
    
    init(collectionView: UICollectionView, mediaArray: [Media]? = nil, navigationController: UINavigationController){
        self.collectionView = collectionView
        self.datasource = nil
        self.delegate = nil
        self.mediaArray = mediaArray
        self.navigationController = navigationController
        super.init()
        setUp()
    }
    
    func setUp(){
        collectionView?.collectionViewLayout = layout
        collectionView?.register(MediaPosterCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        datasource = MediaCollectionDataSource(withArray: mediaArray,
                                               withCellIdentifier: cellIdentifier)
        collectionView?.dataSource = datasource
        delegate = MediaCollectionViewDelegate(with: navigationController)
        collectionView?.delegate = delegate
        
    }
}

protocol SearchMediaCollectionViewDataSourceProtocol: MediaCollectionDataSourceProtocol{
    var searchMode: FilterTypes {get set}
}

protocol Navigationable {
    var navigationController: UINavigationController? {get set}
}

class MediaSearchCollectionViewDataSource: NSObject, SearchMediaCollectionViewDataSourceProtocol, Navigationable {
    weak var navigationController: UINavigationController?
    var mediaArray: [Media]?
    var searchMode: FilterTypes = .all
    private let cellIdentifier: String
    
    init(withArray medias: [Media]?, withCellIdentifier cellIdentifier: String, navigationController: UINavigationController?) {
        self.cellIdentifier = cellIdentifier
        self.navigationController = navigationController
        super.init()
        mediaArray = medias
    }
    
    private func returnNumberOfSectionsFrom(searchMode: FilterTypes) -> Int {
        var numberToReturn = 0
        switch searchMode {
        case .movies, .episodes, .series:
            numberToReturn = 1
        case .all:
            numberToReturn = 3
        }
        return numberToReturn
    }
    
    private func returnMediaFor(searchMode: FilterTypes, in mediaArray: [Media]) ->  [Media] {
        switch searchMode {
        case .movies:
            return mediaArray.filter { (media) -> Bool in
                return media.type! == .movie
            }
        case .episodes:
            return mediaArray.filter { (media) -> Bool in
                return media.type! == .episode
            }
        case .series:
            return mediaArray.filter { (media) -> Bool in
                return media.type! == .series
            }
        case .all:
            return mediaArray
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return returnNumberOfSectionsFrom(searchMode: searchMode)
    }
    var presenters: [IndexPath: PresenterMediaCollection] = [IndexPath: PresenterMediaCollection]()
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier,
                                                      for: indexPath) as! SearchCollectionViewCellProtocol
        
        guard let mediaArray = mediaArray else {
            return cell
        }
        var mediaArrayToBeUsed: [Media] = [Media]()
        
        if searchMode != .all  {
            mediaArrayToBeUsed = returnMediaFor(searchMode: searchMode, in: mediaArray)
            if let navigationController = navigationController {
                
                let presenter = PresenterMediaCollection(collectionView: cell.mediaCollectionView,
                                                         mediaArray: mediaArrayToBeUsed,
                                                         navigationController: navigationController)
                presenters[indexPath] = presenter
                presenter.setUp()
                cell.mediaCollectionView.reloadData()
            }
            return cell
        }
        
        if let filterForSection = FilterTypes(rawValue: indexPath.section + 1) {
            mediaArrayToBeUsed = returnMediaFor(searchMode: filterForSection, in: mediaArray)
        }
        if let navigationController = navigationController {
            
            let presenter = PresenterMediaCollection(collectionView: cell.mediaCollectionView,
                                                     mediaArray: mediaArrayToBeUsed,
                                                     navigationController: navigationController)
            presenters[indexPath] = presenter
            presenter.setUp()
            cell.mediaCollectionView.reloadData()
        }
        return cell
    }
}

class PresenterSearchMediaCollection: NSObject {
    
    private var datasource: SearchMediaCollectionViewDataSourceProtocol?
    private var layout: UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        if let collectionView = collectionView {
            flowLayout.itemSize = CGSize(width: collectionView.bounds.size.width, height: 190)
        }
        
        return flowLayout
    }
    
    weak var collectionView: UICollectionView?
    weak var navigationController: UINavigationController?
    
    private let cellIdentifier = "SearchCollectionViewCell"
    
    var mediaArray: [Media]? {
        didSet {
            datasource?.mediaArray = mediaArray?.sanitize()
        }
    }
    
    var searchMode: FilterTypes = .all {
        didSet {
            datasource?.searchMode = searchMode
        }
    }
    
    init(collectionView: UICollectionView, mediaArray: [Media]? = nil, navigationController: UINavigationController?){
        self.collectionView = collectionView
        self.datasource = nil
        self.mediaArray = mediaArray
        self.navigationController = navigationController
        super.init()
        setUp()
    }
    
    func setUp(){
        collectionView?.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        datasource = MediaSearchCollectionViewDataSource(withArray: mediaArray,
                                                         withCellIdentifier: cellIdentifier,
                                                         navigationController: navigationController)
        //add aloyut to colleciton
        collectionView?.dataSource = datasource
        collectionView?.collectionViewLayout = layout
    }
    
}

extension PresenterSearchMediaCollection: PropertyObserver{
    func didChange(propertyName: String, oldPropertyValue: Any?) {
    }
    
    func willChange(propertyName: String, newPropertyValue: Any?) {
        if propertyName == ContentMediaPresenterAPIObservable.ContentMediaPresenterAPIKeys.filtertTypeKey,
            let filterType = newPropertyValue as? FilterTypes {
            searchMode = filterType
        }
    }
}


class ViewController: UIViewController, UpdaterResultsDelegate {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchMediaPresenter = PresenterSearchMediaCollection(collectionView: collectionView,
                                                              mediaArray: mediaArray,
                                                              navigationController: navigationController)
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
    
    private var selectedIndexPath: IndexPath?
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedIndexPath = selectedIndexPath, let mediaArray = mediaArray else {
            return
        }
        let detailVC = segue.destination as! DetailMediaViewController
        detailVC.media = mediaArray[selectedIndexPath.row]
        let cellSelected = collectionView.cellForItem(at: selectedIndexPath) as! MediaViewViewCellProtocol
        detailVC.mediaImage = cellSelected.posterImage.image
        detailVC.api = api
    }
}



