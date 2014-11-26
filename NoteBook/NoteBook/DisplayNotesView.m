//
//  DisplayNotesView.m
//  NoteBook
//
//  Created by ihefe-JF on 14/11/5.
//  Copyright (c) 2014年 ihefe. All rights reserved.
//

#import "DisplayNotesView.h"

@interface DisplayNotesView()
@property(nonatomic) CGRect viewFrame;
@end
@implementation DisplayNotesView

//static CGFloat searchbarWidth = 320;
static CGFloat searchbarHeight  = 45;
static NSString *fontName = @"HelveticaNeue";
static CGFloat patientInfoHeight = 45;
static CGFloat gap1 = 2;
static CGFloat gap2 = 1;
static CGFloat gap3 = 2;
static CGFloat fontHeight = 17;
static CGFloat offsetForLabel = 5;
#define TitleColor  [UIColor orangeColor]
#define PatientInfoTextColor  [UIColor colorWithRed:145/255.0 green:52.0/255.0 blue:194/255.0 alpha:1]
//#define ViewForPatientInfoColor [UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:250/255.0 alpha:1]
#define TableViewBackgroundColor [UIColor colorWithRed:241.0/255.0 green:250.0/255.0 blue:250/255.0 alpha:1]
-(instancetype)initWithFrame:(CGRect)frame
{
    CGFloat frameWidth = frame.size.width;
    CGFloat frameHeight = frame.size.height;
    self.viewFrame = frame;
    //portrait or landscape ，横屏和竖屏只能支持一种
//    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
//    if(UIInterfaceOrientationIsLandscape(interfaceOrientation)){
//        frameWidth = frame.size.height;
//        frameHeight = frame.size.width;
//    }else {
//         frameWidth = frame.size.width;
//         frameHeight = frame.size.height;
//    }
    CGFloat searchbarWidth = frameWidth * 1/3 +20;
    self = [super initWithFrame:frame];
    if(self){
        
        //set appearance
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        //self.layer.borderColor = [UIColor colorWithRed:255/255.0 green:250/255.0 blue:252/255.0 alpha:0.8].CGColor;
        self.layer.borderColor = [UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:250/255.0 alpha:1].CGColor;
        
        self.layer.borderWidth = 2;
        self.backgroundColor = [UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:250/255.0 alpha:1];
        
        //search bar
        _patientInfoHeight = patientInfoHeight + gap3;
        
        _searchBar = [[SearchBar alloc] initWithFrame:CGRectMake(0, 0, searchbarWidth, searchbarHeight)];
        
        [self addSubview:_searchBar];
        
        //show Title name table
        _showNoteTitlesTable = [[UITableView alloc] initWithFrame:CGRectMake(0, searchbarHeight+gap1, searchbarWidth, frameHeight - searchbarHeight - gap1) style:UITableViewStylePlain];
        _showNoteTitlesTable.backgroundColor = TableViewBackgroundColor;
        //_showNoteTitlesTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _showNoteTitlesTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _showNoteDetailTable.separatorInset = UIEdgeInsetsZero;
        [self addSubview:_showNoteTitlesTable];
        
        //show note detail table
        
        _showNoteDetailTable = [[UITableView alloc] initWithFrame:CGRectMake(searchbarWidth + gap1, searchbarHeight + patientInfoHeight + gap3+ gap2, frameWidth - searchbarWidth - 2, frameHeight - (searchbarHeight + patientInfoHeight + gap3+ gap2)) style:UITableViewStylePlain];
        _showNoteDetailTable.backgroundColor = TableViewBackgroundColor;
       // _showNoteDetailTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _showNoteDetailTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _showNoteDetailTable.alpha = 1;
        _showNoteDetailTable.separatorInset = UIEdgeInsetsZero;
        //[self addSubview:_showNoteDetailTable];
        
        //other views
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(searchbarWidth + gap1, 0, frameWidth - searchbarWidth - 2, searchbarHeight)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont fontWithName:fontName size:22];
        //_titleLabel.text = @"ti";
        _titleLabel.textColor =TitleColor;
        _titleLabel.backgroundColor = [UIColor whiteColor];
        [self addSubview:_titleLabel];
        
        _creatDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(searchbarWidth + gap1 + offsetForLabel, 20, frameWidth/2, 23)];
        _creatDateLabel.font = [UIFont fontWithName:fontName size:12];
        //_creatDateLabel.text = @"date";
        _creatDateLabel.textAlignment = NSTextAlignmentJustified;
        _creatDateLabel.textColor =TitleColor;
        [self addSubview:_creatDateLabel];

        
        //
        UIView *viewForPatientInfo = [[UIView alloc] initWithFrame:CGRectMake(searchbarWidth + gap1 , searchbarHeight + gap3, frameWidth - searchbarWidth - 2, patientInfoHeight)];
        viewForPatientInfo.backgroundColor = [UIColor whiteColor];
        
         [self addSubview:viewForPatientInfo];
        
        _areaLabel = [[UILabel alloc] initWithFrame:CGRectMake(searchbarWidth + gap1 + offsetForLabel, searchbarHeight + gap3, (frameWidth - searchbarWidth - 2)/7, patientInfoHeight)];
        _areaLabel.font = [UIFont fontWithName:fontName size:fontHeight];
        _areaLabel.textAlignment = NSTextAlignmentJustified;
        _areaLabel.textColor = PatientInfoTextColor;
       // _areaLabel.text = @"area";
        [self addSubview:_areaLabel];
        
        _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(searchbarWidth + gap1 + offsetForLabel+ (frameWidth - searchbarWidth - 2)/7, searchbarHeight + gap3,(frameWidth - searchbarWidth - 2)/7, patientInfoHeight)];
        _locationLabel.font = [UIFont fontWithName:fontName size:fontHeight];
        _locationLabel.textColor = PatientInfoTextColor;
        _locationLabel.textAlignment = NSTextAlignmentJustified;
        //_locationLabel.text = @"location";
        [self addSubview:_locationLabel];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(searchbarWidth + gap1 + offsetForLabel + 2 * (frameWidth - searchbarWidth - 2)/7, searchbarHeight + gap3,(frameWidth - searchbarWidth - 2)/7, patientInfoHeight)];
        _nameLabel.font = [UIFont fontWithName:fontName size:fontHeight];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor = PatientInfoTextColor;
       // _nameLabel.text = @"name";
        [self addSubview:_nameLabel];
        
        _genderLabel = [[UILabel alloc] initWithFrame:CGRectMake(searchbarWidth + gap1 + offsetForLabel + 3 * (frameWidth - searchbarWidth - 2)/7, searchbarHeight + gap3,(frameWidth - searchbarWidth - 2)/7, patientInfoHeight)];
        _genderLabel.font = [UIFont fontWithName:fontName size:fontHeight];
        _genderLabel.textAlignment = NSTextAlignmentCenter;
        _genderLabel.textColor = PatientInfoTextColor;
        //_genderLabel.text = @"Gender";
        [self addSubview:_genderLabel];
        
        _ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(searchbarWidth + gap1 + offsetForLabel + 4 *(frameWidth - searchbarWidth - 2)/7, searchbarHeight + gap3,(frameWidth - searchbarWidth - 2)/7, patientInfoHeight)];
        _ageLabel.font = [UIFont fontWithName:fontName size:fontHeight];
        _ageLabel.textAlignment = NSTextAlignmentJustified;
        _ageLabel.textColor = PatientInfoTextColor;
       // _ageLabel.text = @"age";
        [self addSubview:_ageLabel];
       
       
        [self addSubview:_showNoteDetailTable];
        
        
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
////    // Drawing code
////    UIBezierPath *path = [UIBezierPath bezierPath];
////    path.lineWidth  = 2;
////    //[[UIColor groupTableViewBackgroundColor] set];
////    
////    [path moveToPoint:CGPointMake(0,  searchbarHeight)];
////   // [path addLineToPoint:CGPointMake(rect.size.width,  searchbarHeight)];
////    //[path closePath];
////    //[path stroke];
////    
//////    [path moveToPoint:CGPointMake(searchbarWidth, 0)];
//////    [path addLineToPoint:CGPointMake(searchbarWidth, rect.size.height)];
//////    [path closePath];
//////    //[path stroke];
//////    
//////    [path moveToPoint:CGPointMake(searchbarWidth+gap1, searchbarHeight)];
//////    [path addLineToPoint:CGPointMake(rect.size.width, searchbarHeight)];
//////    [path closePath];
////    //[path stroke];
//////    UIBezierPath *path2 = [UIBezierPath bezierPath];
//////    path2.lineWidth = 2;
//////    [path2 moveToPoint:CGPointMake(searchbarWidth, 0)];
//////    [path2 addLineToPoint:CGPointMake(searchbarWidth, rect.size.height)];
////    
////    
//////    [[UIColor orangeColor] set];
//////    [path2 moveToPoint:CGPointMake(0, 55)];
//////    [path2 addLineToPoint:CGPointMake(rect.size.width, 55)];
//////    [path2 stroke];
////
//}


@end
