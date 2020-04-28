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
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var normalButton: NormalButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headLabel.attributedText = TextFactory.attributedText(for: .headerDualColor(string1: "Welcome to",
                                                                                    string2: " Movio",
                                                                                    color: UIColor(named: "Blue1")!))
        headLabel.numberOfLines = 0
        headLabel.lineBreakMode = .byWordWrapping
        headLabel.backgroundColor = .clear
        
        bodyLabel.attributedText = TextFactory.attributedText(for: .body(string: bodyLabel.text!))
        bodyLabel.numberOfLines = 0
        bodyLabel.lineBreakMode = .byWordWrapping
        bodyLabel.backgroundColor = .clear
        
        stackView.addArrangedSubview(TextFactoryTextBox.textBox(for: .featureTextBox(title: "Search Media",
                                                                             titleColor: UIColor(named: "Blue1")!,
                                                                             description: "From movies, series as well as episodes.",
                                                                             image: UIImage(systemName: "doc.text.magnifyingglass")!,
                                                                             iconColor: UIColor(named: "Blue1")!)))
        stackView.addArrangedSubview(TextFactoryTextBox.textBox(for: .featureTextBox(title: "Take them with you",
                                                                            titleColor: UIColor(named: "Blue1")!,
                                                                            description: "Login with google and save your favorite media in the cloud.",
                                                                            image: UIImage(systemName: "folder")!,
                                                                            iconColor: UIColor(named: "Yellow")!)))
        stackView.addArrangedSubview(TextFactoryTextBox.textBox(for: .featureTextBox(title: "Get notified",
                                                                            titleColor: UIColor(named: "Blue1")!,
                                                                            description: "Check out new products for your needs!",
                                                                            image: UIImage(systemName: "bubble.left.and.bubble.right")!,
                                                                            iconColor: UIColor(named: "Text")!)))
        stackView.setNeedsLayout()
        stackView.layoutIfNeeded()
        
        
        if let button = ButtonFactory.button(for: .normalButton(text: "Continue")) as? NormalButton {
            normalButton.addSubview(button)
            button.frame = normalButton.bounds
            button.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
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
