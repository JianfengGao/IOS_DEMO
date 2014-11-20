//
//  LoginManager.swift
//  jicraft
//
//  Created by JERRY LIU on 15/9/14.
//  Copyright (c) 2014 com.jicraft. All rights reserved.
//

import Foundation

class LoginManager: NSObject {
    
    var isLoggedIn: Bool = false
    var loginToken = String()
    var username = String()
    var password = String()
    
    var profile = Profile()
    
    override init() {
        super.init()
        self.loadUser()
    }
    
    // singleton manager
    class var defaultManager : LoginManager {
        struct Static {
            static let manager = LoginManager()
        }
        return Static.manager
    }
    
    class func extractToken(jsonResponse responseObject: AnyObject) -> String {
        let jsonDict = responseObject as Dictionary<String, AnyObject>
        let userObj: AnyObject? = jsonDict["user"]
        let userDict = userObj as Dictionary<String, AnyObject>
        let tokenObj: AnyObject? = userDict["authentication_token"]
        
        return tokenObj as String
    }
    
    func checkForLogin(target: AnyObject, onSuccess: (username: String)->Void) {
        
        if (self.isLoggedIn) {
            onSuccess(username: self.username)
            return
        }
        
        // push LoginViewController
        //     states: 1) login OK --> pop and continue
        //             2) login fail --> remain on loginViewController
        //             3) cancel login or [Back] --> UINavigationController pop
        //             4) forgot --> remain on loginViewController
        //             5) isLoggedIn --> continue (don't pop!)
        
        var loginVC = UIStoryboard(name: "User", bundle: nil).instantiateViewControllerWithIdentifier("login") as LoginViewController
        
        let vc = target as UIViewController
        loginVC.onSuccess = {(username: String) -> Void in
            // LoginManager is responsible for push/pop LoginVC
            vc.navigationController?.popViewControllerAnimated(false)
            onSuccess(username: username)
        }
        vc.navigationController?.pushViewController(loginVC, animated: true)
    
    }

    func logout() {
        self.isLoggedIn = false
        self.username = ""
        self.password = ""
        self.profile = Profile()
        
        // clear user
        NSUserDefaults.standardUserDefaults().removeObjectForKey(JicraftLoginManager.usernameKey)
        NSUserDefaults.standardUserDefaults().removeObjectForKey(JicraftLoginManager.apiTokenKey)
        SSKeychain.deletePasswordForService(JicraftLoginManager.keychainService, account: self.username)
        
        saveUser()
    }
    
    func saveUser() {
        NSUserDefaults.standardUserDefaults().setObject(self.username, forKey: JicraftLoginManager.usernameKey)
        NSUserDefaults.standardUserDefaults().setObject(self.loginToken, forKey: JicraftLoginManager.apiTokenKey)
        SSKeychain.setPassword(self.password, forService: JicraftLoginManager.keychainService, account: self.username)
    }
    
    func loadUser() {
        if let _username: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey(JicraftLoginManager.usernameKey) {
            self.username = _username as String
        }
        
        if let _token: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey(JicraftLoginManager.apiTokenKey) {
            self.loginToken = _token as String
        }
        
        
        if let _keychainPassword = SSKeychain.passwordForService(JicraftLoginManager.keychainService, account: self.username) {
            self.password = _keychainPassword as String!
        }
        
        if (!self.username.isEmpty && !self.loginToken.isEmpty && !self.password.isEmpty) {
            self.isLoggedIn = true
            println("[LoginManager loadUser] auto-login saved user: \(self.username), token: \(self.loginToken)")
        }
        
    }
    
    // MARK: login
    func login(#username: String, password: String, onSuccess: (response: AnyObject)->Void, onFailure: (error: NSError)->Void) {
        
        let httpClient = HttpJicraft()
        httpClient.postLogin(username, password: password,
            successBlock: {(operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> () in
                
                self.loginToken = LoginManager.extractToken(jsonResponse: responseObject)
                self.username = username
                self.password = password
                self.isLoggedIn = true
                self.saveUser()
                
                // callback
                onSuccess(response: responseObject)
            },
            errorBlock: {(operation: AFHTTPRequestOperation!, error: NSError!) -> () in
                
                self.logout()
                onFailure(error: error)
            }
        )
    }
    
    // MARK: signup
    func signup(#username: String, password: String, name: String, onSuccess: (response: AnyObject)->Void, onFailure: (error: NSError)->Void) {
        
        let httpClient = HttpJicraft()
        httpClient.postSignup(username, password: password, name: name,
            successBlock: {(operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> () in
                
                self.loginToken = LoginManager.extractToken(jsonResponse: responseObject)
                self.username = username
                self.password = password
                self.isLoggedIn = true
                self.saveUser()
                
                // callback
                onSuccess(response: responseObject)
            },
            errorBlock: {(operation: AFHTTPRequestOperation!, error: NSError!) -> () in
                
                onFailure(error: error)
            }
        )
    }
    
    // MARK: profile
    func fetchProfile(#onSuccess: (response: AnyObject)->Void, onFailure: (error: NSError)->Void) {
        if (!self.isLoggedIn) {
            
            println("[LoginManager] tried to fetch profile, but not logged in.")
            onFailure(error: NSError(domain: "403", code: 403, userInfo: ["message": "not logged in"]))
        }
        
        let httpClient = HttpJicraft()
        httpClient.showProfile(forUser: self.username, token: self.loginToken,
            successBlock: {(operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> () in
                
                let profileJson = responseObject as [String: AnyObject]
                self.profile = Profile(json: profileJson)
                self.saveUser()
                println("[LoginManager] fetched profile: \(self.profile)")
            
                // callback
                onSuccess(response: responseObject)
            },
            errorBlock: {(operation: AFHTTPRequestOperation!, error: NSError!) -> () in
                
                println("[LoginManager] error fetching profile: \(error)")
                
                // clear login details
                self.logout()
                
                onFailure(error: error)
                
            }
        )
    }
    
    func patchProfileLogo(#logoImage: NSData, onSuccess: (response: AnyObject) -> Void, onFailure: (error: NSError) -> Void) {
        if (!self.isLoggedIn) {
            println("[LoginManager] tried to patch profile, but not logged in.")
            onFailure(error: NSError(domain: "403", code: 403, userInfo: ["message": "not logged in"]))
        }
        
        let httpClient = HttpJicraft()
        httpClient.patchProfileLogo(self.profile.url, profileObject: ["profile": ["abc": "abc"]], logoImage: logoImage, forUser: self.username, token: self.loginToken, successBlock: {(responseObject: AnyObject!) -> Void in
            
                let profileJson = responseObject as [String: AnyObject]
                self.profile = Profile(json: profileJson)
                self.saveUser()
                println("[LoginManager] patched profile OK: \(self.profile)")
            
            // callback
            onSuccess(response: responseObject)
            }, errorBlock: {(error: NSError!) -> Void in
                println("[LoginManager] error patch profile: \(error)")
                onFailure(error: error)
        })
        
    }
    
    // MARK: helpme
    func postHelpRequest(#task: Task, onSuccess: ()->Void, onFailure: (error: NSError) -> Void) {
        if (!self.isLoggedIn) {
            println("[LoginManager] tried to patch profile, but not logged in.")
            onFailure(error: NSError(domain: "403", code: 403, userInfo: ["message": "not logged in"]))
        }
        
        let taskDict = ["help_request":["task_id":task.taskId, "desc":"event:\(task.event.name), taskList: \(task.taskList.title), task: \(task.title)"]]
        
        let httpClient = HttpJicraft()
        httpClient.postHelpme(taskDict, forUser: self.username, token: self.loginToken, successBlock: {(responseObject: AnyObject!) -> Void in
            
            
                // callback
                onSuccess()
            
            }, errorBlock: {(error: NSError!) -> Void in
                println("[LoginManager] error post helpme: \(error)")
                onFailure(error: error)
        })
    }
    
    // MARK: photos
    func fetchPhotos(#onSuccess: (imageURLs: [String])->Void, onFailure: (error: NSError)->Void) {
        if (!self.isLoggedIn) {
            
            println("[LoginManager] tried to fetch profile, but not logged in.")
            onFailure(error: NSError(domain: "403", code: 403, userInfo: ["message": "not logged in"]))
        }
        
        let httpClient = HttpJicraft()
        httpClient.getProfilePhotos(forUser: self.username, token: self.loginToken,
            successBlock: {(responseObject: AnyObject!) -> () in
                
                let photosArrayObj = responseObject as [AnyObject]
                var imageURLs: [String] = []
                
                for photoObj in photosArrayObj {
                    let _dict = photoObj as [String: AnyObject]
                    
                    if let img: AnyObject = _dict["image_url"] {
                        let image_url = img as String
                        imageURLs.append(image_url)
                    }
                }
                
                // callback
                onSuccess(imageURLs: imageURLs)
            },
            errorBlock: {(error: NSError!) -> () in
                onFailure(error: error)
            }
        )
    }
    
}

struct JicraftLoginManager {
    static let keychainService = "com.jicraft.todo"
    static let usernameKey = "com.jicraft.username"
    static let apiTokenKey = "com.jicraft.apiToken"
}