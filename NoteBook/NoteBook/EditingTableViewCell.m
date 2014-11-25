//
//  EditingTableViewCell.m
//  NoteBook
//
//  Created by ihefe-JF on 14-10-16.
//  Copyright (c) 2014年 ihefe. All rights reserved.
//

#import "EditingTableViewCell.h"

@implementation EditingTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        NSTextContainer *container = self.inputField.textContainer;
        container.widthTracksTextView = YES;
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
//        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.bounds.size.height - 1, self.frame.size.width+26, 1)];
//        lineView.backgroundColor = [UIColor lightTextColor];
//        [self addSubview:lineView];
    }
    return self;
}
- (void)awakeFromNib
{
    // Initialization code
  
}
-(UITextView *)inputField
{
    if(!_inputField){
        _inputField = [[UITextView alloc] initWithFrame:CGRectMake(8, 5, self.contentView.frame.size.width , self.contentView.frame.size.height - 10)];
     
        [_inputField setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        _inputField.backgroundColor = [UIColor clearColor];
        _inputField.delegate = self;
        _inputField.contentInset = UIEdgeInsetsMake(8, 1, 8, 1);
        _inputField.font = [UIFont fontWithName:@"HelveticaNeue" size:17 ];
        _inputField.textColor = [UIColor darkGrayColor];
        _inputField.textAlignment = NSTextAlignmentLeft;
        _inputField.showsHorizontalScrollIndicator = NO;
        _inputField.showsVerticalScrollIndicator = NO;
        _inputField.scrollEnabled = NO;
        _inputField.editable = YES;
        _inputField.text = @"  ";
        _inputField.center = self.center;
        
        [self.contentView addSubview:_inputField];
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
    }
    return _inputField;
}

- (void)textViewDidChange:(UITextView *)textView
{
    
    CGSize size = [textView sizeThatFits:textView.frame.size];
    //CGSize size = textView.contentSize;
    //size.height+= 8.0f;
   
    if(size.height - self.rowNumberFlag >= 19 || self.rowNumberFlag - size.height >= 19 ){
        self.rowNumberFlag = size.height;
        [self.delegate growingCell:self didChangeSize:size];
        CGRect rect = self.inputField.bounds;
        rect.size.height =  size.height+8;
        self.inputField.bounds = rect;
        
    }
    NSLog(@"size.height:%f",size.height);
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    
    [self.delegate cellId:self textView:textView text:textView.text];
    if([text isEqualToString:@"\n"]){
        
        if([textView.text isEqualToString: @""]){
            [textView resignFirstResponder];
            
        }else {
            [textView resignFirstResponder];
            [self .delegate cell:self textView:textView];
            [self.delegate cellId:self textView:textView text:textView.text];
        }
        return NO;
    }
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    self.rowNumberFlag = 0;
    [self.delegate textViewDidStartEditing:textView cell:self];
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    [self.delegate cellId:self textView:textView text:textView.text];
    
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return  [self.delegate textviewShouldBeginEditing:textView];
}
@end
