//
//  IntroViewController.swift
//  OMDb
//
//  Created by Daniel Torres on 4/27/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {

    @IBOutlet var headLabel: UILabel!
    @IBOutlet var bodyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headLabel.attributedText = TextFactory.attributedText(for: .headerDualColor(string1: "Welcome to",
                                                                                    string2: " Movio",
                                                                                    color: UIColor(named: "Blue1")!))
        headLabel.numberOfLines = 0
        headLabel.lineBreakMode = .byWordWrapping
        headLabel.backgroundColor = .clear
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
