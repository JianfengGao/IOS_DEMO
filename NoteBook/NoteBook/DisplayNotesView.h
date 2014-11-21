//
//  DisplayNotesView.h
//  NoteBook
//
//  Created by ihefe-JF on 14/11/5.
//  Copyright (c) 2014年 ihefe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchBar.h"
@interface DisplayNotesView : UIView
@property(strong,nonatomic) SearchBar *searchBar;
@property(strong,nonatomic) UITableView *showNoteTitlesTable;
@property(strong,nonatomic) UITableView *showNoteDetailTable;

@property(strong,nonatomic) UILabel *titleLabel;
@property(strong,nonatomic) UILabel *creatDateLabel;
@property(strong,nonatomic) UILabel *areaLabel;
@property(strong,nonatomic) UILabel *locationLabel;
@property(strong,nonatomic) UILabel *nameLabel;
@property(strong,nonatomic) UILabel *ageLabel;
@property(strong,nonatomic) UILabel *genderLabel;

@property(nonatomic) CGFloat patientInfoHeight;

@end
