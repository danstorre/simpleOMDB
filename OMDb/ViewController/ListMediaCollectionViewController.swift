//
//  ListMediaCollectionViewController.swift
//  OMDb
//
//  Created by Daniel Torres on 5/11/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

protocol ListMediaScreen: AnyObject {
    var collectionView: UICollectionView! {get set}
    var presenter: PresenterMediaCollectionProtocol? {get set}
}

class ListMediaCollectionViewController: UIViewController, ListMediaScreen {
    
    @IBOutlet var collectionView: UICollectionView!
    var presenter: PresenterMediaCollectionProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
