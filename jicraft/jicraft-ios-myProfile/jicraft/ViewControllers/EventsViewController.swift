//
//  EventsViewController.swift
//  jicraft
//
//  Created by impressly on 14-9-2.
//  Copyright (c) 2014年 com.jicraft. All rights reserved.
//

import Foundation


class EventsViewController:UIKit.UIViewController{

    @IBOutlet var eventsTableView: UITableView!
   
    let kEventsNotificationName = "eventsNotificationName"
    var eventsArray :[Event] = []
   
    var httpClient = HttpJicraft()

    var refresh = UIRefreshControl()

    override func viewDidLoad() {
        
        self.eventsTableView.delegate = self
        self.eventsTableView.dataSource  = self
        self.eventsTableView.contentInset =  UIEdgeInsetsMake(62, 0, 49, 0)
        self.eventsTableView.scrollIndicatorInsets = UIEdgeInsetsMake(62, 0, 49, 0)
        
        // setup refreshControl
        self.refresh.tintColor = UIColor.redColor()
        self.refresh.attributedTitle = NSAttributedString(string: "刷新中...", attributes: [NSForegroundColorAttributeName : UIColor.redColor()])
        self.refresh.addTarget(self, action: "fetchEvents", forControlEvents: UIControlEvents.ValueChanged)
        self.eventsTableView.addSubview(self.refresh)
        
        self.navigationController?.navigationBarHidden = false
    }
    
    
    override func viewWillAppear(animated: Bool) {
        // check if not already populated
        if (self.eventsArray.count == 0) {
            self.beginRefreshingTableView()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
  
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        var eventsVC = segue.destinationViewController as EventsDetailViewController
        eventsVC.event = sender as Event
    }
    
    func beginRefreshingTableView() {
        self.refresh.beginRefreshing()
        
        if (self.eventsTableView.contentOffset.y == 0) {
            
            UIView.animateWithDuration(0.25, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState,
                animations: {() -> Void in
                    self.eventsTableView.contentOffset = CGPointMake(0, -self.refresh.frame.size.height)
                }, completion: {(finished: Bool) -> Void in
                    // done
                    self.fetchEvents()
            })

        }
    }
    
    func fetchEvents() {
        
        println("[EventsViewController fetchEvents] fetching events...")
        httpClient.indexEvents({(operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> () in
            
            self.eventsArray = Event.eventsArrayFromJson(responseObject) as [Event]
            println("[EventsViewController fetchEvents] got events OK: \(self.eventsArray.count) events")
            
            if (self.eventsArray.count > 0 ) {
                self.eventsTableView.reloadData()
            }

            self.refresh.endRefreshing()

        }, errorBlock: { (operation: AFHTTPRequestOperation!, error: NSError!) -> () in
            println("[EventsViewController fetchEvents] error: \(error)")

            // stop spinner
            self.refresh.endRefreshing()
        })
    }    
}

//MARK - UITableViewDelegate
extension EventsViewController: UITableViewDelegate {

    func tableView(tableView: UITableView!,didSelectRowAtIndexPath indexPath: NSIndexPath!){

       self.performSegueWithIdentifier("showDetail", sender: self.eventsArray[indexPath.row])
        
    }
    func tableView(tableView: UITableView,heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 330
    }
   
}

// MARK - UITableViewDataSource
extension EventsViewController: UITableViewDataSource{
    func tableView(tableView: UITableView,cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var cell:EventsTableViewCell = tableView.dequeueReusableCellWithIdentifier("EventsTableViewCell", forIndexPath: indexPath) as EventsTableViewCell
        let thisEvent = self.eventsArray[indexPath.row]
        cell.viewImage.sd_setImageWithURL(NSURL(fileURLWithPath: thisEvent.photoUrl), placeholderImage:nil)
        cell.startDateLabel.text  = thisEvent.abbrDate
        cell.origanizer.text = thisEvent.organizer
        cell.locationLabel.text = thisEvent.abbrLocation
     
        return cell        
    }
    
    func tableView(tableView: UITableView,numberOfRowsInSection section: Int) -> Int {
        return self.eventsArray.count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return (self.eventsArray.count == 0) ? 0 : 1
    }
    
}

