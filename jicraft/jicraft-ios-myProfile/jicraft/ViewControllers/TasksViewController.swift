//
//  TasksViewController.swift
//  jicraft
//
//  Created by JERRY LIU on 5/9/14.
//  Copyright (c) 2014 com.jicraft. All rights reserved.
//

import Foundation

class TasksViewController : UITableViewController  {
    
    var tasks: [Task] = []
    var firstAppear:Int = 1

    override init() {
        super.init()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addObservers()
    }
    
    override func viewWillAppear(animated: Bool) {

        super.viewWillAppear(animated)
        self.loadTasks()
        
        if(self.firstAppear == 1) {
            self.firstAppear++;
        }else {
           self.tableView.contentInset =  UIEdgeInsetsMake(64, 0, 49, 0)
           self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(64, 0, 49, 0)
        }
        self.setupBackgroundView()
        self.tableView.reloadData()
    }
    func addObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didSwipeLeft:", name: TaskCell.Swipe.Left.toString(), object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didSwipeRight:", name: TaskCell.Swipe.Right.toString(), object: nil)
    }
    
    func setupBackgroundView() {
        self.tableView.backgroundColor = UIColor.clearColor()
        
        if self.tasks.count == 0 {
            self.tableView.backgroundView = UIImageView(image: UIImage(named: "empty_todo"))
            
            //       self.tableView.addSubview(UIImageView(image: UIImage(named: "empty_todo")))
        } else {
            self.tableView.backgroundView = nil
        }

    }

    func saveTasks() {
        let tm = TaskManager.defaultManager
        tm.tasks = self.tasks
        tm.saveTasks()
    }
    
    func loadTasks() {
        let tm = TaskManager.defaultManager
        tm.loadTasks()
        self.tasks = tm.tasks
        println("[TasksViewController loadTasks] tasks: \(self.tasks.count)")
    }

    func didSwipeLeft(note: NSNotification) {
        
        let thisCell = note.object as TaskCell
        self.removeTaskCell(thisCell)
    }

    func didSwipeRight(note: NSNotification) {
        
        let thisCell = note.object as TaskCell
        let thisTask = thisCell.task as Task
        println("[TasksViewController] didSwipeRight: \(thisTask.title)")

        // add task to done tasks
        var tm = TaskManager.defaultManager
        tm.doneTasks.append(thisTask)
        
        self.removeTaskCell(thisCell)

    }
    
    func removeTaskCell(taskCell: TaskCell!) {
        
        // save tasks data
        if let task = taskCell.task as Task? {
            println("[TasksViewController removeTaskCell]: \(task.title)")
            self.tasks.remove(task)
            self.saveTasks()
        }
        
        // pop cell
        let thisTaskIndexPath = self.tableView.indexPathForCell(taskCell) as NSIndexPath!
        self.tableView.deleteRowsAtIndexPaths([thisTaskIndexPath], withRowAnimation: UITableViewRowAnimation.Top)
    }
    
}

extension TasksViewController: UITableViewDataSource, UITableViewDelegate {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks.count
    }
     override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: TaskCell! = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as TaskCell

        let thisTask = self.tasks[indexPath.row] as Task
        cell.titleLabel.text = thisTask.title
        cell.task = thisTask

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("[TasksViewController tableView:didSelectRowAtIndexPath] row: \(indexPath.row)")
        let task = self.tasks[indexPath.row] as Task
//        self.performSegueWithIdentifier("showTaskDetail", sender: task)
        let notification = NSNotification(name: "TasksViewControllerDidSelect", object: task)
        NSNotificationCenter.defaultCenter().postNotification(notification)
    }
    
}