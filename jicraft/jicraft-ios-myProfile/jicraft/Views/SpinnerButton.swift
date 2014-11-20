//
//  SpinnerButton.swift
//  jicraft
//
//  Created by JERRY LIU on 21/9/14.
//  Copyright (c) 2014 com.jicraft. All rights reserved.
//

import Foundation

enum JicraftButton {
    case Tangerine
    static let BackgroundImageNames = [Tangerine: ("tng-gradient-btn", "tng-gradient-btn-disabled")]
    
    func backgroundImages() -> (normal: UIImage, disabled: UIImage) {
        if let bgImgNames : (normal: String, disabled: String) = JicraftButton.BackgroundImageNames[self] {
            
            return (UIImage(named: bgImgNames.normal), UIImage(named: bgImgNames.disabled))
        } else {
            return (UIImage(), UIImage())
        }
    }
    
}

class SpinnerButton: UIButton {
    
    var spinner = UIActivityIndicatorView()
    
    override init() {
        super.init()
        self.setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    func setup() {
        let defaultButton = JicraftButton.Tangerine
        self.setBackgroundImage(defaultButton.backgroundImages().normal, forState: UIControlState.Normal)
        self.setBackgroundImage(defaultButton.backgroundImages().disabled, forState: UIControlState.Disabled)
        
        self.spinner.center = CGPointMake(self.frame.width/2, self.frame.height/2)
    }
    
}