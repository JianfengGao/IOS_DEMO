//
//  PatientDetailTableViewCell.m
//  NoteBook
//
//  Created by ihefe-JF on 14-10-24.
//  Copyright (c) 2014年 ihefe. All rights reserved.
//

#import "PatientDetailTableViewCell.h"

@implementation PatientDetailTableViewCell 

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSTextContainer *container = self.inputField.textContainer;
        container.widthTracksTextView = YES;
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
//            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-textView-|"
//                                                                                     options:0
//                                                                                     metrics:nil
//                                                                                       views:NSDictionaryOfVariableBindings(self.inputField)]];
//            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-textView-|"
//                                                                                     options:0
//                                                                                     metrics:nil
//                                                                                       views:NSDictionaryOfVariableBindings(self.inputField)]];
//        
    }
    return self;
}

-(UITextView *)inputField
{
    if(!_inputField){
        _inputField = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
        _inputField.autoresizesSubviews = YES;
        [_inputField setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight ];
     
        _inputField.backgroundColor = [UIColor clearColor];
        _inputField.delegate = self;
        _inputField.contentInset = UIEdgeInsetsMake(8, 0, 8, 0);
        _inputField.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17 ];
        //_inputField.textColor =  [UIColor blueColor];
        //_inputField.textColor = [UIColor lightTextColor];
        _inputField.textAlignment = NSTextAlignmentLeft;
        _inputField.showsHorizontalScrollIndicator = NO;
        _inputField.showsVerticalScrollIndicator = NO;
        _inputField.scrollEnabled = NO;
        _inputField.editable = YES;
       // _inputField.text = @"";
        [self.contentView addSubview:_inputField];
       // [self.contentView sizeToFit];
       // self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
    }
    return _inputField;
}


- (void)textViewDidChange:(UITextView *)textView
{
    
 
    CGSize size = [textView sizeThatFits:textView.frame.size];

    if(size.height - self.rowNumberFlag >=19 || self.rowNumberFlag - size.height >= 19){
        self.rowNumberFlag = size.height;
        [self.delegate growingCell:self didChangeSize:size];
        
        CGRect rect = self.inputField.bounds;
        rect.size.height =  size.height + 8;
      
        textView.bounds = rect;
    }
    NSLog(@"size.height:%f",size.height);
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{

    [self.delegate cellId:self textView:textView text:textView.text];
    if([text isEqualToString:@"\n"]){

            [textView resignFirstResponder];
            [self.delegate cellId:self textView:textView text:textView.text];
            [self.delegate cell:self textView:textView];
        
        return NO;
    }
    return YES;
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    [self.delegate cellId:self textView:textView text:textView.text];
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    
    static  double rowNumberFlag = 0;
    self.rowNumberFlag  = rowNumberFlag;
    NSLog(@"testView :%lf ,textView.,",textView.frame.size.height);
    [self.delegate textViewDidStartEditing:textView cell:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
