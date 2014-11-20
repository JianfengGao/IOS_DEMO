//
//  noteInfoDetail.h
//  NoteBook
//
//  Created by ihefe-JF on 14/11/11.
//  Copyright (c) 2014年 ihefe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoteInfoDetail : NSObject
@property(nonatomic,strong) NSString *noteUIID;
@property(nonatomic,strong) NSString *serverDateString;
@property(nonatomic,strong) NSString *titleName;
-(id)initWithNoteUUID:(NSString*)noteUUID serverDateString:(NSString *)serverString TitleName:(NSString*)titleName;
@end
