//
//  TempView.h
//  NoteBook
//
//  Created by ihefe-JF on 14/11/26.
//  Copyright (c) 2014年 ihefe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TempView : UIView

-(instancetype)initWithView:(UIView*)view text:(NSString *)text;

@property(nonatomic) NSTimeInterval duration;

-(void)showWithAnimation:(BOOL)animation;
-(void)dismissWithAnimation:(BOOL)animation;
@end
