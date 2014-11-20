//
//  EventViewControllerTests.swift
//  jicraft
//
//  Created by impressly on 14-9-9.
//  Copyright (c) 2014年 com.jicraft. All rights reserved.
//

import Foundation

import UIKit
import XCTest

class EventsDetailViewControllerTests: XCTestCase {
    
    var vc = EventsDetailViewController()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // initiate EventViewController
        var storyboard: UIStoryboard = UIStoryboard(name: "Events", bundle: NSBundle(forClass: self.dynamicType))
//        var eventsDetailVC = storyboard.instantiateViewControllerWithIdentifier("EventsDetail") as EventsDetailViewController!
        
//        eventsDetailVC.event = setupEvent()
        
//        self.vc = eventsDetailVC
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        self.vc = EventsDetailViewController()
    }
    
    func testVC() {
        XCTAssertNotNil(self.vc, "vc not instantiated, vc: \(vc)")
    }
    
//    func testAddTasks() {
//        
//        var tm = TaskManager.defaultManager
//        let initial_task_count = tm.tasks.count
//        
//        self.vc.addTasks()
//        
//        let after_task_count = tm.tasks.count
//        // check TaskManager for tasks
//        XCTAssert((after_task_count -  initial_task_count)  > 0 , "tasks still empty")
//    }

    func setupEvent() -> Event {
        var event = Event()
        event.name = "Test Event"
        
        var aTaskList = TaskList()
        aTaskList.title = "this task list"
        
        for i in [1,2,3,4,5] {
            var _task = Task()
            _task.title = "test task \(i)"
            aTaskList.tasks.append(_task)
        }
        
        event.taskLists.append(aTaskList)
        
        return event
    }

}