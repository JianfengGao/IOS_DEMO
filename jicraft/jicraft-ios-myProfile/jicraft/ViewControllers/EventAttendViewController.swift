//
//  EventAttendViewController.swift
//  jicraft
//
//  Created by JERRY LIU on 18/9/14.
//  Copyright (c) 2014 com.jicraft. All rights reserved.
//

import Foundation

@objc
protocol EventAttendViewControllerDelegate {
    func eventAttendViewControllerDidDismiss(sender: AnyObject)
}

class EventAttendViewController: UIViewController {
    
    @IBOutlet var posterImageView: UIImageView!
    var delegate: EventAttendViewControllerDelegate?
    
    @IBAction func dismissButton(sender: AnyObject) {
        self.delegate?.eventAttendViewControllerDidDismiss(self)
    }
   
}