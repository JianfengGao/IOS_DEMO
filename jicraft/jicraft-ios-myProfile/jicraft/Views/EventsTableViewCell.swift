//
//  EventsTableViewCell.swift
//  jicraft
//
//  Created by impressly on 14-9-10.
//  Copyright (c) 2014年 com.jicraft. All rights reserved.
//

import Foundation

class EventsTableViewCell : UITableViewCell {
    

    @IBOutlet var viewImage: UIImageView!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var startDateLabel: UILabel!
    @IBOutlet var origanizer: UILabel!
    @IBOutlet var cellView: UIView!

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.borderColor = UIColor.blackColor().CGColor
        self.layer.borderWidth = 1
        self.setImaveView()
        self.setOriganizerlabel()
        self.setStartDateLabel()
    }
   
    func setImaveView() {
        self.viewImage.contentMode = UIViewContentMode.ScaleToFill
       // self.viewImage.layer.borderColor = UIColor.blackColor().CGColor
       // self.viewImage.layer.borderWidth = 2.0
    }
    
    func setOriganizerlabel() {
        
    }
    func setStartDateLabel() {
        
    }
    // only use for imageView
    // imageView设置为圆角时，shouldRasterize应该设置为YES
    /*
    _imgvPhoto.layer.shadowColor = [UIColor blackColor].CGColor;
    _imgvPhoto.layer.shadowOffset = CGSizeMake(0, 0);
    _imgvPhoto.layer.shadowOpacity = 0.5;
    _imgvPhoto.layer.shadowRadius = 10.0;给iamgeview添加阴影 < wbr > 和边框
    //添加两个边阴影
    _imgvPhoto.layer.shadowColor = [UIColor blackColor].CGColor;
    _imgvPhoto.layer.shadowOffset = CGSizeMake(4, 4);
    _imgvPhoto.layer.shadowOpacity = 0.5;
    _imgvPhoto.layer.shadowRadius = 2.0;
    */
}