//
//  Task.swift
//  jicraft
//
//  Created by JERRY LIU on 6/9/14.
//  Copyright (c) 2014 com.jicraft. All rights reserved.
//

import Foundation

class Task : NSObject {
    
    var taskId = Int()
    var title = String()
    var detail = String()
    var dueDate = String()
    var help = String()
    var taskList = TaskList()
    var event = Event()
    
    override init () {
        super.init()
    }
    
    init (json jsonObject:Dictionary<String,AnyObject>) {
        
        super.init()
        
        self.taskId = JicraftJSONSerializer.intFromDict(jsonObject, key: "id")
        self.title = JicraftJSONSerializer.stringFromDict(jsonObject, key: "title")
        self.detail = JicraftJSONSerializer.stringFromDict(jsonObject, key: "detail")
        self.dueDate = JicraftJSONSerializer.dateStringFromDict(jsonObject, key: "due_date")
        self.help = JicraftJSONSerializer.dateStringFromDict(jsonObject, key: "help")
    }
    
    init(coder decoder: NSCoder!) {
        
        super.init()
        
        self.taskId = decoder.decodeIntegerForKey("taskId")
        self.title = decoder.decodeObjectForKey("title") as String
        self.detail = decoder.decodeObjectForKey("detail") as String
        self.dueDate = decoder.decodeObjectForKey("dueDate") as String
        self.help = decoder.decodeObjectForKey("help") as String
        self.taskList = decoder.decodeObjectForKey("taskList") as TaskList
        self.event = decoder.decodeObjectForKey("event") as Event
    }
    
    func encodeWithCoder(encoder: NSCoder!) {
        encoder.encodeInteger(self.taskId, forKey: "taskId")
        encoder.encodeObject(self.title, forKey: "title")
        encoder.encodeObject(self.detail, forKey: "detail")
        encoder.encodeObject(self.dueDate, forKey: "dueDate")
        encoder.encodeObject(self.help, forKey: "help")
        encoder.encodeObject(self.taskList, forKey: "taskList")
        encoder.encodeObject(self.event, forKey: "event")
    }
        
    func dict() -> Dictionary<String, AnyObject> {
        return ["taskId": self.taskId,
                    "title": self.title,
                    "detail": self.detail,
                    "dueDate": self.dueDate,
                    "help": self.help,
                    "taskList": self.taskList,
                    "event": self.event]
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