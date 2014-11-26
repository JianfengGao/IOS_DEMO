//
//  TempView.m
//  NoteBook
//
//  Created by ihefe-JF on 14/11/26.
//  Copyright (c) 2014年 ihefe. All rights reserved.
//

#import "TempView.h"

@interface TempView()
    
@property(nonatomic,strong) NSString *text;
@property(nonatomic,strong) UIView *view;
@property(nonatomic,strong) UILabel *textLabel;

@property(nonatomic) CGFloat viewHeight;
@end
@implementation TempView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self){
        self.layer.backgroundColor = [UIColor redColor].CGColor;
        self.layer.cornerRadius = 3;
        
        CGRect rect = frame;
        rect.origin = CGPointZero;
        _textLabel = [[UILabel alloc] initWithFrame:rect];
        _textLabel.font = [UIFont systemFontOfSize:18];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.textAlignment =  NSTextAlignmentCenter;
       // [_textLabel sizeToFit];
        _duration = 0.7;
        
        [self addSubview:_textLabel];
        
      }
    return self;
}

-(instancetype)initWithView:(UIView *)view text:(NSString *)text
{
    if([self initWithFrame:CGRectMake(0, -20, view.frame.size.width/2, 64)]){
        self.text = text;
        self.textLabel.text = text;
        self.view = view;
       
        
        self.viewHeight = view.frame.size.height;
        self.center = CGPointMake(view.bounds.size.width/2, self.center.y);
        

        [view addSubview:self];
    }
    return self;
}

-(void)showWithAnimation:(BOOL)animation
{
    CGRect frame = self.frame;
    frame.origin.y = self.viewHeight/2 - 150;
    //[self.textLabel sizeToFit];
    if(animation){
        [UIView animateWithDuration:self.duration animations:^{
            self.frame = frame;
        } completion:^(BOOL finished) {
            [self showHandle];
        }];
    }else {
        self.frame = frame;
        [self showHandle];
    }
}
-(void)showHandle
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissWithAnimation:YES];
    });
}
-(void)dismissWithAnimation:(BOOL)animation
{
    CGRect frame = self.frame;
    frame.origin.y = -20;
    if(animation){
        [UIView animateWithDuration:self.duration*0.1 animations:^{
            self.frame = frame;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }else {
        [self removeFromSuperview];
    }
}
@end
