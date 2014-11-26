//
//  ViewController.swift
//  DeviceUUID
//
//  Created by ihefe-JF on 14/11/25.
//  Copyright (c) 2014年 JG. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var duplicateValuesArray = Array(arrayLiteral: "duo","duo","po","plO","ggh","pp","ggh");
    var removeDuplicateValuesArray = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.removeDuplicateValuesFromArray(duplicateValuesArray);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//可以设置设备屏幕支持的方向
//    override func supportedInterfaceOrientations() -> Int {
//        return UIInterfaceOrientationMask.Portrait as Int;
//    }
//    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
//        return UIInterfaceOrientation.Portrait
//    }

//移除数组中相同内容的值
    func removeDuplicateValuesFromArray(myArray: Array<String>) -> Array<String>{
        var tempArray:Array<String> = [];
        var tempOrderSet:NSOrderedSet;
        tempOrderSet = NSOrderedSet(array: myArray);
        tempArray = tempOrderSet.array as Array<String>;
        
        self.printArray(tempArray);
        return tempArray;
    }
    
    func printArray(myArray:Array<String>) {
        
        for tempString in myArray {
            println("\(tempString)\n");
        }
    }
}

