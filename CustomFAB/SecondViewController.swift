//
//  SecondViewController.swift
//  CustomFAB
//
//  Created by Ruben Dias on 24/03/2020.
//  Copyright © 2020 Ruben Dias. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let button = FAB(frame: CGRect(x: 0, y: 0, width: FAB.buttonHeight, height: FAB.buttonHeight))
        button.addToController(self)
    }

    //    "Photo by Joe Hepburn on Unsplash"
    //    "https://unsplash.com/@thatjoebloke?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText"
    //    "https://unsplash.com/s/photos/interesting?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText"
}
