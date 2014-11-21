//
//  creatNoteView.h
//  NoteBook
//
//  Created by ihefe-JF on 14/11/4.
//  Copyright (c) 2014年 ihefe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateNoteView : UIView

@property(nonatomic,strong) UITableView *creatNoteTableView;
@property(nonatomic,strong) UIButton *cancel;
@property(nonatomic,strong) UIButton *save;
@property(nonatomic,strong) UIButton *zoomInOut;
@property(nonatomic,strong) UIButton *syncButton;
//@property(nonatomic,strong) UITextField *noteTitle;

@property(nonatomic,strong) UIImageView *imageView;
@property(nonatomic,strong) UILabel *areaLabel;
@property(nonatomic,strong) UILabel *nameLabel;
@property(nonatomic,strong) UILabel *locationLabel;
@property(nonatomic,strong) UILabel *genderLabel;
@property(nonatomic,strong) UILabel *ageLabel;

@property(nonatomic,strong)UITextField *textField;
@property(nonatomic,strong)UIView *tempViewForPatient;
@end
