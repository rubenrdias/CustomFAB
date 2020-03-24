//
//  ViewController.swift
//  CustomFAB
//
//  Created by Ruben Dias on 23/03/2020.
//  Copyright © 2020 Ruben Dias. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var photoTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFAB()
        setupPhotoText()
    }
    
    private func setupFAB() {
        let button = FAB(frame: CGRect(x: 0, y: 0, width: FAB.buttonHeight, height: FAB.buttonHeight))
        button.addToController(self)
    }
    
    private func setupPhotoText() {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 15, weight: .regular),
            .foregroundColor: UIColor.label
        ]
        
        let attributedString = NSMutableAttributedString(string: "Photo by Joe Hepburn on Unsplash", attributes: attributes)
        attributedString.addAttribute(.link, value: "https://unsplash.com/@thatjoebloke?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText", range: NSRange(location: 9, length: 11))
        attributedString.addAttribute(.link, value: "https://unsplash.com/s/photos/interesting?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText", range: NSRange(location: 24, length: 8))
        
        photoTextView.attributedText = attributedString
    }
}
