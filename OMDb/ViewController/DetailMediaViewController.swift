//
//  DetailMediaViewController.swift
//  OMDb
//
//  Created by Daniel Torres on 4/4/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit
import MapKit


class DetailMediaViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var posterImageView: UIImageView!
    
    @IBOutlet var mapView: MKMapView!
    
    private var propertiesOfMedia = [String: AnyObject]()
    private var propertyOrder = [String]()
    var api: OMBDB_API_Contract? = nil
    var media: Media!
    
    var mapSearcher : MapSearcher!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapSearcher = MapSearcher(mapView: mapView)
        ImageProvider.getImage(media: media) { [weak self] (mediaImage) in
            self?.posterImageView.image = mediaImage
        }
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.allowsSelection = false
        searchDetails()
    }
    
    func searchDetails() {
        api?.getMedia(byTitle: media.name) { [weak self] (dictMedia) in
            DispatchQueue.main.async {
                if let dictMedia = dictMedia {
                    self?.propertiesOfMedia = dictMedia
                    self?.propertyOrder = Array(dictMedia.keys).sorted(by: { $0 > $1})
                    self?.tableView.reloadData()
                    
                    if let country = dictMedia["Country"] as? String {
                        let countries = Array(country.split(separator: ",")).map(String.init)
                        self?.mapSearcher.searchCountries(countries)
                    }
                }
            }
        }
    }
}

extension DetailMediaViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


extension DetailMediaViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return propertiesOfMedia.keys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "mediaPropertyCell", for: indexPath) as! PropertyTableViewCell
        
        let property =  propertyOrder[indexPath.row]
        
        cell.keyLabel.text = property
        cell.valueLabel.text = propertiesOfMedia[property] as? String
        
        return cell
    }
}
