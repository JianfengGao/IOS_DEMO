//
//  ForgetPasswordViewController.swift
//  jicraft
//
//  Created by user on 14-9-22.
//  Copyright (c) 2014年 com.jicraft. All rights reserved.
//

import Foundation

class ForgetPasswordViewController:UIViewController {
    @IBOutlet weak var photoImage: UIImageView!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var codeTextField: UITextField!
    
    @IBOutlet weak var confirmButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addButton()
      
    }
    
    func addButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: UIBarButtonItemStyle.Bordered, target: self, action: "getCode")
    }
    func getCode(){
        //获取验证码
    
    
    }
    
    @IBAction func resetPasswordTapped(sender: AnyObject) {
        
        
        
    }
    
}