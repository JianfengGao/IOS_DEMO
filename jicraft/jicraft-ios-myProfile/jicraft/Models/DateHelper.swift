//
//  DateHelper.swift
//  jicraft
//
//  Created by JERRY LIU on 5/9/14.
//  Copyright (c) 2014 com.jicraft. All rights reserved.
//

import Foundation

public class DateHelper {
    
    
    class func cstFromUtc(dateString: String!) -> String {
        
        if (dateString == "" || dateString == nil) {
            return ""
        }
        var utcDateFormatter = NSDateFormatter()
        utcDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        var date = utcDateFormatter.dateFromString(dateString)
        
        if (date == nil) {
            return ""
        }
        var cstDateFormatter = NSDateFormatter()
        cstDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        cstDateFormatter.timeZone = NSTimeZone(abbreviation: "CST") // China Standard Time
        var cstStr = cstDateFormatter.stringFromDate(date!)
        
        return cstStr
        
    }
    
    class func cstDate(dateString: String!) -> NSDate {
        // assume dateString is cst format
        
        var cstDateFormatter = NSDateFormatter()
        cstDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        cstDateFormatter.timeZone = NSTimeZone(abbreviation: "CST") // China Standard Time
        
        return cstDateFormatter.dateFromString(dateString)!
    }
    
    class func shortDate(date: NSDate) -> String {
        var shortDateFormatter = NSDateFormatter()
        shortDateFormatter.dateFormat = "MM/dd"
        
        return shortDateFormatter.stringFromDate(date)
    }
    
    class func dateStringForEvent(date:NSDate) ->String {
        var shortDateFormatter = NSDateFormatter()
        shortDateFormatter.dateFormat = "yyyy/MM/dd"
        
        return shortDateFormatter.stringFromDate(date)
    }
}