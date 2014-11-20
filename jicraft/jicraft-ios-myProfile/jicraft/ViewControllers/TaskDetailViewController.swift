//
//  TaskDetailViewController.swift
//  jicraft
//
//  Created by user on 14-9-12.
//  Copyright (c) 2014年 com.jicraft. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class TaskDetailViewController:UITableViewController{



    var task:Task!
    var helpButton:UIButton!
    var cellLayout = ["eventCover", "taskTitle", "taskDetail"]
    var cellHeight = ["eventCover": 200.0,
                       "taskTitle": 70.0,
                      "taskDetail": 212.0,
                      "eventThumb": 160.0,
                   "taskTitleDone":70.0,
                 "taskTitleUndone":70.0]
    
    var isDone = false
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        
//        if (countElements(task.help) > 0) {
            self.addHelpButton()
//        }
        
        self.addButton()
        
        if (isDone) {
            self.setButtonUndone()
        }
     
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.helpButton.hidden = false
        self.navigationController?.toolbar.removeFromSuperview()
        //self.updateUI()
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.helpButton.hidden = true
    }
    
    // MARK: Done Button
    func addButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: UIBarButtonItemStyle.Bordered, target: self, action: "selectDone")
    }
    
    func setButtonDone() {
        self.setButton("完成", action: "selectDone")
    }
    
    func setButtonUndone() {
        self.setButton("未完成", action: "selectUndone")
    }
    
    func setButton(title: NSString, action: Selector) {
        var rightBarButton = self.navigationItem.rightBarButtonItem as UIBarButtonItem!
        rightBarButton.title = title
        rightBarButton.action = action
    }
    
    func selectDone(){
        // change task to done
        let tm = TaskManager.defaultManager
        tm.changeDone(self.task)
        tm.saveTasks()
        
        self.isDone = true
        
        // update button
        self.setButtonUndone()
        
        // update table cells
        self.cellLayout = ["eventCover", "taskTitle", "taskDetail"]
        self.tableView.reloadData()
    }
    
    func selectUndone(){
        // change task to undone
        let tm = TaskManager.defaultManager
        tm.changeUndone(self.task)
        tm.saveTasks()
        
        self.isDone = false

        // update button
        self.setButtonDone()
        
        // update table cells
        self.cellLayout = ["eventCover", "taskTitle", "taskDetail"]
        self.tableView.reloadData()
    }
    
    // MARK: help button
    func addHelpButton() {
        // show toolbar
        self.navigationController?.setToolbarHidden(false, animated: true)
        
        // create help button
         self.helpButton = SpinnerButton.buttonWithType(UIButtonType.Custom) as? SpinnerButton
        
        helpButton.setTitle("求助", forState: UIControlState.Normal)
        
        // set target
        helpButton.addTarget(self, action: "didSelectHelp", forControlEvents: UIControlEvents.TouchUpInside)
        
        // button position -- cover the whole toolbar
        let toolbarFrame = self.navigationController?.toolbar.frame as CGRect!
        
        helpButton.frame = toolbarFrame
        //helpButton.backgroundColor = UIColor .redColor()
//        var image:UIImage = UIImage(named:"helpButtonIcon")
        
        let top:CGFloat = 0 // 顶端盖高度
        
        let bottom:CGFloat = 0  // 底端盖高度
        
        let left:CGFloat = 15 // 左端盖宽度
        
        let right:CGFloat = 15 // 右端盖宽度
        
        var insets:UIEdgeInsets = UIEdgeInsetsMake(top, left, bottom, right)
//        image = image.resizableImageWithCapInsets(insets, resizingMode: UIImageResizingMode.Tile)
//        helpButton.setBackgroundImage(image, forState: UIControlState.Normal)
        
        helpButton.alpha = 0.85
        // add button to subview
        self.navigationController?.view.addSubview(helpButton)
        self.navigationController?.setToolbarHidden(true, animated: false)
       
       
    }
    
    func didSelectHelp() {
        
        LoginManager.defaultManager.checkForLogin(self, onSuccess: {(username: String) -> Void in
            
            LoginManager.defaultManager.postHelpRequest(task: self.task, onSuccess: {() -> Void in
                
                var alert = UIAlertView(title: "求助", message: "收到求助－我们客服会尽快跟您联系", delegate: self, cancelButtonTitle: "OK!")
                alert.show()
                
                }, onFailure: {(error: NSError) -> Void in
                    
            })

        })
    }
    
   
}

extension TaskDetailViewController: UIAlertViewDelegate {
    func alertView(alertView: UIAlertView,
        didDismissWithButtonIndex buttonIndex: Int) {
            // send help to api
            
            
    }
}

extension TaskDetailViewController: UITableViewDelegate, UITableViewDataSource {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellLayout.count
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cellIdentifier = self.cellLayout[indexPath.row]
        let height = self.cellHeight[cellIdentifier] as Double!
        let cgf = CGFloat(height)
        return cgf
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = self.cellLayout[indexPath.row]
        var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as UITableViewCell
        
        // config cell
        if (cellIdentifier == "eventCover") {
            
            if let event = self.task.event as Event! {
                
            var coverImageView: UIImageView! = cell.viewWithTag(1001) as UIImageView
            coverImageView.sd_setImageWithURL(NSURL.URLWithString(event.photoUrl), placeholderImage: nil)
                
                var eventLabel: UILabel = cell.viewWithTag(1002) as UILabel
                eventLabel.text = event.name
                self.labelHeightForString(eventLabel.text!)
            }
            
        } else if (cellIdentifier == "taskTitle") {
            
            var titleLabel: UILabel! = cell.viewWithTag(1001) as UILabel
            titleLabel.text = self.task.title
        
        } else if (cellIdentifier == "eventThumb") {
            if let event = self.task.event as Event! {
                
                var eventTitleLabel: UILabel! = cell.viewWithTag(1001) as UILabel
                eventTitleLabel.text = event.name
                
                var eventDescLabel: UILabel! = cell.viewWithTag(1003) as UILabel
                let date = DateHelper.cstDate(event.startDate)
                let shortDate = DateHelper.shortDate(date)
                eventDescLabel.text = "\(shortDate) | \(event.location)"
                
                var eventThumb: UIImageView! = cell.viewWithTag(1002) as UIImageView
                eventThumb.layer.cornerRadius = eventThumb.frame.size.width / 2;
                eventThumb.layer.masksToBounds = true;
                eventThumb.sd_setImageWithURL(NSURL.URLWithString(event.photoUrl), placeholderImage: nil)
                
            }
        } else if (cellIdentifier == "taskDetail") {
            
           cell.addSubview(self.createLabelForEventDesc(self.task.detail))
            
        }else if (cellIdentifier == "taskTitleDone"){
        
            
            var titleLabel: UILabel! = cell.viewWithTag(1001) as UILabel
            titleLabel.text = self.task.title

        }
        else if (cellIdentifier == "taskTitleUndone"){
            
            
            var titleLabel: UILabel! = cell.viewWithTag(1001) as UILabel
            titleLabel.text = self.task.title
            
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // do nothing --- not selectable
        
        
    }
    func labelHeightForString(labelStr : String) ->CGSize {
        var dict = NSDictionary(object: UIFont.systemFontOfSize(15), forKey: NSFontAttributeName)
        var labelSize = (labelStr as NSString).boundingRectWithSize(CGSizeMake(320, 3000), options:NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: dict, context: nil).size
        
        return labelSize
    }

    func createLabelForEventDesc(eventDesc: String) -> UILabel{
        var label = UILabel()
        
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.frame = CGRectMake(10, 5, 300, self.labelHeightForString(eventDesc).height)
        label.text = eventDesc
        //self.cellHeight["taskDetail"] = Double(label.frame.size.height)
        return label
    }
}
