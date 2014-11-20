//
//  LoginTextField.swift
//  jicraft
//
//  Created by JERRY LIU on 24/9/14.
//  Copyright (c) 2014 com.jicraft. All rights reserved.
//

import Foundation

class LoginTextField: UITextField {
    let inset: CGFloat = 10
    
    // placeholder position
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds , inset , inset)
    }
    
    // text position
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds , inset , inset)
    }
}