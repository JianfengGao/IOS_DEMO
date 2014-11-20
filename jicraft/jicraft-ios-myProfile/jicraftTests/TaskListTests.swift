//
//  TaskListTests.swift
//  jicraft
//
//  Created by JERRY LIU on 6/9/14.
//  Copyright (c) 2014 com.jicraft. All rights reserved.
//

import Foundation
import UIKit
import XCTest

class TaskListTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTaskList() {
        var taskList = TaskList()
        let taskListTitle = "HelloWorld"
        taskList.title = taskListTitle
        
        XCTAssert(taskListTitle == taskList.title, "taskList.title not matched")
    }
    
    func testInitJson() {
        let json = ["title": "hello world", "desc": "pingpong"] as Dictionary<String, AnyObject>
        
        var taskList = TaskList(json: json)
        XCTAssert(taskList.title == "hello world", "name not set correctly")
//        XCTAssert(taskList.detail == "pingpong", "desc not set correctly")
    }
    
    func testInitJsonNilDesc() {
        let json = ["title": "hello world"] as Dictionary<String, AnyObject>
        
        var taskList = TaskList(json: json)
        XCTAssertNotNil(taskList, "not init successfully")
        
    }
    
    func testTaskArrayFromJson() {
        let json = [
                ["title": "task 1", "desc": "do this"],
                ["title": "task 2", "desc": "do that"]
            ]
        var tasks = TaskList.taskArrayFromJson(json)
        XCTAssert(tasks.count == 2, "incorrect task count")
        XCTAssert(tasks[0].title == "task 1", "title incorrect")
    }
    
    func testInitJsonTasks() {
        let jsonResponse = [
            "title": "hello title",
            "tasks": [
                ["title": "task 1", "desc": "do this"],
                ["title": "task 2", "desc": "do that"]
            ]
        ] as Dictionary<String, AnyObject>
        
        var taskList = TaskList(json: jsonResponse)
        XCTAssertNotNil(taskList.tasks, "tasks array nil")
        XCTAssert(taskList.tasks.count == 2 , "task count incorrect")
        XCTAssert(taskList.tasks[0].title == "task 1", "title failed")
    }
    
    func testSetTaskRelationships() {
        var taskList = TaskList()
        var task = Task()
        taskList.tasks = [task]
        taskList.setTaskRelationships()
        XCTAssertEqual(taskList, task.taskList, "taskList relationship not set")
    }
    
}
