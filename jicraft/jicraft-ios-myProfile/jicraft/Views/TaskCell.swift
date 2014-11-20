//
//  TaskCell.swift
//  jicraft
//
//  Created by JERRY LIU on 9/9/14.
//  Copyright (c) 2014 com.jicraft. All rights reserved.
//

import Foundation

class TaskCell: MCSwipeTableViewCell{
    
    @IBOutlet var titleLabel: UILabel!

    var task = Task()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.setupCell()
    }
    
    func setupCell() {
        let checkView = UIImageView(image: UIImage(named: "check"))
        let greenColor = UIColor(red: 85.0/255.0, green: 213.0/255.0, blue: 80.0/255.0, alpha: 1.0)
        
        let crossView = UIImageView(image: UIImage(named: "cross"))
        let redColor = UIColor(red: 232.0/255.0, green: 61.0/255.0, blue: 14.0/255.0, alpha: 1.0)
        
        self.setSwipeGestureWithView(checkView, color: greenColor, mode: MCSwipeTableViewCellMode.Exit, state: MCSwipeTableViewCellState.State1,
            completionBlock: {(cell: MCSwipeTableViewCell!, state: MCSwipeTableViewCellState, mode: MCSwipeTableViewCellMode)->Void in
                println("[TaskCell setSwipeGesture] left->right swipe")
        
                let notification = TaskCell.Swipe.Right.notification(object: self)
                NSNotificationCenter.defaultCenter().postNotification(notification)
        })
        
        self.setSwipeGestureWithView(crossView, color: redColor, mode: MCSwipeTableViewCellMode.Exit, state: MCSwipeTableViewCellState.State3,
            completionBlock: {(cell: MCSwipeTableViewCell!, state: MCSwipeTableViewCellState, mode: MCSwipeTableViewCellMode)->Void in
                println("[TaskCell setSwipeGesture] right->left swipe")
                
                let notification = TaskCell.Swipe.Left.notification(object: self)
                NSNotificationCenter.defaultCenter().postNotification(notification)
                
        })
    }
    
}
extension TaskCell {

    enum Swipe: Int {
        case Left, Right
        
        static let SwipeNames = [Left: "Jicraft.TaskCell.SwipeLeft", Right: "Jicraft.TaskCell.SwipeRight"]
        
        func toString() -> String {
            if let name = Swipe.SwipeNames[self] {
                return name
            } else {
                return ""
            }
        }
        
        func notification(#object: AnyObject) -> NSNotification {
            return NSNotification(name: self.toString(), object: object)
        }

        func notification() -> NSNotification {
            return NSNotification(name: self.toString(), object: nil)
        }


    }
}