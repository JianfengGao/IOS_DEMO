//
//  TaskListsViewController.swift
//  jicraft
//
//  Created by JERRY LIU on 5/9/14.
//  Copyright (c) 2014 com.jicraft. All rights reserved.
//

import Foundation

struct TaskListViewControllerMode {
    static let Events = "com.jicraft.todo.taskListViewController.events"
    static let TaskLists = "com.jicraft.todo.taskListViewController.taskLists"
}
class TaskListsViewController: UITableViewController {
    
    var listsDict: [TaskList: (totalTasks: Int, doneTasks: Int, tasks: Int)] = [:]
    
    var eventsDict: [Event: (totalTasks: Int, doneTasks: Int, tasks: Int)] = [:]
    
    var mode = TaskListViewControllerMode.TaskLists
    
    var cellHeight = [TaskListViewControllerMode.Events: 209.0, TaskListViewControllerMode.TaskLists: 74.0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        
    }
    override func viewWillAppear(animated: Bool) {
        if(self.tableView.contentInset.top != 64) {
            self.setupTableView()
        }
        self.fetchListsDict()
        self.fetchEventsDict()
    }
    
    // layout bug?
    func setupTableView() {
        self.tableView.contentInset =  UIEdgeInsetsMake(64, 0, 49, 0)
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(64, 0, 49, 0)
    }
    
    func fetchListsDict() {
        let tm = TaskManager.defaultManager
        self.listsDict = tm.getListsDict()
//        println("[TaskListsViewController] listDict: \(self.listsDict)")
        
        let taskLists: [TaskList] = self.listsDict.keys.array as [TaskList]
        for tl in taskLists {
            println("[TaskListsViewController] taskList: \(tl.title), info: \(self.listsDict[tl])")
        }
    }
    
    func fetchEventsDict() {
        let tm = TaskManager.defaultManager
        self.eventsDict = tm.getEventsDict()
        println("[TaskListsViewController] events count: \(self.eventsDict.keys.array.count)")
        
        let events: [Event] = self.eventsDict.keys.array as [Event]
        for ev in events {
            println("[TaskListsViewController] event: \(ev.name), info: \(self.eventsDict[ev])")
        }
    }
    
    @IBAction func didSelectEvents(sender: AnyObject) {
        if !(mode == TaskListViewControllerMode.Events) {
            self.mode = TaskListViewControllerMode.Events
            self.tableView.reloadData()
        }
    }
    
    @IBAction func didSelectTaskLists(sender: AnyObject) {
        if !(mode == TaskListViewControllerMode.TaskLists) {
            self.mode = TaskListViewControllerMode.TaskLists
            self.tableView.reloadData()
        }
    }
    
}

extension TaskListsViewController: UITableViewDelegate, UITableViewDataSource {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (mode == TaskListViewControllerMode.TaskLists) {
            return self.listsDict.keys.array.count
        } else {
            return self.eventsDict.keys.array.count
        }
        
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if (mode == TaskListViewControllerMode.TaskLists) {
            return cellForTaskList(tableView, indexPath: indexPath)
        } else {
            return cellForEvent(tableView, indexPath: indexPath)
        }
    }
    
    func cellForTaskList(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("taskListCell", forIndexPath: indexPath) as UITableViewCell
        
        let taskLists: [TaskList!] = self.listsDict.keys.array as [TaskList!]
        
        if let taskList: TaskList! = taskLists[indexPath.row]  {
            
            if (!taskList.event.photoUrl.isEmpty) {
                var imageView: UIImageView! = cell.viewWithTag(1001) as UIImageView
                imageView.layer.cornerRadius = imageView.frame.size.width / 2;
                imageView.layer.masksToBounds = true;
                imageView.sd_setImageWithURL(NSURL.URLWithString(taskList.event.photoUrl), placeholderImage: nil)
            }
            
            var titleLabel: UILabel! = cell.viewWithTag(1002) as UILabel
            titleLabel.text = taskList.title
            
            if let (total, done, inc) = self.listsDict[taskList] as? (Int, Int, Int) {
                
                var statusLabel: UILabel! = cell.viewWithTag(1003) as UILabel
                statusLabel.text = "\(total)个任务, 完成了 \(done)个"
                
                var progressView: UIProgressView! = cell.viewWithTag(1004) as UIProgressView
                let pg: Float = Float(done) / Float(total)
                progressView.setProgress(pg, animated: true)
            }
        }
        return cell
    }
    
    func cellForEvent(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("eventsListCell", forIndexPath: indexPath) as UITableViewCell
        
        let events: [Event!] = self.eventsDict.keys.array as [Event!]
        
        if let event: Event! = events[indexPath.row]  {
            
            if (!event.photoUrl.isEmpty) {
                var imageView: UIImageView! = cell.viewWithTag(1001) as UIImageView
                imageView.layer.cornerRadius = imageView.frame.size.width / 2;
                imageView.layer.masksToBounds = true;
                imageView.sd_setImageWithURL(NSURL.URLWithString(event.photoUrl), placeholderImage: nil)
            }
            
            var nameLabel: UILabel! = cell.viewWithTag(1002) as UILabel
            nameLabel.text = event.name
            
            if let (total, done, inc) = self.eventsDict[event] as? (Int, Int, Int) {
                
                var statusLabel: UILabel! = cell.viewWithTag(1003) as UILabel
                statusLabel.text = "\(total)个任务, 完成了 \(done)个"
                
                var progressView: UIProgressView! = cell.viewWithTag(1004) as UIProgressView
                let pg: Float = Float(done) / Float(total)
                progressView.setProgress(pg, animated: true)
            }
            
            var removeBtn: UIButton! = cell.viewWithTag(1005) as UIButton
            removeBtn.addTarget(self, action: "removeEvent:", forControlEvents: UIControlEvents.TouchUpInside)
        }
        
        return cell
    }
    
    func removeEvent(sender: AnyObject) {
        println("[TaskListsViewController removeEvent] clicked")
        let btnPosition = sender.convertPoint(CGPointZero, toView: self.tableView)
        if let indexPath = self.tableView.indexPathForRowAtPoint(btnPosition) {
            let event = self.eventsDict.keys.array[indexPath.row]
            
            println("[TaskListsViewController removeEvent] clicked row: \(indexPath.row), event: \(event)")
            var tm = TaskManager.defaultManager
            tm.removeTasks(event: event)
            
            // refresh
            self.fetchListsDict()
            self.fetchEventsDict()
            self.tableView.reloadData()
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let height = self.cellHeight[mode]
        let cgf = CGFloat(height!)
        return cgf
    }
    
}