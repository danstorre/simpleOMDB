//
//  ViewController.swift
//  OMDb
//
//  Created by Daniel Torres on 4/4/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit
import GoogleSignIn


class ViewController: UIViewController, UpdaterResultsDelegate {
    
    @IBOutlet var collectionView: UICollectionView!
    var updater : UpdaterResults!
    var mediaArray: [Media]? = [Media]() {
        didSet{
            dataSource?.mediaArray = mediaArray
        }
    }
    var session: SessionProtocol?
    private let api = OMBDB_API()
    private let cellIdentifier = "MediaViewViewCellProtocol"
    
    var dataSource: MediaCollectionDataSourceProtocol?
    var delegate: UICollectionViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updater = UpdaterResults(api: ContentMediaPresenterAPI(api: api))
        setupNavigationBar()
        setUpSearchBar()
        
        collectionView.register(MediaViewCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
    
        changeLayout()
        dataSource = MediaCollectionDataSource(withArray: mediaArray!, withCellIdentifier: cellIdentifier)
        collectionView.dataSource = dataSource
        delegate = MediaCollectionViewDelegate(with: navigationController)
        collectionView.delegate = delegate
    }
    
    @objc
    func changeLayout(){
        let layout = ColumnFlowLayout()
        self.collectionView.collectionViewLayout = layout
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



