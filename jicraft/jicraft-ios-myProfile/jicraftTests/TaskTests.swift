//
//  TaskTests.swift
//  jicraft
//
//  Created by JERRY LIU on 6/9/14.
//  Copyright (c) 2014 com.jicraft. All rights reserved.
//

import Foundation
import UIKit
import XCTest

class TaskTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTask() {
        var task = Task()
        let taskTitle = "HelloWorld"
        task.title = taskTitle
        
        XCTAssert(taskTitle == task.title, "task.title not matched")
    }
    
    func testInitJson() {
        let json = ["title": "hello world", "detail": "pingpong"] as Dictionary<String, AnyObject>
        
        var task = Task(json: json)
        XCTAssert(task.title == "hello world", "name not set correctly")
        XCTAssert(task.detail == "pingpong", "desc not set correctly")
    }
    
    func testInitJsonNilDesc() {
        let json = ["title": "hello world"] as Dictionary<String, AnyObject>
        
        var task = Task(json: json)
        XCTAssertNotNil(task, "not init successfully")
        
    }

}
