//
//  ProfileViewController.swift
//  jicraft
//
//  Created by JERRY LIU on 3/9/14.
//  Copyright (c) 2014 com.jicraft. All rights reserved.
//

import UIKit

class ProfileViewController: UICollectionViewController {
    
    var profile = Profile()
    var profileDetails: [String: String] = [:]
    var photos: [String] = []
    
    var cellHeight: [String: Double] = ["logoCell": 195.0, "emptyCell" : 195.0, "detailCell": 20.0, "photoCell": 105.33]
    
    var refresh = UIRefreshControl()
  
    @IBOutlet var loginBarButton: UIBarButtonItem!
    @IBOutlet var editBarButton: UIBarButtonItem!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // uinavbar bottom border shadow
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        
        // setup refreshControl
        self.refresh.tintColor = UIColor.redColor()
        self.refresh.attributedTitle = NSAttributedString(string: "刷新中...", attributes: [NSForegroundColorAttributeName : UIColor.redColor()])
        self.refresh.addTarget(self, action: "fetchProfile:", forControlEvents: UIControlEvents.ValueChanged)
        self.collectionView.addSubview(self.refresh)
        
        // setup login and edit buttons
        self.configBarButtons()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        // check if not already populated
        if (self.profile.name.isEmpty) {
            self.beginRefreshingCollectionView()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Refresh
    func beginRefreshingCollectionView() {
        self.refresh.beginRefreshing()
        
         let cv = self.collectionView
            if (cv.contentOffset.y == 0) {
                UIView.animateWithDuration(0.25, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState,
                    animations: {() -> Void in
                        cv.contentOffset = CGPointMake(0, -self.refresh.frame.size.height)
                    }, completion: {(finished: Bool) -> Void in
                        
                        self.fetchProfile()
                        self.fetchPhotos()
                })
            }
        
        
    }
    
    // MARK: Fetch Profile
    func fetchProfile() {
        LoginManager.defaultManager.fetchProfile(
            onSuccess: {(response: AnyObject) -> Void in
                
                self.profile = LoginManager.defaultManager.profile
                
                // populate profileDetails
                let _details = ["qq": self.profile.qq,
                                "weibo": self.profile.weibo,
                                "weixin": self.profile.wechat,
                                "www": self.profile.website,
                                "email": self.profile.email]
                
                self.profileDetails = _details
                
                self.configBarButtons()
                self.collectionView.reloadData()
                self.refresh.endRefreshing()
                
                println("[ProfileVC fetchProfile] profile: \(self.profile)")
                
            }, onFailure:{(error: NSError) -> Void in
                // warn no profile
                println("[ProfileViewController fetchProfile] failed, isLoggedIn? \(LoginManager.defaultManager.isLoggedIn)")
                
                self.configBarButtons()
                self.collectionView.reloadData()
                self.refresh.endRefreshing()
        })
    }
    
    func profileDetailsSummary() -> String {
        // show top 2, and then website if they have it
        let _contacts = ["weixin", "weibo", "qq"]
        let _label = ["weixin": "微信", "weibo": "微博", "qq": "QQ"]
        var _cnt = 0
        var _summarys: [String] = []
        
        for c in _contacts {
            if (_cnt > 1 ) {break}
            
            let lbl = _label[c] as String!
            let detail = self.profileDetails[c] as String!
            if (!detail.isEmpty) {
                _summarys.append("\(lbl): \(detail)")
                _cnt = _cnt + 1
            }
            
        }
        var summary = _summarys.reduce("", combine: {$0 == "" ? $1 : $0 + " | " + $1})
        
        if let www = self.profileDetails["www"] as String! {
            summary += "\n官网: \(www)"
        }
        
        return summary
    }
    
    func fetchPhotos() {
        LoginManager.defaultManager.fetchPhotos(onSuccess: {(imageUrls: [String]) -> Void in
            
            self.photos = imageUrls
            self.collectionView.reloadData()
            
            self.refresh.endRefreshing()
        }, onFailure:{(error: NSError) -> Void in
                // warn no profile
                
            self.refresh.endRefreshing()
        })
    }
    
    // MARK: LoginButton
    func configBarButtons() {
        let lm = LoginManager.defaultManager
        if (lm.isLoggedIn) {
            self.loginBarButton.title = "登出"
            self.loginBarButton.action = "didLogout:"
            
            self.editBarButton.enabled = true
        } else {
            self.loginBarButton.title = "登入"
            self.loginBarButton.action = "didLogin:"
            
            self.editBarButton.enabled = false
        }
    }
    
    @IBAction func didLogin(sender: AnyObject) {
        
        LoginManager.defaultManager.checkForLogin(self, onSuccess: {(username: String) -> Void in
            
            let username = LoginManager.defaultManager.username
            let token = LoginManager.defaultManager.loginToken
            println("[ProfileViewController didLogin] username: \(username), token: \(token)")
            
            // refresh after login
            self.fetchProfile()
            self.fetchPhotos()
            self.configBarButtons()
        })
        
    }
    
    @IBAction func didLogout(sender: AnyObject) {
        
        LoginManager.defaultManager.logout()
        self.configBarButtons()
        self.profile = Profile()
        self.photos = []
        self.collectionView.reloadData()
        
    }

    @IBAction func didEdit(sender: AnyObject) {
        self.performSegueWithIdentifier("editProfile", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "editProfile") {
            var editProfileViewController = segue.destinationViewController as EditProfileViewController
            
            editProfileViewController.profile = self.profile
        }
    }
}


// MARK: UICollectionViewDelegate
extension ProfileViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (section == 0) {
            // profile logo
            return (self.profile.name.isEmpty ? 0 : 1)
        } else if (section == 1) {
            // empty profile cell
            return (self.profile.name.isEmpty ? 1 : 0)
        } else {
            // profile photos
            return self.photos.count
        }
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            
            if (indexPath.section == 0) {
                
                let h = self.cellHeight["logoCell"] as Double!
                return CGSizeMake(collectionView.frame.size.width, CGFloat(h))
            } else if (indexPath.section == 1) {
                
                let h = self.cellHeight["emptyCell"] as Double!
                return CGSizeMake(collectionView.frame.size.width, CGFloat(h))
                
            } else {
                
                let h = self.cellHeight["photoCell"] as Double!
                return CGSizeMake(CGFloat(h), CGFloat(h))
            }
    }
    
override
    func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            
            var cell: UICollectionViewCell
            
            if (indexPath.section == 0 ) {
                cell = self.logoCell(collectionView: collectionView, indexPath: indexPath)
            } else if (indexPath.section == 1) {
                cell = self.emptyCell(collectionView: collectionView, indexPath: indexPath)
            } else {
                cell = self.photoCell(collectionView: collectionView, indexPath: indexPath)
            }
            return cell
    }

    func emptyCell(#collectionView: UICollectionView, indexPath: NSIndexPath) -> UICollectionViewCell {
        let cellIdentifier = "emptyCell"
        var cell: UICollectionViewCell! = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as UICollectionViewCell
        
        var signupButton = cell.viewWithTag(1003) as UIButton
        signupButton.targetForAction("didLogin:", withSender: nil)
        
        // add border
        var layer = CALayer()
        layer.frame = CGRectMake(0, 0, signupButton.layer.frame.width, signupButton.layer.frame.height)
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.lightTextColor().CGColor
        signupButton.layer.addSublayer(layer)
        
        return cell
    }

    
    func logoCell(#collectionView: UICollectionView, indexPath: NSIndexPath) -> UICollectionViewCell {
        let cellIdentifier = "logoCell"
        var cell: UICollectionViewCell! = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as UICollectionViewCell
        
        var logoImageView = cell.viewWithTag(1001) as UIImageView
        logoImageView.sd_setImageWithURL(NSURL(fileURLWithPath: self.profile.logoUrl), placeholderImage:UIImage(named: "empty-profile"))
        
        var nameLabel = cell.viewWithTag(1002) as UILabel
        nameLabel.text = self.profile.name
        
        var aboutLabel = cell.viewWithTag(1003) as FXLabel
        aboutLabel.text = self.profile.about
        aboutLabel.contentMode = UIViewContentMode.Top
        
        var contactsLabel = cell.viewWithTag(1004) as FXLabel
        contactsLabel.text = self.profileDetailsSummary()
        
        return cell
    }
    
    // deprecated
    func infoCell(#collectionView: UICollectionView, indexPath: NSIndexPath) -> UICollectionViewCell {
        let cellIdentifier = "detailCell"
        var cell: UICollectionViewCell! = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as UICollectionViewCell
        
        var iconImageView = cell.viewWithTag(1001) as UIImageView
        var detailLabel = cell.viewWithTag(1002) as UILabel
        
        return cell
    }
    
    func photoCell(#collectionView: UICollectionView, indexPath: NSIndexPath) -> UICollectionViewCell {
        let cellIdentifier = "photoCell"
        var cell: UICollectionViewCell! = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as UICollectionViewCell
        
        let photoURL = self.photos[indexPath.row]
        var photoImageView = cell.viewWithTag(1001) as UIImageView
        photoImageView.sd_setImageWithURL(NSURL(fileURLWithPath: photoURL), placeholderImage: nil)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
            if (section == 0 || section == 1) {
                return CGFloat(0.0)
            } else {
                return CGFloat(2.0)
            }
    }
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
            if (section == 0 || section == 1) {
                return CGFloat(0.0)
            } else {
                return CGFloat(2.0)
            }
    }

}

