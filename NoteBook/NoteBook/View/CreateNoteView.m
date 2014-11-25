//
//  creatNoteView.m
//  NoteBook
//
//  Created by ihefe-JF on 14/11/4.
//  Copyright (c) 2014年 ihefe. All rights reserved.
//

#import "CreateNoteView.h"

@implementation CreateNoteView

#define BUTTONFONT [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
#define PatientInfoTextColor [
static float zoomInOutWidthOffset = 30;

static float gap1 = 3;
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        
        CGFloat frameWidth = frame.size.width;
        CGFloat frameHeight = frame.size.height;
       
        self.layer.cornerRadius = 10;
        
        self.backgroundColor = [UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:250/255.0 alpha:1];
        self.layer.borderWidth = 2;
        self.layer.borderColor = [UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:250/255.0 alpha:1].CGColor;
       // self.layer.borderColor = [UIColor yellowColor].CGColor;
        UIView *tempViewForButton = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frameWidth, 55)];
        tempViewForButton.backgroundColor = [UIColor whiteColor];
        [self addSubview:tempViewForButton];
        
        _cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancel.frame = CGRectMake(0, 0, 60, 55);
        [_cancel setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        _cancel.titleLabel.font = [UIFont systemFontOfSize:18];
        [_cancel setTitle:@"取消" forState:UIControlStateNormal];
        
        
        _zoomInOut = [UIButton buttonWithType:UIButtonTypeCustom];
        _zoomInOut.frame = CGRectMake(60 + zoomInOutWidthOffset, 0, frameWidth - 60 - 60 - 2 * zoomInOutWidthOffset, 55);
        [_zoomInOut setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        _zoomInOut.titleLabel.font = [UIFont systemFontOfSize:20];
        [_zoomInOut setTitle:@"记事本" forState:UIControlStateNormal];
        
        _save = [UIButton buttonWithType:UIButtonTypeCustom];
        _save.frame = CGRectMake( 60 + frameWidth - 60 - 60 , 0, 60, 55);
        [_save setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
       // _save.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
        _save.titleLabel.font  = [UIFont systemFontOfSize:18];
        [_save setTitle:@"保存" forState:UIControlStateNormal];
        
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 58+70+3, frameWidth, 44)];
        _textField.textColor = [UIColor blackColor];
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.opaque = YES;
        //_textField.delegate = self;
        _textField.placeholder = @"输入标题";
        _textField.textAlignment = NSTextAlignmentCenter;
        _textField.font = [UIFont boldSystemFontOfSize:22];
        //_textField.layer.borderColor = [UIColor orangeColor].CGColor;
        //_textField.layer.borderWidth = 3;
        
        //sync button (0,56) 1个point用于画分割线
//        _syncButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _syncButton.frame = CGRectMake(frameWidth/2 - 75, 56 + syncButtonHeightOffset , 150, 30);
//        [_syncButton setTitle:@"同步患者卡" forState:UIControlStateNormal];
//        [_syncButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        //留1个point画分割线
        _creatNoteTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,58+73+44+2,frameWidth, frameHeight - 58 -73-44-2) style:UITableViewStylePlain];
        _creatNoteTableView.alpha = 1;
        _creatNoteTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _creatNoteTableView.tableFooterView =  [[UIView alloc] initWithFrame:CGRectZero];
        //_creatNoteTableView.bounces = NO;
//        UIEdgeInsets inset = _creatNoteTableView.separatorInset;
//        inset.left = 0;
//        [_creatNoteTableView setSeparatorInset:inset];
//        [_creatNoteTableView setSeparatorColor:[UIColor orangeColor]];
       // _creatNoteTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,56 ,frameWidth, frameHeight - 56) style:UITableViewStylePlain];
        

        //(0,56,frameWidth,70)
        //patientd data
        _tempViewForPatient = [[UIView alloc] initWithFrame:CGRectMake(0, 55+gap1, frameWidth, 70)];
        _tempViewForPatient.backgroundColor = [UIColor whiteColor];
       // tempViewForPatient.alpha = 0;
        [self addSubview:_tempViewForPatient];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(gap1, 56+gap1, frameWidth/5 - 2 * gap1, frameWidth/5 - 2 * gap1)];
        
        
        _areaLabel = [[UILabel alloc] initWithFrame:CGRectMake(frameWidth/5, 56 + gap1, 2 * frameWidth/5, 35-gap1)];
        _areaLabel.textColor = [UIColor darkGrayColor];
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(frameWidth/5, 56+gap1+35-gap1, 2 * frameWidth/5, 35-gap1)];
        _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(frameWidth/5 +2 * frameWidth/5 , 56 + gap1, frameWidth/5, 35-gap1)];
        _genderLabel = [[UILabel alloc]initWithFrame:CGRectMake(frameWidth/5 +2 * frameWidth/5, 56+35, frameWidth/5, 35-gap1)];
        _ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(4*frameWidth/5, 56+35, frameWidth/5, 35-gap1)];
        
        _nameLabel.textColor = [UIColor darkGrayColor];
        _locationLabel.textColor = [UIColor darkGrayColor];
        _genderLabel.textColor = [UIColor darkGrayColor];
        _ageLabel.textColor = [UIColor darkGrayColor];

        [self addSubview:_cancel];
        [self addSubview:_zoomInOut];
        [self addSubview:_save];
        [self addSubview:_syncButton];
       
        [self addSubview:_imageView];
        [self addSubview:_areaLabel];
        [self addSubview:_nameLabel];
        [self addSubview:_locationLabel];
        [self addSubview:_genderLabel];
        [self addSubview:_ageLabel];
        
        [self addSubview:_textField];
        [self addSubview:_creatNoteTableView];
     
//        //for test
//        _areaLabel.text  = @"病区一";
//        _nameLabel.text = @"王小二";
//        _locationLabel.text = @"+ 1床";
//        _genderLabel.text = @"女";
//        _ageLabel.text = @"56";
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    path.lineWidth  = 3;
//    [[UIColor groupTableViewBackgroundColor] set];
//    
////    [path moveToPoint:CGPointMake(0, 59+70)];
////    [path addLineToPoint:CGPointMake(rect.size.width, 59+70)];
////    [path stroke];
    
    UIBezierPath *path2 = [UIBezierPath bezierPath];
    path2.lineWidth = 2;
    [[UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:250/255.0 alpha:1] set];
    [path2 moveToPoint:CGPointMake(0, 58+44)];
    [path2 addLineToPoint:CGPointMake(rect.size.width, 58+44)];
    [path2 stroke];
    
    UIBezierPath *path3 = [UIBezierPath bezierPath];
    path3.lineWidth = 3;
    [[UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:250/255.0 alpha:1] set];
    [path3 moveToPoint:CGPointMake(0, 58+73+44)];
    [path3 addLineToPoint:CGPointMake(rect.size.width, 58+73+44)];
    [path3 stroke];
}


@end
