//
//  DateHelperTests.swift
//  jicraft
//
//  Created by JERRY LIU on 5/9/14.
//  Copyright (c) 2014 com.jicraft. All rights reserved.
//

import Foundation

import UIKit

import XCTest

class DateHelperTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCstFromUtcDate() {
        let utcDateStr = "2014-09-01T00:00:00.000Z"
        let cst = DateHelper.cstFromUtc(utcDateStr)
        XCTAssertNotNil(cst, "CST conversion failed")
    }
    
    func testCstFromUtcNil() {
        let failUtc = "omg no way"
        let cst = DateHelper.cstFromUtc(failUtc)
        XCTAssert(cst == "", "expected to fail UTC format mask")
    }
    
    func testShortDate() {
        
        let calendar = NSCalendar.currentCalendar()
        var comp = NSDateComponents()
        comp.day = 15
        comp.month = 09
        comp.year = 2014
        
        var thisDate = calendar.dateFromComponents(comp)
        
        println("this date: \(thisDate)")
        
        let shortDate = DateHelper.shortDate(thisDate!)
        XCTAssertEqual("15/09", shortDate, "conversion incorrect")
        
    }
    
    func testCstDate() {
        let dateString = "2014-09-11 13:34:15"
        
        let calendar = NSCalendar.currentCalendar()
        var comp = NSDateComponents()
        comp.day = 11
        comp.month = 09
        comp.year = 2014
        comp.hour = 13
        comp.minute = 34
        comp.second = 15
        
        var thisDate : NSDate! = calendar.dateFromComponents(comp)
        println("this date: \(thisDate)")
        
        let dateFromHelper = DateHelper.cstDate(dateString)
        
        XCTAssertEqual(thisDate, dateFromHelper, "dates dont match")
        
    }
    
}
