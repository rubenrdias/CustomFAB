//
//  RoundButton.swift
//  CustomFAB
//
//  Created by Ruben Dias on 23/03/2020.
//  Copyright © 2020 Ruben Dias. All rights reserved.
//

import UIKit

class RoundButton: UIButton {
    
    private var initialSetupPerformed = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !initialSetupPerformed {
            layer.cornerRadius = bounds.height / 2
            initialSetupPerformed = true
        }
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

class BlurredView: UIView {
    
    private var blurWasAdded = false
    
    override func layoutSubviews() {
        super.layoutSubviews()

        addBlurEffect()
    }

    private func addBlurEffect() {
        if !blurWasAdded {
            let blurEffectView = createBlurEffectView()
            insertSubview(blurEffectView, at: 0)
            
            blurWasAdded = true
        }
    }
    
    private func createBlurEffectView() -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
    
        return blurEffectView
    }
}
