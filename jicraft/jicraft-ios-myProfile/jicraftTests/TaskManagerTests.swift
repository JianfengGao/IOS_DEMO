//
//  TaskManagerTests.swift
//  jicraft
//
//  Created by JERRY LIU on 7/9/14.
//  Copyright (c) 2014 com.jicraft. All rights reserved.
//

import Foundation
import UIKit
import XCTest

class TaskManagerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTaskManager() {
        var manager = TaskManager.defaultManager
        XCTAssertNotNil(manager, "singleton manager not instantiated")
    }
    
    func testLoadTasks() {
        var manager = TaskManager.defaultManager
        manager.loadTasks()
        XCTAssertNotNil(manager.tasks, "tasks array nil")
        XCTAssertNotNil(manager.doneTasks, "done tasks array nil")
    }
    
    func testSaveTasks() {
        var manager = TaskManager.defaultManager
        manager.saveTasks()

        // check userDefaults
        let userDefaults = NSUserDefaults.standardUserDefaults()
//        XCTAssertNotNil(userDefaults.dictionaryForKey(TaskManager.tasksKey), "tasks not saved")
//        XCTAssertNotNil(userDefaults.dictionaryForKey(TaskManager.doneTasksKey), "done tasks not saved")
    }
    
    func testChangeDone() {
        var manager = TaskManager.defaultManager
        var task = Task()
        manager.tasks = [task]
        
        let doneCount = manager.doneTasks.count
        let taskCount = manager.tasks.count
        
        manager.changeDone(task)
        
        XCTAssert(manager.tasks.count - taskCount == -1, "task count should decrease by 1")
        XCTAssert(manager.doneTasks.count - doneCount == 1, "doneTasks should inc by 1")
    }
    
    func testChangeUndone() {
        var manager = TaskManager.defaultManager
        var task = Task()
        manager.doneTasks = [task]
        
        let doneCount = manager.doneTasks.count
        let taskCount = manager.tasks.count
        
        manager.changeUndone(task)
        
        let dDone = manager.doneTasks.count
        let dTask = manager.tasks.count
        
        XCTAssert(dDone - doneCount == -1, "doneTask count should decr by 1, starting: \(doneCount), ending: \(dDone)")
        XCTAssert(dTask - taskCount == 1, "taskCount should incr by 1, starting: \(taskCount), ending: \(dTask)")
    }
    
    func testChangeDoneForDonetask() {
        var manager = TaskManager.defaultManager
        var task = Task()
        manager.doneTasks = [task]
        
        let doneCount = manager.doneTasks.count
        let taskCount = manager.tasks.count
        
        manager.changeDone(task)
        
        let dDone = manager.doneTasks.count
        let dTask = manager.tasks.count
        
        XCTAssert(dTask - taskCount == 0, "should not move to tasks")
        XCTAssert(dDone - doneCount == 0, "should already be done, start count: \(doneCount), end count: \(dDone)")
    }
    
    func testChangeUndoneForTask() {
        var manager = TaskManager.defaultManager
        var task = Task()
        manager.tasks = [task]
        
        let doneCount = manager.doneTasks.count
        let taskCount = manager.tasks.count
        
        manager.changeUndone(task)
        
        let dDone = manager.doneTasks.count
        let dTask = manager.tasks.count
        
        XCTAssert(dDone - doneCount == 0, "should not move to doneTasks")
        XCTAssert(dTask - taskCount == 0, "should already be tasks, start count: \(taskCount), end count: \(dTask)")
    }
    
    
}
