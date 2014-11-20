//
//  creatNoteView.m
//  NoteBook
//
//  Created by ihefe-JF on 14/11/4.
//  Copyright (c) 2014年 ihefe. All rights reserved.
//

#import "CreateNoteView.h"

@implementation CreateNoteView

static float zoomInOutWidthOffset = 30;

static float gap1 = 5;
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        
        CGFloat frameWidth = frame.size.width;
        CGFloat frameHeight = frame.size.height;
       
        self.layer.cornerRadius = 10;
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderWidth = 4;
       // self.layer.borderColor = [UIColor yellowColor].CGColor;
        
        _cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancel.frame = CGRectMake(0, 0, 60, 55);
        [_cancel setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_cancel setTitle:@"取消" forState:UIControlStateNormal];
        
        _zoomInOut = [UIButton buttonWithType:UIButtonTypeCustom];
        _zoomInOut.frame = CGRectMake(60 + zoomInOutWidthOffset, 0, frameWidth - 60 - 60 - 2 * zoomInOutWidthOffset, 55);
        [_zoomInOut setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [_zoomInOut setTitle:@"记事本" forState:UIControlStateNormal];
        
        _save = [UIButton buttonWithType:UIButtonTypeCustom];
        _save.frame = CGRectMake( 60 + frameWidth - 60 - 60 , 0, 60, 55);
        [_save setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        
        [_save setTitle:@"保存" forState:UIControlStateNormal];
        
        //sync button (0,56) 1个point用于画分割线
//        _syncButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _syncButton.frame = CGRectMake(frameWidth/2 - 75, 56 + syncButtonHeightOffset , 150, 30);
//        [_syncButton setTitle:@"同步患者卡" forState:UIControlStateNormal];
//        [_syncButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        //留1个point画分割线
        _creatNoteTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,56+70 ,frameWidth, frameHeight - 56 - 70) style:UITableViewStylePlain];
        _creatNoteTableView.alpha = 1;
        _creatNoteTableView.tableFooterView =  [[UIView alloc] initWithFrame:CGRectZero];
        
//        UIEdgeInsets inset = _creatNoteTableView.separatorInset;
//        inset.left = 0;
//        [_creatNoteTableView setSeparatorInset:inset];
//        [_creatNoteTableView setSeparatorColor:[UIColor orangeColor]];
       // _creatNoteTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,56 ,frameWidth, frameHeight - 56) style:UITableViewStylePlain];
        

        //(0,56,frameWidth,70)
        //patientd data
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(gap1, 56+gap1, frameWidth/5 - 2 * gap1, frameWidth/5 - 2 * gap1)];
        
        _areaLabel = [[UILabel alloc] initWithFrame:CGRectMake(frameWidth/5, 56 + gap1, 2 * frameWidth/5, 35-gap1)];
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(frameWidth/5, 56+gap1+35-gap1, 2 * frameWidth/5, 35-gap1)];
        _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(frameWidth/5 +2 * frameWidth/5 , 56 + gap1, frameWidth/5, 35-gap1)];
        _genderLabel = [[UILabel alloc]initWithFrame:CGRectMake(frameWidth/5 +2 * frameWidth/5, 56+35, frameWidth/5, 35-gap1)];
        _ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(4*frameWidth/5, 56+35, frameWidth/5, 35-gap1)];
        
        
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
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth  = 2;
    [[UIColor groupTableViewBackgroundColor] set];
    
    [path moveToPoint:CGPointMake(0, 55+70)];
    [path addLineToPoint:CGPointMake(rect.size.width, 55+70)];
    [path stroke];
    
    UIBezierPath *path2 = [UIBezierPath bezierPath];
    path2.lineWidth = 2;
    [[UIColor orangeColor] set];
    [path2 moveToPoint:CGPointMake(0, 55)];
    [path2 addLineToPoint:CGPointMake(rect.size.width, 55)];
    [path2 stroke];
}


@end
