//
//  ResetPasswordViewController.swift
//  jicraft
//
//  Created by user on 14-9-22.
//  Copyright (c) 2014年 com.jicraft. All rights reserved.
//

import Foundation

class ResetPasswordViewController:UIViewController {
    
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var newPasswordTextField: UITextField!
    
    
    
    @IBOutlet weak var confirmButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "重设密码"
        self.usernameTextField.text = LoginManager.defaultManager.username
    
    }
    
    
    
    @IBAction func skipLogin(sender: AnyObject) {
        
        self.login()
        
    }
    func login(){
        
        LoginManager.defaultManager.checkForLogin(self, onSuccess: {(username: String) -> Void in
            
            self.navigationController?.popViewControllerAnimated(true)
            
            let username = LoginManager.defaultManager.username
            let token = LoginManager.defaultManager.loginToken
            println("[ProfileViewController didLogin] username: \(username), token: \(token)")
            
        })
    }
}