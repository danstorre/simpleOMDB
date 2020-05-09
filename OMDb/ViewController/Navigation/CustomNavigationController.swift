//
//  CustomNavigationController.swift
//  OMDb
//
//  Created by Daniel Torres on 5/9/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

protocol NavigationProtocol: UINavigationController {
    func goTo(navigationOption: NavigationOptions, presentModally: Bool)
}

class CustomNavigationController: UINavigationController, NavigationProtocol {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func goTo(navigationOption: NavigationOptions, presentModally: Bool) {

        guard !presentModally else{
            self.present(ViewControllerFactory.vc(for: navigationOption), animated: true)
            return
        }

        self.pushViewController(ViewControllerFactory.vc(for: navigationOption), animated: true)
    }

}
