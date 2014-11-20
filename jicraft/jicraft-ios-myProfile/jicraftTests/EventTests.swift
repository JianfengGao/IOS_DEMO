//
//  EventTests.swift
//  jicraft
//
//  Created by JERRY LIU on 5/9/14.
//  Copyright (c) 2014 com.jicraft. All rights reserved.
//

import Foundation

import UIKit
import XCTest

class EventTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEvent() {
        var event = Event()
        let eventName = "HelloWorld"
        event.name = eventName
        
        XCTAssert(eventName == event.name, "event.name not matched")
    }
    
    func testEventsArrayFromJson() {
        let jsonResponse = [
                ["name": "hello world", "desc": "ping pong"],
                ["name": "nba", "desc": "pingpong"]
            ] as  [Dictionary<String, AnyObject>]
        println("[testInitJson] jsonResponse: \(jsonResponse)")
        
        var eventsArray = Event.eventsArrayFromJson(jsonResponse) as [Event]
        XCTAssert(eventsArray.count == 2, "incorrect element count")
        XCTAssert(eventsArray[0].name == "hello world", "name incorrect")
    }
    
    func testInitJson() {
        let json = ["name": "hello world", "desc": "pingpong"] as Dictionary<String, AnyObject>
        
        var event = Event(json: json)
        XCTAssert(event.name == "hello world", "name not set correctly")
        XCTAssert(event.desc == "pingpong", "desc not set correctly")
    }
    
    func testInitJsonNilDesc() {
        let json = ["name": "hello world"] as Dictionary<String, AnyObject>
        
        var event = Event(json: json)
        XCTAssertNotNil(event, "not init successfully")
        
    }
    
    func testInitJsonIntPrice() {
        let json = ["price": 283] as Dictionary<String, AnyObject>
        
        var event = Event(json: json)
        XCTAssertNotNil(event, "not init successfully")
        XCTAssertEqual("¥283", event.price, "price incorrect")
    }
    
    func testSetTaskRelationships() {
        var event = Event()
        var taskList = TaskList()
        var task = Task()
        
        taskList.tasks = [task]
        event.taskLists = [taskList]
        
        event.setTaskListRelationships(true)
        XCTAssertEqual(event, taskList.event, "taskList.event relationship not set")
        XCTAssertEqual(taskList, task.taskList, "task.taskList relationship not set")
        XCTAssertEqual(event, task.event, "task.event relationship not set")
    }
    
}
