//
//  MapSearcher.swift
//  OMDb
//
//  Created by Daniel Torres on 4/5/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import MapKit

class MapSearcher: NSObject {
    
    weak var mapView: MKMapView?
    private var mapItems = [MKMapItem]()
    private var dispatchGroup: DispatchGroup = DispatchGroup()
    
    init(mapView: MKMapView) {
        self.mapView = mapView
    }
    
    func searchCountries(_ countries: [String]) {
        for country in countries {
            dispatchGroup.enter()
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = country
            request.resultTypes = .address
            let search = MKLocalSearch(request: request)
            search.start { [weak self] response, _ in
                guard let response = response else {
                    return
                }
                self?.mapItems.append(response.mapItems[0])
                self?.dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let sSelf = self else {
                return
            }
            self?.mapView?.addAnnotations(sSelf.mapItems.map({ $0.placemark}))
        }
    }
}
