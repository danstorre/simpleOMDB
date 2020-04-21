//
//  LayoutButton.swift
//  OMDb
//
//  Created by Daniel Torres on 4/4/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

class LayoutBarButton: UIBarButtonItem {
    
    var selected: ColumnType = .two
    func toggle() {
        switch selected {
        case .two:
            selected = .three
        case .three:
            selected = .two
        }
    }
}
