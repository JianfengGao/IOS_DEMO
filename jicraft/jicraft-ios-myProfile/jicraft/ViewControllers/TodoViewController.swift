//
//  TodoViewController.swift
//  jicraft
//
//  Created by JERRY LIU on 5/9/14.
//  Copyright (c) 2014 com.jicraft. All rights reserved.
//

import Foundation

class TodoViewController : UIViewController {
    
    @IBOutlet var containerView: UIView!
    
    var segmentedControl = UISegmentedControl()
    
    var currentIndex:Int = 1
    var viewController = UIViewController()
    
    override init() {
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSegmentedControl()
        self.addObservers()
        
        // navbar background image
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "bora-bora-gradient"), forBarMetrics: UIBarMetrics.Default)
        self.resetViewControllers()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
      
//        println("[TodoViewController viewWillAppear] containerView total: \(self.containerView.subviews.count), subviews: \(self.containerView.subviews)")
    }
    
    func addObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didSelectTask:", name: "TasksViewControllerDidSelect", object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "didSelectDoneTask:", name: "DoneTasksViewControllerDidSelect", object: nil)
    }

    func resetViewControllers() {
        // reset index
        self.segmentedControl.selectedSegmentIndex = 1
        self.currentIndex = 1
        
        // hide viewcontroller
        self.hideContentController(contentVC: self.viewController)
        
        // display task viewcontroller
        let tasks = UIStoryboard(name: "Todo", bundle: nil).instantiateViewControllerWithIdentifier("Tasks") as TasksViewController
        self.viewController = tasks
        self.displayContentController(contentVC: self.viewController)
    }
    
    // MARK: SegmentControl
    func setupSegmentedControl() {
        self.segmentedControl = UISegmentedControl(items: [" 清单 ", " 任务 ", " 完成 "])
        self.segmentedControl.addTarget(self, action: "segmentedControlDidChange:", forControlEvents: UIControlEvents.ValueChanged)
        self.navigationItem.titleView = self.segmentedControl
    }
    
    func segmentedControlDidChange(segmentControl: UISegmentedControl) {
        
        let index = segmentedControl.selectedSegmentIndex
        if (self.currentIndex == index) {
            return
        }
        self.performShift(self.currentIndex, selectedIndex: index)
        self.currentIndex = index
    }
    
    // MARK: Content ViewController control
    func displayContentController(contentVC content:UIViewController) {
     
        self.addChildViewController(content)
        content.view.frame = self.containerView.frame
        self.containerView.addSubview(content.view)
        content.didMoveToParentViewController(self)
        
        self.viewController = content
    }
    
    func hideContentController(contentVC content:UIViewController) {
        content.willMoveToParentViewController(nil)
        content.view.removeFromSuperview()
        content.removeFromParentViewController()
    }
    
    // MARK: custom shift segues, pre-defined
    func performShiftList() {
        // list is on most left, so it's a right shift
        let listVC = UIStoryboard(name: "Todo", bundle: nil).instantiateViewControllerWithIdentifier("TaskLists") as TaskListsViewController
        self.performShiftRight(listVC)
    }
    
    func performShiftDone() {
        // done is on most right, so it's a left shift
        let doneVC = UIStoryboard(name: "Todo", bundle: nil).instantiateViewControllerWithIdentifier("DoneTasks") as DoneTasksViewController
        self.performShiftLeft(doneVC)
    }
    
    func performShift(currentIndex: Int, selectedIndex: Int) {
        if (selectedIndex == 2) {
            self.performShiftDone()
        } else if (selectedIndex == 0) {
            self.performShiftList()
        } else if (selectedIndex == 1 && currentIndex == 0) {
            let taskVC = UIStoryboard(name: "Todo", bundle: nil).instantiateViewControllerWithIdentifier("Tasks") as TasksViewController
            self.performShiftLeft(taskVC)
        } else if (selectedIndex == 1 && currentIndex == 2) {
            let taskVC = UIStoryboard(name: "Todo", bundle: nil).instantiateViewControllerWithIdentifier("Tasks") as TasksViewController
            self.performShiftRight(taskVC)
        }
    }
    
    
    // MARK: custom shift segues
    func performShiftLeft(destinationViewController: UIViewController) {
        let w = self.view.frame.width
        performShift(destinationViewController, dx: -w)
    }
    
    func performShiftRight(destinationViewController: UIViewController) {
        let w = self.view.frame.width
        performShift(destinationViewController, dx: w)
    }
    
    // dx = x offset for self.view to shift. -100 = 100px to left, +100 = 100px to right
    func performShift(destinationViewController: UIViewController, dx: CGFloat) {
        let duration = 0.3
        
        let y_offset = self.containerView.frame.origin.y
        let w = self.containerView.frame.width
        let h = self.containerView.frame.height
        let offsetFrame = CGRectMake(dx, y_offset, w, h)
        
        var destinationView = destinationViewController.view as UIView
        destinationView.frame = CGRectOffset(self.containerView.frame, -dx, 0)
        
//        println("[TodoViewController performShift]  destinationView.frame: \(destinationView.frame), self.containerView.frame: \(self.containerView.frame), offsetFrame: \(offsetFrame)")
        UIView.animateWithDuration(duration, animations: {()->Void in
            
            destinationView.frame = self.view.frame
            
            }, completion: {(finished: Bool)->Void in
                
                // display in containerview
                self.hideContentController(contentVC: self.viewController)
                self.displayContentController(contentVC: destinationViewController)
                
//                println("[TodoViewController performShift] ==animation completed== containerView total: \(self.containerView.subviews.count), subviews: \(self.containerView.subviews)")
        })
    }
    
    // MARK: Notifications
    func didSelectTask(note: NSNotification) {
        let task = note.object as Task
        self.performSegueWithIdentifier("detail", sender: task)
    }

    func didSelectDoneTask(note: NSNotification){
        let task = note.object as Task
        self.performSegueWithIdentifier("doneDetail", sender: task)
    }

    // MARK: Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "detail") {
            println("[TodoViewController prepareForSegue] detail")
            var vc = segue.destinationViewController as TaskDetailViewController
            vc.task = sender as Task
        }
        if (segue.identifier == "doneDetail") {
            println("[TodoViewController prepareForSegue] detail")
            var vc = segue.destinationViewController as TaskDetailViewController
            vc.task = sender as Task
            vc.isDone = true
        }
        
    }
    
    
    
    //MARK: for show attend events
    
    var attendBtn:UIButton?
    
    func addShowEventsListButton() {
        
        // create help button
        self.navigationController?.setToolbarHidden(false, animated: true)
        
        self.attendBtn = UIButton.buttonWithType(UIButtonType.Custom) as? UIButton
        self.attendBtn!.setTitle("展示已经参加的活动", forState: UIControlState.Normal)
        
        // set target
        self.attendBtn!.addTarget(self, action:"handleAttendBtn:", forControlEvents: UIControlEvents.TouchUpInside)
        
        // button position -- cover the whole toolbar
        let toolbarFrame = self.navigationController?.toolbar.frame as CGRect!
        
        self.attendBtn!.frame = CGRectMake(toolbarFrame.origin.x, toolbarFrame.origin.y - 6 , toolbarFrame.size.width, 51)
        self.attendBtn!.backgroundColor = UIColor.redColor()
        
        self.attendBtn!.alpha = 0.6
        // add button to subview
        self.navigationController?.view.addSubview(self.attendBtn!)
        self.navigationController?.setToolbarHidden(true, animated: false)
    }
    
    func handleAttendBtn(sender: UIButton) {
        
        self.performSegueWithIdentifier("showEventsList", sender: nil)
        
    }
}
