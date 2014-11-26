//
//  AppDelegate.swift
//  DeviceUUID
//
//  Created by ihefe-JF on 14/11/25.
//  Copyright (c) 2014年 JG. All rights reserved.
//

import UIKit
import Security
import Foundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        //get the unique key if(presetnt)
        
        var retrieveuuid = SSKeychain.passwordForService("your app identifier", account: "user");
        if(retrieveuuid == nil) {
            
            //if this is the first app lanunch ,create key for device
            let uuid = self.createNewUUID();
            
            //save newly created key to keychain
            SSKeychain.setPassword(uuid, forService: "your app identifier", account: "user");
            
            retrieveuuid = uuid;
        }
        
        //test UIID is F499A974-970E-4157-A263-21DC638B61FF
        //print UUID
        NSLog("the app UUID is :\(retrieveuuid)");
        
        //check device version
        self.checkDeviceVersion();
        self.checkSystemVersion();
        self.platformString();
        return true
    }
    //create unique UUID
    func createNewUUID() -> String{
     
        var theUUID:CFUUIDRef = CFUUIDCreate(kCFAllocatorDefault);
        var string:CFStringRef  = CFUUIDCreateString(kCFAllocatorDefault,theUUID);
        
        return string as String;
    }
    
    //check device ios sdk version
    //method 1
    func checkDeviceVersion() -> Bool {
        
        var deviceVersionIsOk = false;
        
        if(floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
            //do something with ios 7
            
            NSLog("current device sdk version is : \(NSFoundationVersionNumber)");
        }
        
        return deviceVersionIsOk;
        
    }
    //method 2
    func checkSystemVersion() -> Bool {
        //For minimum deployment targets of iOS 8.0 or above, use NSProcessInfo operatingSystemVersion or isOperatingSystemAtLeastVersion
        let yosemite = NSOperatingSystemVersion(majorVersion: 3, minorVersion: 1, patchVersion: 2)
        
        let st =  NSProcessInfo().isOperatingSystemAtLeastVersion(yosemite);
        
        if(st) {
            //current device is >= (3.1.3)
        }else {
            //current device is < (3.1.3)
        }
        
        //For minimum deployment targets of iOS 7.1 or below, use compare with NSStringCompareOptions.NumericSearch on UIDevice systemVersion
        let minimumVersionString = "3.1.3"
        let versionComparison: NSComparisonResult = UIDevice.currentDevice().systemVersion.compare(minimumVersionString, options: NSStringCompareOptions.NumericSearch)
//        switch
//        case .OrderedSame, .OrderedDescending: {
//            //current version is >= (3.1.3)
//        }
//        case .OrderedAscending: {
//            //current version is < (3.1.3)
//        }
        return st;
    }
   func isIOS8OrAbove() -> Bool{
    
        let version8 = 1139.100000; // there is no def like NSFoundationVersionNumber_iOS_7_1 for ios 8 yet?
        NSLog("la version actual es \(NSFoundationVersionNumber)");
        if (NSFoundationVersionNumber >= version8){
            //current device is ios8 sdk
             return true;
        }
        return false;
    }
    
    //检测设备的类别
    
    func platformString() -> String {
        
        var platformString = "";
        
        let deviceType = UIDevice.currentDevice().model;
        
        if(UIDevice .currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone){
            //iphone device
            platformString = "iphone device";
        }else if(UIDevice .currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad){
            //ipad device
            platformString = "ipad device";
        }else {
            //other device
            platformString = "other device... ipod";
        }
        
        NSLog("current device is \(platformString) device type is \(deviceType)");
        return platformString;
    }
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

