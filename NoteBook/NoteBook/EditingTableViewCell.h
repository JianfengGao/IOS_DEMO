//
//  EditingTableViewCell.h
//  NoteBook
//
//  Created by ihefe-JF on 14-10-16.
//  Copyright (c) 2014年 ihefe. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol EditingTableViewCellDelegate;

@interface EditingTableViewCell : UITableViewCell <UITextViewDelegate>
@property(nonatomic,strong) UITextView *inputField;
@property(nonatomic,strong) NSString *indexStr;
@property(nonatomic,strong) id <EditingTableViewCellDelegate> delegate;
@property(nonatomic) double rowNumberFlag;
@end

@protocol EditingTableViewCellDelegate <NSObject>

- (void)growingCell:(EditingTableViewCell*)cell didChangeSize:(CGSize)size;
- (void)cellId:(EditingTableViewCell*)cell textView:(UITextView*)textView text:(NSString*)text;
-(void)textViewDidStartEditing:(UITextView*)textView cell:(EditingTableViewCell*)cell;
-(BOOL)textviewShouldBeginEditing:(UITextView*)textView;
-(void)cell:(EditingTableViewCell*)cell textView:(UITextView*)textView;
@end
