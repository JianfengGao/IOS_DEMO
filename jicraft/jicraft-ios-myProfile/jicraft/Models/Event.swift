//
//  Event.swift
//  jicraft
//
//  Created by JERRY LIU on 5/9/14.
//  Copyright (c) 2014 com.jicraft. All rights reserved.
//

import Foundation

class Event : NSObject, Hashable {
    
    var eventId = Int()
    var name = String()
    var desc = String()
    var location = String()
    var organizer = String()
    var startDate = String()
    var endDate = String()
    var photoUrl = String()
    var price = String()
    var taskLists: [TaskList] = []
    var abbrDate = String()
    var abbrLocation = String()
    var dateForEvent = String()
    
    override init () {
        super.init()
    }
    
    init (json jsonObject:Dictionary<String,AnyObject>) {
    
        self.name = JicraftJSONSerializer.stringFromDict(jsonObject, key: "name")
        self.desc = JicraftJSONSerializer.stringFromDict(jsonObject, key: "desc")
        self.price = JicraftJSONSerializer.priceStringFromDict(jsonObject, key: "price")
        self.startDate = JicraftJSONSerializer.dateStringFromDict(jsonObject, key: "start_date")
        self.endDate = JicraftJSONSerializer.dateStringFromDict(jsonObject, key: "end_date")
        self.taskLists = Event.taskListFromDict(jsonObject, key: "task_lists")
        self.photoUrl = JicraftJSONSerializer.photoURlStringFromDict(jsonObject, key:"photo_url")
        self.location = JicraftJSONSerializer.locationStringFromDict(jsonObject, key:"location")
        self.organizer = JicraftJSONSerializer.organizerStringFromDict(jsonObject, key: "organizer")
        self.abbrLocation = JicraftJSONSerializer.abbrLocationStringFromLocationString(jsonObject, key: "location")
        self.abbrDate = JicraftJSONSerializer.abbrDateStringFromDateString(jsonObject, key: "start_date") + " 至 " + JicraftJSONSerializer.abbrDateStringFromDateString(jsonObject, key: "end_date")
        self.dateForEvent  = JicraftJSONSerializer.dateStringForEvent(jsonObject, key: "start_date") + " 至 " + JicraftJSONSerializer.dateStringForEvent(jsonObject, key: "end_date")
    }
    
    init(coder decoder: NSCoder!) {
        self.eventId = decoder.decodeIntegerForKey("eventId")
        self.name = decoder.decodeObjectForKey("name") as String
        self.desc = decoder.decodeObjectForKey("desc") as String
        self.price = decoder.decodeObjectForKey("price") as String
        self.startDate = decoder.decodeObjectForKey("startDate") as String
        self.endDate = decoder.decodeObjectForKey("endDate") as String
        self.photoUrl = decoder.decodeObjectForKey("photoUrl") as String
        self.location = decoder.decodeObjectForKey("location") as String
        self.organizer = decoder.decodeObjectForKey("organizer") as String
        self.taskLists = decoder.decodeObjectForKey("taskLists") as [TaskList]
    }
    
    func encodeWithCoder(encoder: NSCoder!) {
        encoder.encodeInteger(self.eventId, forKey: "eventId")
        encoder.encodeObject(self.name, forKey: "name")
        encoder.encodeObject(self.desc, forKey: "desc")
        encoder.encodeObject(self.price, forKey: "price")
        encoder.encodeObject(self.startDate, forKey: "startDate")
        encoder.encodeObject(self.endDate, forKey: "endDate")
        encoder.encodeObject(self.photoUrl, forKey: "photoUrl")
        encoder.encodeObject(self.location, forKey: "location")
        encoder.encodeObject(self.organizer, forKey: "organizer")
        encoder.encodeObject(self.taskLists, forKey: "taskLists")
    }
    
    
    // Hashable
    override var description: String {
        return "Event name: \(self.name), desc: \(self.desc), startDate: \(self.startDate), organizer: \(self.organizer), taskLists:\(self.taskLists.count)"
    }
    
    override var hashValue: Int {
        return self.description.hashValue
    }
    
    func setTaskListRelationships(setTaskRelationships: Bool) {
        for taskList in self.taskLists {
            taskList.event = self
            if (setTaskRelationships) {taskList.setTaskRelationships()}
        }
    }
    
    class func taskListFromDict(dict: Dictionary<String,AnyObject>,key: String) -> [TaskList] {
        var taskLists :[TaskList] = []
        if JicraftJSONSerializer.keyExists(key, forArray: dict.keys.array) {
            
            if  let tempTasksLists: AnyObject = dict[key] as AnyObject! {
              taskLists = self.taskListsArrayFromJson(tempTasksLists)
            }
        }
        return taskLists
    }
    
    class func taskListsArrayFromJson(jsonArrayObject:AnyObject!) -> [TaskList] {
        var taskListsArray: [TaskList] = []
        let _jsonArray = jsonArrayObject as [AnyObject]
        
        // do something with json
        for obj in _jsonArray {
            let _dict = obj as Dictionary<String, AnyObject>
            var _taskList = TaskList(json: _dict)
            taskListsArray.append(_taskList)
        }
        
        return taskListsArray
    }
    
    class func eventsArrayFromJson(jsonArrayObject:AnyObject!) -> [Event] {
        var eventsArray: [Event] = []
        let _jsonArray = jsonArrayObject as [AnyObject]
        
        // do something with json
        for obj in _jsonArray {
            let _dict = obj as Dictionary<String, AnyObject>
            var _event = Event(json: _dict)
            eventsArray.append(_event)
        }
    
        return eventsArray
    }
    
}

func == (lhs: Event, rhs: Event) -> Bool {
    return lhs.hashValue == rhs.hashValue
}