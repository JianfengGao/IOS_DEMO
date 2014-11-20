//
//  EventDescViewController.swift
//  jicraft
//
//  Created by impressly on 14-9-16.
//  Copyright (c) 2014年 com.jicraft. All rights reserved.
//

import Foundation
class EventDescViewController:UIKit.UIViewController {
    
    @IBOutlet var descTextView: UITextView!
    
    var descStr:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.descTextView.text = self.descStr!
    }
    
    
}