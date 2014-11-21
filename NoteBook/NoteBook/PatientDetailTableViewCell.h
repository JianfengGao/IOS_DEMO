//
//  PatientDetailTableViewCell.h
//  NoteBook
//
//  Created by ihefe-JF on 14-10-24.
//  Copyright (c) 2014年 ihefe. All rights reserved.
//

#import "EditingTableViewCell.h"


@protocol PatientNoteDetailTableViewDelegate;
@interface PatientDetailTableViewCell : UITableViewCell <UITextViewDelegate>
@property(nonatomic,strong) UITextView *inputField;
@property(nonatomic,strong) NSString *indexStr;
@property(nonatomic,strong) id <PatientNoteDetailTableViewDelegate> delegate;
@property(nonatomic) double rowNumberFlag;
@end
@protocol PatientNoteDetailTableViewDelegate <NSObject>

- (void)growingCell:(PatientDetailTableViewCell*)cell didChangeSize:(CGSize)size;
- (void)cellId:(PatientDetailTableViewCell*)cell textView:(UITextView*)textView text:(NSString*)text;
-(void)textViewDidStartEditing:(UITextView*)textView cell:(PatientDetailTableViewCell*)cell;
-(void)textViewWillStartEditing:(UITextView*)textView cell:(PatientDetailTableViewCell*)cell;
//-(void)adjustEditingTextViewHeight:(UITextView*)textView;
-(void)textViewDidEndEditing:(UITextView*)textView cell:(PatientDetailTableViewCell*)cell;
-(void)cell:(PatientDetailTableViewCell*)cell textView:(UITextView*)textView;
@end