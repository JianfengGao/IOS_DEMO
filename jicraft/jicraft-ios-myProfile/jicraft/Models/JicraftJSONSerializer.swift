//
//  JicraftJSONSerializer.swift
//  jicraft
//
//  Created by JERRY LIU on 24/9/14.
//  Copyright (c) 2014 com.jicraft. All rights reserved.
//

import Foundation

class JicraftJSONSerializer {
    
    
    class func dateStringForEvent(dict: Dictionary<String, AnyObject>, key: String) ->String {
        
        return DateHelper.dateStringForEvent(DateHelper.cstDate(dateStringFromDict(dict, key: key)))
    }
    
    class func abbrLocationStringFromLocationString(dict: Dictionary<String, AnyObject>, key: String) -> String{
        var abbrString = self.locationStringFromDict(dict, key: key)
        
        var str = abbrString.componentsSeparatedByString("区")
        var abbrStr = str[0] + "区"
        return abbrStr
    }
    
    class func abbrDateStringFromDateString(dict: Dictionary<String, AnyObject>, key: String) -> String {
        
        return DateHelper.shortDate(DateHelper.cstDate(dateStringFromDict(dict, key: key)))
        
    }
    
    class func keyExists(key: String, forArray strArray: [String]) -> Bool {
        let matchedKeys = strArray.filter{ $0 == key }
        return (matchedKeys.count > 0 ? true : false)
    }
    
    class func stringFromDict(dict: Dictionary<String, AnyObject>, key: String) -> String {
        if keyExists(key, forArray: dict.keys.array) {
            
            let v = dict[key] as AnyObject!
            if let _value = v as? String {
                return "\(_value)"
            } else {
                "omg not string"
            }
        } else {
            return ""
        }
        return ""
    }
    class func organizerStringFromDict(dict:Dictionary<String,AnyObject>,key:String) -> String {
        let organizer = stringFromDict(dict, key: key)
        return organizer
    }
    class func locationStringFromDict(dict:Dictionary<String,AnyObject>,key:String) -> String {
        let locationString = stringFromDict(dict, key: key)
        return locationString
    }
    class func photoURlStringFromDict(dict:Dictionary<String,AnyObject>,key:String) -> String{
        let photoURlStr = stringFromDict(dict, key: key)
        return photoURlStr
    }
    
    class func dateStringFromDict(dict:Dictionary<String, AnyObject>, key: String) -> String {
        let valueStr = stringFromDict(dict, key: key)
        return DateHelper.cstFromUtc(valueStr)
    }
    
    class func intFromDict(dict: Dictionary<String, AnyObject>, key: String) -> Int {
        if keyExists(key, forArray: dict.keys.array) {
            if let _value: AnyObject = dict[key] as AnyObject? {
                return Int(_value as NSNumber)
            }
        } else {
            return -1
        }
        return -1
    }
    
    class func priceStringFromDict(dict:Dictionary<String, AnyObject>, key: String) -> String {
        let valueStr = stringFromDict(dict, key: key) as NSString
        if valueStr.intValue == 0 {
            return "免费"
        }
        return "¥\(valueStr)"
    }
    
   
}
