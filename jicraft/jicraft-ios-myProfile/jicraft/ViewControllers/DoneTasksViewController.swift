//
//  DoneTasksViewController.swift
//  jicraft
//
//  Created by JERRY LIU on 5/9/14.
//  Copyright (c) 2014 com.jicraft. All rights reserved.
//

import Foundation

class DoneTasksViewController: UITableViewController  {

    var doneTasks:[Task]  = []
    var firstAppear:Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addObservers()
        self.tableView.contentInset =  UIEdgeInsetsMake(64, 0, 49, 0)
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(64, 0, 49, 0)
        
      
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        self.loadTasks()
        
        if(self.tableView.contentInset.top != 64) {
            self.tableView.contentInset =  UIEdgeInsetsMake(64, 0, 49, 0)
            self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(64, 0, 49, 0)
        }
    }
    
    func addObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didSwipeLeft:", name: DoneTaskCell.DoneSwipe.Left.toString(), object: nil)
    }
    
    func saveTasks() {
        let tm = TaskManager.defaultManager
        tm.doneTasks = self.doneTasks
        tm.saveTasks()
    }
    
     func loadTasks() {
        let tm = TaskManager.defaultManager
        tm.loadTasks()
        self.doneTasks = tm.doneTasks
        println("[DoneTasksViewController loadTasks] tasks: \(self.doneTasks.count)")
    }
        
     func didSwipeLeft(note: NSNotification) {
        let thisCell = note.object as DoneTaskCell
        let thisTask = thisCell.task as Task
        println("[DoneTasksViewController] didSwipeLeft: \(thisTask.title)")
        
        // add task back to tm
        var tm = TaskManager.defaultManager
        tm.tasks.append(thisTask)
        
        self.removeTaskCell(thisCell)
    }
    func removeTaskCell(taskCell: TaskCell!) {
        
        // save tasks data
        if let task = taskCell.task as Task? {
            println("[DoneTasksViewController removeTaskCell]: \(task.title)")
            self.doneTasks.remove(task)
            self.saveTasks()
        }
        
        // pop cell
        let thisTaskIndexPath = self.tableView.indexPathForCell(taskCell) as NSIndexPath!
        self.tableView.deleteRowsAtIndexPaths([thisTaskIndexPath], withRowAnimation: UITableViewRowAnimation.Top)
        
    }
}

extension DoneTasksViewController: UITableViewDataSource, UITableViewDelegate {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.doneTasks.count
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: DoneTaskCell! = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as DoneTaskCell
        
        let thisTask = self.doneTasks[indexPath.row] as Task
        cell.titleLabel.text = thisTask.title
        cell.task = thisTask

        return cell
    }
    override func tableView(tableView: UITableView,heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 45
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("[DoneTasksViewController tableView:didSelectRowAtIndexPath] row: \(indexPath.row)")
        let task = self.doneTasks[indexPath.row] as Task
        //        self.performSegueWithIdentifier("showTaskDetail", sender: task)
        let notification = NSNotification(name: "DoneTasksViewControllerDidSelect", object: task)
        NSNotificationCenter.defaultCenter().postNotification(notification)
    }

}
