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
    var mediaArray: [Media]? = [Media]()
    var session: SessionProtocol?
    private let api = OMBDB_API()
    private let cellIdentifier = "MediaViewCollectionViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updater = UpdaterResults(api: ContentMediaPresenterAPI(api: api))
        setupNavigationBar()
        setUpSearchBar()
        
        collectionView.register(UINib(nibName: cellIdentifier, bundle: nil),
                                forCellWithReuseIdentifier: cellIdentifier)
        changeLayout()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    @objc
    func changeLayout(){
        let layout = ColumnFlowLayout()
        self.collectionView.collectionViewLayout = layout
    }
    
    func setupNavigationBar() {
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
        
        let cancel = UIAlertAction(title: "cancel", style: .default) {  (action) in
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
        let cellSelected = collectionView.cellForItem(at: selectedIndexPath) as! MediaCollectionViewCell
        detailVC.mediaImage = cellSelected.posterImage.image
        detailVC.api = api
    }
}

extension ViewController: UICollectionViewDelegate {
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        selectedIndexPath = indexPath
        self.performSegue(withIdentifier: "detail", sender: nil)
    }
}


extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! MediaCollectionViewCell
        
        guard let mediaArray = mediaArray else {
            return cell
        }
        let media = mediaArray[indexPath.row]
        cell.titleLabel.text = media.name
        cell.yearLabel.text = media.year
        cell.typeLabel.text = media.type?.rawValue
        cell.tag = indexPath.row
        
        ImageProvider.getImage(media: media,
                               indexPath: indexPath) { [weak cell] (image, indexPath) in
            DispatchQueue.main.async {
                guard let cell = cell else {
                    return
                }
                if cell.tag == indexPath.row {
                    cell.posterImage.image = image
                }
            }
        }
        return cell
    }
    
}
