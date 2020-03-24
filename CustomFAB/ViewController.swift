//
//  ViewController.swift
//  CustomFAB
//
//  Created by Ruben Dias on 23/03/2020.
//  Copyright © 2020 Ruben Dias. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = FAB(frame: CGRect(x: 0, y: 0, width: FAB.buttonHeight, height: FAB.buttonHeight))
        button.addToController(self)
        
    }

//    "Photo by Nijwam Swargiary on Unsplash"
//    "https://unsplash.com/@pixel_talkies?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText"
//    "https://unsplash.com/s/photos/interesting?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText"
}
