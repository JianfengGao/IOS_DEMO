//
//  SignupViewController.swift
//  jicraft
//
//  Created by user on 14-9-22.
//  Copyright (c) 2014年 com.jicraft. All rights reserved.
//

import Foundation

class SignupViewController: LoginViewController {
    
    @IBOutlet weak var addPhoto: UIButton!
    @IBOutlet weak var companyNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var setPasswordTextField: UITextField!
    
   
    @IBOutlet weak var signupButton: UIButton!

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "注册"
        
        
    }
    
    @IBAction func signupTapped(sender: AnyObject) {
        var companyName = companyNameTextField.text
        var phoneNumber = phoneNumberTextField.text
        var email = emailTextField.text
        var password = setPasswordTextField.text
       
        
        if companyName != "" && phoneNumber != "" && email != ""  && password != "" {
            signupButton.addTarget(self, action: "addSucceedRegisterAlertView", forControlEvents: UIControlEvents.TouchUpInside)
            self.login()
        }else{
            signupButton.addTarget(self, action: "failRegisterAlertView", forControlEvents: UIControlEvents.TouchUpInside)
        }
    }
    
    func login(){
        
        LoginManager.defaultManager.checkForLogin(self, onSuccess: {(username: String) -> Void in
            
            self.navigationController?.popViewControllerAnimated(true)
            
            let username = LoginManager.defaultManager.username
            let token = LoginManager.defaultManager.loginToken
            println("[ProfileViewController didLogin] username: \(username), token: \(token)")
            
        })
    }
    
    func addSucceedRegisterAlertView(){
        //UIalert with succeed register
        let alertView:UIAlertView = UIAlertView(title: "注册成功", message: nil, delegate: self, cancelButtonTitle: "OK")
        alertView.show()
    }
    func failRegisterAlertView(){
       let alertView:UIAlertView = UIAlertView(title: "提示", message: "密码不一致，请重新输入", delegate: self, cancelButtonTitle: "OK")
          alertView.show()
    }
  
}
