//
//  Dictionary.swift
//  jicraft
//
//  Created by JERRY LIU on 6/9/14.
//  Copyright (c) 2014 com.jicraft. All rights reserved.
//

import Foundation

public extension Dictionary {

    /**
    Constructs a dictionary containing every [key: value] pair from self
    for which testFunction evaluates to true.

    :param: testFunction Function called to test each key, value
    :returns: Filtered dictionary
    */
    func filter (testFunction test: (Key, Value) -> Bool) -> Dictionary {
        
        var result = Dictionary()
        
        for (key, value) in self {
            if test(key, value) {
                result[key] = value
            }
        }
        
        return result
        
    }

}