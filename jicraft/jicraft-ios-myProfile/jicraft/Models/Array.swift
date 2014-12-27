//
//  Array.swift
//  jicraft
//
//  Created by JERRY LIU on 6/9/14.
//  Copyright (c) 2014 com.jicraft. All rights reserved.
//

import Foundation

 extension Array {


    /**
        Checks if self contains a list of items.
    
        :param: items Items to search for
        :returns: true if self contains all the items

        lifted from https://github.com/pNre/ExSwift
    */
    func contains <T: Equatable> (items: T...) -> Bool {
        return items.all { self.indexOf($0) >= 0 }
    }

    /**
        Checks if test returns true for all the elements in self
    
        :param: test Function to call for each element
        :returns: True if test returns true for all the elements in self
    */
    func all (test: (Element) -> Bool) -> Bool {
        for item in self {
            if !test(item) {
                return false
            }
        }

        return true
    }

    /**
        Index of the first occurrence of item, if found.
    
        :param: item The item to search for
        :returns: Index of the matched item or nil
    */
    func indexOf <U: Equatable> (item: U) -> Int? {
        if item is Element {
            return find(unsafeBitCast(self, [U].self), item)
        }

        return nil
    }
    
    /**
        Index of the first item that meets the condition.
    
        :param: condition A function which returns a boolean if an element satisfies a given condition or not.
        :returns: Index of the first matched item or nil
    */
    func indexOf (condition: Element -> Bool) -> Int? {
        for (index, element) in enumerate(self) {
            if condition(element) {
                return index
            }
        }
        
        return nil
    }

    /**
        Intersection of self and the input arrays.

        :param: values Arrays to intersect
        :returns: Array of unique values contained in all the dictionaries and self

        lifted from https://github.com/pNre/ExSwift
    */
    func intersection <U: Equatable> (values: [U]...) -> Array {

        var result = self
        var intersection = Array()

        for (i, value) in enumerate(values) {

            //  the intersection is computed by intersecting a couple per loop:
            //  self n values[0], (self n values[0]) n values[1], ...
            if (i > 0) {
                result = intersection
                intersection = Array()
            }

            //  find common elements and save them in first set
            //  to intersect in the next loop
            value.each { (item: U) -> Void in
                if result.contains(item) {
                    intersection.append(item as Element)
                }
            }

        }

        return intersection

    }

    /**
        Iterates on each element of the array.
    
        :param: call Function to call for each element

        lifted from https://github.com/pNre/ExSwift
    */
    func each (call: (Element) -> ()) {

        for item in self {
            call(item)
        }

    }

    /**
        Iterates on each element of the array with its index.
    
        :param: call Function to call for each element
    */
    func each (call: (Int, Element) -> ()) {

        for (index, item) in enumerate(self) {
            call(index, item)
        }

    }

    /**
        Deletes all the items in self that are equal to element.
    
        :param: element Element to remove
    */
    mutating func remove <U: Equatable> (element: U) {
        let anotherSelf = self

        removeAll(keepCapacity: true)

        anotherSelf.each {
            (index: Int, current: Element) in
            if current as U != element {
                self.append(current)
            }
        }
    }
}