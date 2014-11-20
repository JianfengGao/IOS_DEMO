//
//  ShortInputViewController.swift
//  jicraft
//
//  Created by JERRY LIU on 24/9/14.
//  Copyright (c) 2014 com.jicraft. All rights reserved.
//

import Foundation
import QuartzCore

@objc protocol ShortInputViewControllerDelegate {
    func shortInputViewControllerDidDismiss(sender: AnyObject)
    func shortInputViewControllerDidDone(text: String, field: String)
}

class ShortInputViewController: UIViewController {
    
    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet var doneButton: UIBarButtonItem!
    @IBOutlet var textField: UITextField!
    @IBOutlet var tipLabel: UILabel!
    
    var delegate: ShortInputViewControllerDelegate?
    var tipText = String()
    var editingField = String()
    var text: String?
    
    override func viewDidLoad() {
        self.textField.text = self.text
        
        if (!self.tipText.isEmpty) {
            self.tipLabel.text = self.tipText
        }
        self.doneButton.enabled = false
        self.setTextField()
    }
    func setTextField() {
        self.setTextFieldKeyboardType()
        self.textField.becomeFirstResponder()
        self.textField.layer.borderColor = UIColor(red: 255/255, green: 153/255, blue: 0, alpha: 1).CGColor
        self.textField.layer.borderWidth = 1.0
        self.textField.layer.cornerRadius = 3.0
    }
    @IBAction func didCancel(sender: AnyObject) {
        self.delegate?.shortInputViewControllerDidDismiss(self)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func didDone(sender: AnyObject) {
        self.delegate?.shortInputViewControllerDidDone(self.textField.text, field: self.editingField)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    func setTextFieldKeyboardType() {
        switch self.editingField {
            
        case "tel","qq":
            self.textField.keyboardType = UIKeyboardType.PhonePad
        case "email":
           self.textField.keyboardType = UIKeyboardType.EmailAddress
        default:
            break
        }

    }
}

extension ShortInputViewController: UITextFieldDelegate {
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        // enable/disable done button?
        self.doneButton.enabled = true
        //check input empty
        let leng = (textField.text as NSString).stringByReplacingCharactersInRange(range,withString:string)
        if countElements(leng) == 0 {
            self.doneButton.enabled = false
        }
        return true
    }
}

extension ShortInputViewController:UITextFieldDelegate {
    func textFieldShouldReturn(textField:UITextField) -> Bool {
        textField.resignFirstResponder()
        self.delegate?.shortInputViewControllerDidDone(self.textField.text, field: self.editingField)
        self.navigationController?.popViewControllerAnimated(true)
        return true
    }
}