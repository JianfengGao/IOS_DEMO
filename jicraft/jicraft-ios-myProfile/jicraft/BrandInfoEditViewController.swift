//
//  BrandInfoEditViewController.swift
//  jicraft
//
//  Created by impressly on 14-9-24.
//  Copyright (c) 2014年 com.jicraft. All rights reserved.
//

import Foundation
import QuartzCore

class BrandInfoEditViewController:UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    override init() {
        super.init()
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBOutlet var doneBtn: UIBarButtonItem!

    @IBOutlet var aboutTextView: UITextView!
 
    var about:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTextView()
        self.navigationItem.rightBarButtonItem?.enabled = false
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.aboutTextView.resignFirstResponder()
    }
    
    func setTextView() {
        self.aboutTextView.scrollEnabled = false
        self.aboutTextView.becomeFirstResponder()
        self.aboutTextView.layer.borderColor = UIColor(red: 255/255, green: 153/255, blue: 0, alpha: 1).CGColor
        self.aboutTextView.layer.borderWidth = 1.0
        self.aboutTextView.layer.cornerRadius = 3
    }
}

extension BrandInfoEditViewController:UITextViewDelegate {
    
    func textViewDidChange(textView: UITextView) {
        
        self.navigationItem.rightBarButtonItem?.enabled = true
        self.about = textView.text
        if textView.text == "" {
            self.navigationItem.rightBarButtonItem?.enabled = false
        }
        
    }
    func textView(textView: UITextView,
        shouldChangeTextInRange range: NSRange,
        replacementText text: String) -> Bool {
            if text == "\n" {
                self.about = textView.text
                textView.resignFirstResponder()
                return false
            }
        return true
    }
    
}
