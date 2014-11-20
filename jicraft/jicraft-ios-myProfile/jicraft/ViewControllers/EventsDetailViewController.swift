//
//  EventsDetailViewController.swift
//  jicraft
//
//  Created by impressly on 14-9-2.
//  Copyright (c) 2014年 com.jicraft. All rights reserved.
//

import Foundation
import UIKit


class EventsDetailViewController: UITableViewController {
 
    var attendBtn:UIButton?
    var event:Event!
    
//    var httpClient = HttpJicraft()
   
    var cellLayout = ["eventCover", /*"eventThumb",*/ "eventName", "eventDesc"]
    var cellHeight = ["eventCover": 250.0, "eventName": 168.0, "eventDesc": 225.0, "eventThumb": 160.0]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "活动细节"
        self.addAttendButton()
        
        self.tableView.contentInset =  UIEdgeInsetsMake(62, 0, 49, 0)
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(62, 0, 49, 0)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.attendBtn?.hidden = true
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.attendBtn?.hidden = false
//        self.navigationController?.toolbar.removeFromSuperview()
        self.configButton()
    }
    
    // MARK: Attend Button
    func configButton() {
        let tm = TaskManager.defaultManager
        self.attendBtn?.enabled = !(tm.events.contains(self.event))
    }
    
    func addAttendButton() {
        
        // create help button
        self.navigationController?.setToolbarHidden(false, animated: true)
        
        self.attendBtn = SpinnerButton.buttonWithType(UIButtonType.Custom) as? SpinnerButton
        
        // set target
        self.attendBtn!.addTarget(self, action:"handleAttendBtn:", forControlEvents: UIControlEvents.TouchUpInside)
        
        // button position -- cover the whole toolbar
        let toolbarFrame = self.navigationController?.toolbar.frame as CGRect!
        self.attendBtn!.frame = CGRectMake(toolbarFrame.origin.x, toolbarFrame.origin.y - 6 , toolbarFrame.size.width, 51)
        
        // button looks -- background etc already setup by SpinnerButton
        self.attendBtn!.alpha = 0.85
        
        // button titles
        self.attendBtn?.setTitle("已参加", forState: UIControlState.Disabled)
        self.attendBtn!.setTitle("点我参加", forState: UIControlState.Normal)
        
        // add button to subview
        self.navigationController?.view.addSubview(self.attendBtn!)
        self.navigationController?.setToolbarHidden(true, animated: false)
    }
    
    func handleAttendBtn(sender: UIButton) {
        
        LoginManager.defaultManager.checkForLogin(self, onSuccess: {
            (username: String) -> Void in
            
            self.addTasks()
            self.performSegueWithIdentifier("eventAttend", sender: nil)
        })
        
    }
    
    func addTasks() {
        var tm = TaskManager.defaultManager
        tm.addTasks(event: self.event)
    }
    
    // MARK: Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "eventDescDetail") {
            var eventDescDetailVC = segue.destinationViewController as EventDescViewController
            println("segue :\(segue.destinationViewController)")
            
            eventDescDetailVC.descStr = sender as String!
        }
        
        if (segue.identifier == "eventAttend") {
            var attendVC = segue.destinationViewController as EventAttendViewController
            attendVC.delegate = self
        }
    }
    
  
}
extension EventsDetailViewController: UITableViewDelegate, UITableViewDataSource {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellLayout.count
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cellIdentifier = self.cellLayout[indexPath.row]
        let height = self.cellHeight[cellIdentifier] as Double!
//        let cgf = CGFloat.convertFromFloatLiteral(height!)
        let cgf = CGFloat(height)
        return cgf
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = self.cellLayout[indexPath.row]
        var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as UITableViewCell
        
        // config cell
        if (cellIdentifier == "eventCover") {
            
            if let event = self.event as Event! {
                
                var coverImageView: UIImageView! = cell.viewWithTag(1001) as UIImageView
                coverImageView.sd_setImageWithURL(NSURL.URLWithString(self.event.photoUrl), placeholderImage: nil)
                
                var eventLabel: UILabel! = cell.viewWithTag(1002) as UILabel
                eventLabel.text = event.name
            }
            
        } else if (cellIdentifier == "eventName") {
            
            var titleLabel: UILabel! = cell.viewWithTag(1001) as UILabel
            var organizerLabel: UILabel! = cell.viewWithTag(1002) as UILabel
            var dateLabel: UILabel! = cell.viewWithTag(1003) as UILabel
            var priceLabel: UILabel! = cell.viewWithTag(1004) as UILabel
            var locationLabel: UILabel! = cell.viewWithTag(1005) as UILabel
            titleLabel.text = self.event.name
            organizerLabel.text = self.event.organizer
            dateLabel.text  = self.event.dateForEvent
            priceLabel.text  = self.event.price
            locationLabel.text = self.event.location
            
        } else if (cellIdentifier == "eventThumb") {
            if let event = self.event as Event! {
                
                var eventTitleLabel: UILabel! = cell.viewWithTag(1001) as UILabel
                eventTitleLabel.text = self.event.name
                
                var eventDescLabel: UILabel! = cell.viewWithTag(1003) as UILabel
                eventDescLabel.text = "\(self.event.startDate) | \(self.event.location)"
                
                var eventThumb: UIImageView! = cell.viewWithTag(1002) as UIImageView
                eventThumb.layer.cornerRadius = eventThumb.frame.size.width / 2;
                eventThumb.layer.masksToBounds = true;
                eventThumb.sd_setImageWithURL(NSURL.URLWithString(self.event.photoUrl), placeholderImage: nil)
                
            }
        } else if (cellIdentifier == "eventDesc") {
            
            var detailLabel: UILabel! = cell.viewWithTag(1001) as UILabel
            var descDetailBtn : UIButton! = cell.viewWithTag(1002) as UIButton
         
            detailLabel.text = self.event.desc
            
            descDetailBtn.setTitle("阅读更多", forState: UIControlState.Normal)
            descDetailBtn.layer.borderWidth = 1
            descDetailBtn.layer.borderColor = UIColor.redColor().CGColor
            descDetailBtn.addTarget(self, action:"handleMoreDescBtn:", forControlEvents: UIControlEvents.TouchUpInside)
            
        }
        
        return cell
    }
    
    func handleMoreDescBtn(sender : UIButton) {
        
         self.performSegueWithIdentifier("eventDescDetail", sender: self.event.desc)
        
    }
    
    
    
    func labelHeightForString(labelStr : String) ->CGSize {
        var dict = NSDictionary(object: UIFont.systemFontOfSize(14), forKey: NSFontAttributeName)
        var labelSize = (labelStr as NSString).boundingRectWithSize(CGSizeMake(320, 4000), options:NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: dict, context: nil).size
        
        return labelSize
    }
    
    func createLabelForEventDesc(eventDesc: String) -> UILabel{
        var label = UILabel()
        
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.frame = CGRectMake(0, 0, 320, self.labelHeightForString(eventDesc).height)
        label.text = eventDesc
        self.cellHeight["eventDesc"] = Double(label.frame.size.height)
        return label
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // do nothing --- not selectable
        
    }
    
}

extension EventsDetailViewController : EventAttendViewControllerDelegate {
    func eventAttendViewControllerDidDismiss(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}