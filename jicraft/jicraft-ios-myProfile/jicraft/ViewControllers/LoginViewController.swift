//
//  LoginViewController.swift
//  jicraft
//
//  Created by JERRY LIU on 23/7/14.
//  Copyright (c) 2014 com.jicraft. All rights reserved.
//

import UIKit
import AssetsLibrary

enum LoginViewControllerState: Int {
    case Login, Signup, Forgot, ForgotVerify
    static let numberOfRowsDict = [Login: 2, Signup: 3, Forgot: 1, ForgotVerify: 2]
    static let actionsDict = [Login: ("新注册", "忘记密码?"), Signup: ("登入", ""), Forgot: ("登入", ""), ForgotVerify: ("登入", "")]
    
    static let submitDict = [Login: "登入", Signup: "注册", Forgot: "重置密码"]
    
    func numberOfRows() -> Int {
        if let n = LoginViewControllerState.numberOfRowsDict[self] {
            return n
        } else {
            return 0
        }
    }
    
    func actions() -> (left: String, right: String) {
        if let (left: String, right: String) = LoginViewControllerState.actionsDict[self] {
            return (left: left, right: right)
        } else {
            return ("", "")
        }
    }
    
    func submit() -> String {
        if let submit = LoginViewControllerState.submitDict[self] {
            return submit
        } else {
            return  ""
        }
    }
    
}

class LoginViewController: UITableViewController {
    
    @IBOutlet var usernameTextField : LoginTextField!
    @IBOutlet var passwordTextField : LoginTextField!
    @IBOutlet var nameTextField     : LoginTextField!
    
    @IBOutlet var submitButton : SpinnerButton!
    
    @IBOutlet var leftAction: UIButton!
    @IBOutlet var rightAction: UIButton!
    
    
    
    var controllerState: LoginViewControllerState = LoginViewControllerState.Login
    var tableViewFields = 2
    
    var onSuccess: ((username: String) -> Void)?
    
    required init(coder aDecoder: NSCoder) {
        self.onSuccess = {(String) -> Void in }
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
        self.nameTextField.delegate = self
        
        self.submitButton.enabled = false
        self.submitButton.alpha = 0.7
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.backgroundColor = UIColor.clearColor()
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "login_bg"))
        
        self.configActions()
    }
    
    // MARK: Config views
    func configActions() {
        let actions = self.controllerState.actions()
        let submit = self.controllerState.submit()
        
        self.leftAction.setTitle(actions.left, forState: UIControlState.Normal)
        self.leftAction.enabled = !actions.left.isEmpty
        
        self.rightAction.setTitle(actions.right, forState: UIControlState.Normal)
        self.rightAction.enabled = !actions.right.isEmpty
        
        self.submitButton.setTitle(submit, forState: UIControlState.Normal)
    }
    
    @IBAction func didLeftAction() {
        
        if (self.controllerState == LoginViewControllerState.Login) {
            
            self.controllerState = LoginViewControllerState.Signup
            self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 2, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
            
            
        } else if(self.controllerState == LoginViewControllerState.Signup) {
            
            self.controllerState = LoginViewControllerState.Login
            self.tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: 2, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
            
        } else if (self.controllerState == LoginViewControllerState.Forgot) {
            
            self.controllerState = LoginViewControllerState.Login
            self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
            
        } else {
            // nothing
        }
        
        self.tableView.reloadData()
        self.configActions()
    }
    
    
    @IBAction func didRightAction() {
        
        if (self.controllerState == LoginViewControllerState.Login) {
            
            self.controllerState = LoginViewControllerState.Forgot
            self.tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
            
        } else {
            // nothing
        }
        
        self.tableView.reloadData()
        self.configActions()
    }
    
    
    // MARK: Submit
    @IBAction func submitTapped() {
        if (self.controllerState == LoginViewControllerState.Login) {
            self.submitLogin()
        } else if (self.controllerState == LoginViewControllerState.Signup) {
            
            self.submitSignup()
        } else if (self.controllerState == LoginViewControllerState.Forgot) {
            // forgot
        }
    }
    
    
    func submitLogin() {
        var username = usernameTextField.text
        var password = passwordTextField.text
        
        // start spinner
        self.submitButton.spinner.startAnimating()
        
        // disable button
        self.submitButton.enabled = false
        
        LoginManager.defaultManager.login(username: username, password: password,
            onSuccess: {(responseObject: AnyObject) in
                
                self.submitButton.spinner.stopAnimating()
                self.submitButton.enabled = true
                self.onSuccess!(username: username)
                
            }, onFailure: {(error: NSError) in
                
                self.submitButton.spinner.stopAnimating()
                self.submitButton.enabled = true
                
                // UIAlert with error ?
                let alertView:UIAlertView = UIAlertView(title: "登入失败", message: "无法登入!", delegate: self, cancelButtonTitle: "OK")
                alertView.show()
                
                
        })
    }
    
    func submitSignup() {
        var username = usernameTextField.text
        var password = passwordTextField.text
        var name = nameTextField.text
        // start spinner
        self.submitButton.spinner.startAnimating()
        
        // disable button
        self.submitButton.enabled = false
        
        LoginManager.defaultManager.signup(username: username, password: password, name: name,
            onSuccess: {(responseObject: AnyObject) in
                
                self.submitButton.spinner.stopAnimating()
                self.submitButton.enabled = true
                self.onSuccess!(username: username)
                
            }, onFailure: {(error: NSError) in
                
                self.submitButton.spinner.stopAnimating()
                self.submitButton.enabled = true
                
                // UIAlert with error ?
                let alertView:UIAlertView = UIAlertView(title: "注册失败", message: "\(error)", delegate: self, cancelButtonTitle: "OK")
                alertView.show()
                
                
        })
    }
}

extension LoginViewController: UITableViewDataSource, UITableViewDelegate {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.controllerState.numberOfRows()
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if (self.controllerState == LoginViewControllerState.Login) {
            self.submitButton.enabled = (!self.usernameTextField.text.isEmpty && !self.passwordTextField.text.isEmpty)
            
        } else if (self.controllerState == LoginViewControllerState.Signup) {
            self.submitButton.enabled = (!self.usernameTextField.text.isEmpty && !self.passwordTextField.text.isEmpty && !self.nameTextField.text.isEmpty)
            
        } else if (self.controllerState == LoginViewControllerState.Forgot) {
            self.submitButton.enabled = (!self.usernameTextField.text.isEmpty)
            
        } else {
            // do nothing
        }
        
        self.submitButton.alpha = (self.submitButton.enabled ? 1.0 : 0.7)
        return true
    }
}

extension LoginViewController:UITextFieldDelegate {
    func textFieldShouldReturn(textField:UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
        
    }
}