//
//  TaskManager.swift
//  jicraft
//
//  Created by JERRY LIU on 6/9/14.
//  Copyright (c) 2014 com.jicraft. All rights reserved.
//

import Foundation

struct TaskManagerKeys {
    static let tasks = "com.jicraft.todo.tasks.all"
    static let doneTasks = "com.jicraft.todo.tasks.done"
    static let events = "com.jicraft.todo.events"
}

class TaskManager: NSObject{
    
    var tasks: [Task] = []
    var doneTasks: [Task] = []
    var events: [Event] = []

    override init() {
        super.init()
        self.loadTasks()
    }

    // singleton manager
    class var defaultManager : TaskManager {
        struct Static {
            static let manager = TaskManager()
        }
        return Static.manager
    }

    func loadTasks() {

        let userDefaults = NSUserDefaults.standardUserDefaults()
        println("[TaskManager loadTasks] userDefault keys: \(userDefaults.dictionaryRepresentation().keys)")
        if let tasksObj: AnyObject = userDefaults.objectForKey(TaskManagerKeys.tasks) {
            if let tasksArray = NSKeyedUnarchiver.unarchiveObjectWithData(tasksObj as NSData) as? NSArray {
                println("[TaskManager loadTasks] tasks: \(tasksArray.count)")
                self.tasks = tasksArray as [Task]
            }
            
        }
        if let doneObj: AnyObject = userDefaults.objectForKey(TaskManagerKeys.doneTasks) {
            if let doneArray = NSKeyedUnarchiver.unarchiveObjectWithData(doneObj as NSData) as? NSArray{
                println("[TaskManager loadTasks] done: \(doneArray.count)")
                self.doneTasks = doneArray as [Task]
            }
        }
        if let eventsObj: AnyObject = userDefaults.objectForKey(TaskManagerKeys.events) {
            if let eventsArray = NSKeyedUnarchiver.unarchiveObjectWithData(eventsObj as NSData) as? NSArray {
                println("[TaskManager loadTasks] Events: \(eventsArray.count)")
                self.events = eventsArray as [Event]
            }
            
        }
    }
    
    func cleartasks() {
            
        self.tasks = []
        self.doneTasks = []
        self.saveTasks()
      
    }

    func saveTasks() {
        var userDefaults = NSUserDefaults.standardUserDefaults()
     //   var savedDict = userDefaults.dictionaryForKey(TaskManager.tasksKey)
        
        let tasksData = NSKeyedArchiver.archivedDataWithRootObject(self.tasks)
        userDefaults.setObject(tasksData, forKey:TaskManagerKeys.tasks)
        
        let doneTasksData = NSKeyedArchiver.archivedDataWithRootObject(self.doneTasks)
        userDefaults.setObject(doneTasksData, forKey: TaskManagerKeys.doneTasks)
        
        let eventsData = NSKeyedArchiver.archivedDataWithRootObject(self.events)
        userDefaults.setObject(eventsData, forKey:TaskManagerKeys.events)
        
        userDefaults.synchronize()
        
    }
    
    func addTasks(#event: Event) {
        event.setTaskListRelationships(true)
        self.events.append(event)
        
        var _addedTasks: [Task] = []
        var taskLists = event.taskLists
        for taskList in taskLists {
            _addedTasks += taskList.tasks
        }
        
        self.tasks += _addedTasks
        
        self.saveTasks()
    }
    
    func removeTasks(#event: Event) {
        var _filteredTasks: [Task] = []
        for t in self.tasks {
            if !(t.event == event) {
                _filteredTasks.append(t)
            }
        }
        
        var _filteredDone: [Task] = []
        for t in self.doneTasks {
            if !(t.event == event) {
                _filteredDone.append(t)
            }
        }
        
        self.events.remove(event)
        self.tasks = _filteredTasks
        self.doneTasks = _filteredDone
        
        self.saveTasks()
    }
    
    func getEventsDict() -> [Event: (totalTasks: Int, doneTasks: Int, tasks: Int)] {
        
        var dict: [Event: (totalTasks: Int, doneTasks: Int, tasks: Int)] = [:]
        
        var taskListCounts = self.getListsDict()
        let taskLists: [TaskList!] = taskListCounts.keys.array as [TaskList!]
        
        for list in taskLists {
            if let (listTotal, listDone, listTasks) = taskListCounts[list] as? (Int, Int, Int) {
                
                let event = list.event
                
                if let (total, done, tasks) = dict[event] {
                    // increment
                    dict[event] = (total+listTotal, done+listDone, tasks+listTasks)
                } else {
                    // return starting tuple
                    dict[event] = (listTotal, listDone, listTasks)
                }
            }
        }
        
        return dict
    }
    
    func getListsDict() -> [TaskList: (totalTasks: Int, doneTasks: Int, tasks: Int)] {
        
        var dict: [TaskList: (totalTasks: Int, doneTasks: Int, tasks: Int)] = [:]
        // setup tasklists
        for t in self.tasks {
            let taskList = t.taskList as TaskList
            if let (total, done, inc) = dict[taskList] {
                // increment
                dict[taskList] = (total+1, done, inc+1)
            } else {
                // return starting tuple
                dict[taskList] = (1, 0, 1)
            }
        }
        
        for t in self.doneTasks {
            let taskList = t.taskList as TaskList
            if let (total, done, inc) = dict[taskList] {
                // increment
                dict[taskList] = (total+1, done+1, inc)
            } else {
                // return starting tuple
                dict[taskList] = (1, 1, 0)
            }
        }
        
        return dict
    }
    
    // MARK: Task status
    func changeDone(task: Task){
        // add to doneTasks
        if (!self.doneTasks.contains(task)) {
            self.doneTasks.append(task)
        }
        
        // remove from tasks
        self.tasks.remove(task)
        
    }
    func changeUndone(task: Task) {
        // add to tasks
        if (!self.tasks.contains(task)) {
            self.tasks.append(task)
        }
        // remove from doneTasks
        self.doneTasks.remove(task)
    }
}

