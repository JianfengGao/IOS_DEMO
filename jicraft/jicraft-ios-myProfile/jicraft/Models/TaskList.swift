//
//  TaskList.swift
//  jicraft
//
//  Created by JERRY LIU on 6/9/14.
//  Copyright (c) 2014 com.jicraft. All rights reserved.
//

import Foundation

class TaskList : NSObject, Hashable {
    
    var taskListId = Int()
    var title = String()
    var event: Event = Event()
    var tasks: [Task] = []
    
    override init () {
        super.init()
    }
    
    init (json jsonObject:Dictionary<String,AnyObject>) {
        
        self.title = JicraftJSONSerializer.stringFromDict(jsonObject, key: "title")
        self.tasks = TaskList.__taskArrayFromDict(jsonObject, key: "tasks")
    }
    
    init(coder decoder: NSCoder!) {
        self.taskListId = decoder.decodeIntegerForKey("taskListId")
        self.title = decoder.decodeObjectForKey("title") as String
        self.event = decoder.decodeObjectForKey("event") as Event
        self.tasks = decoder.decodeObjectForKey("tasks") as [Task]
    }
    
    func encodeWithCoder(encoder: NSCoder!) {
        encoder.encodeInteger(self.taskListId, forKey: "taskListId")
        encoder.encodeObject(self.title, forKey: "title")
        encoder.encodeObject(self.event, forKey: "event")
        encoder.encodeObject(self.tasks, forKey: "tasks")
    }
    
    // Hashable
    override var description: String {
        return "TaskList title: \(self.title), event: \(self.event.name), tasks: \(self.tasks.count)"
    }
    
    override var hashValue: Int {
        return self.description.hashValue
    }
    
    func setTaskRelationships() {
        for task in self.tasks {
            task.event = self.event
            task.taskList = self
        }
    }
        
    class func __taskArrayFromDict(dict: Dictionary<String, AnyObject>, key: String) -> [Task] {
        if JicraftJSONSerializer.keyExists(key, forArray: dict.keys.array) {
            if let _array: AnyObject = dict[key] as AnyObject? {
                
                return taskArrayFromJson(_array)
            }
        } else {
            return []
        }
        return []
    }
    
    class func taskArrayFromJson(jsonArrayObject:AnyObject!) -> [Task] {
        var taskArray: [Task] = []
        let _jsonArray = jsonArrayObject as [AnyObject]
        
        // do something with json
        for obj in _jsonArray {
            let _dict = obj as Dictionary<String, AnyObject>
            var _task = Task(json: _dict)
            taskArray.append(_task)
        }
        
        return taskArray
    }
}

func == (lhs: TaskList, rhs: TaskList) -> Bool {
    return lhs.hashValue == rhs.hashValue
}