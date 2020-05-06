//
//  Array+extensions.swift
//  OMDb
//
//  Created by Daniel Torres on 5/6/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

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
