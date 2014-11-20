//
//  RootViewController.swift
//  jicraft
//
//  Created by JERRY LIU on 2/9/14.
//  Copyright (c) 2014 com.jicraft. All rights reserved.
//

import Foundation

class RootViewController: UITabBarController {
    
    var shownWalkthrough = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let eventsRootViewController = UIStoryboard(name: "Events", bundle: nil).instantiateViewControllerWithIdentifier("EventsNav") as UINavigationController
        
        let todoRootViewController = UIStoryboard(name: "Todo", bundle: nil).instantiateViewControllerWithIdentifier("TodoNav") as UINavigationController

        let profileRootViewController = UIStoryboard(name: "Profile", bundle: nil).instantiateViewControllerWithIdentifier("ProfileNav") as UINavigationController
        
        
        self.viewControllers = [eventsRootViewController, todoRootViewController, profileRootViewController]
        
        let tabItems = self.tabBar.items as [UITabBarItem]
        tabItems[0].title = "Events"
        tabItems[1].title = "To-do"
        tabItems[2].title = "Profile"
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if !shownWalkthrough {
            showWalkthrough()
            shownWalkthrough = true
        }
//        if !userDefaults.boolForKey("com.jicraft.todo.walkthroughPresented") {
//        
//            showWalkthrough()
//        
//            userDefaults.setBool(true, forKey: "com.jicraft.todo.walkthroughPresented")
//            userDefaults.synchronize()
//        }
    }
    
    @IBAction func showWalkthrough(){
        
        // Get view controllers and build the walkthrough
        let stb = UIStoryboard(name: "Walkthrough", bundle: nil)
        let walkthrough = stb.instantiateViewControllerWithIdentifier("walk") as BWWalkthroughViewController
        let page_zero = stb.instantiateViewControllerWithIdentifier("walk0") as UIViewController
        let page_one = stb.instantiateViewControllerWithIdentifier("walk1") as UIViewController
        
        // Attach the pages to the master
        walkthrough.delegate = self
        walkthrough.addViewController(page_zero)
        walkthrough.addViewController(page_one)
        
        self.presentViewController(walkthrough, animated: true, completion: nil)
    }
    
}

// MARK: - Walkthrough delegate -
extension RootViewController: BWWalkthroughViewControllerDelegate {
    
    func walkthroughPageDidChange(pageNumber: Int) {
        println("[RootViewController walkthroughPageDidChange] Current Page \(pageNumber)")
    }
    
    func walkthroughCloseButtonPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

