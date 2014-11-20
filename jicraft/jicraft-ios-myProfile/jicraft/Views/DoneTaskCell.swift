//
//  DoneTaskCell.swift
//  jicraft
//
//  Created by JERRY LIU on 11/9/14.
//  Copyright (c) 2014 com.jicraft. All rights reserved.
//

import Foundation

class DoneTaskCell: TaskCell {

    override func setupCell() {
        let listView = UIImageView(image: UIImage(named: "list"))
        let yellowColor = UIColor(red: 254.0/255.0, green:217.0/255.0, blue: 56.0/255.0, alpha:1.0)
        
        self.setSwipeGestureWithView(listView, color: yellowColor, mode: MCSwipeTableViewCellMode.Exit, state: MCSwipeTableViewCellState.State3,
            completionBlock: {(cell: MCSwipeTableViewCell!, state: MCSwipeTableViewCellState, mode: MCSwipeTableViewCellMode)->Void in
                println("[DoneTaskCell setSwipeGesture] right->left swipe")
                
                let notification = DoneTaskCell.DoneSwipe.Left.notification(object: self)
                NSNotificationCenter.defaultCenter().postNotification(notification)
        })
        
    }

}


extension DoneTaskCell {
    enum DoneSwipe: Int {
        case Left
        
        static let SwipeNames = [Left: "Jicraft.DoneTaskCell.SwipeLeft"]
        
        func toString() -> String {
            if let name = DoneSwipe.SwipeNames[self] {
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