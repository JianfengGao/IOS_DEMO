//
//  noteInfoDetail.m
//  NoteBook
//
//  Created by ihefe-JF on 14/11/11.
//  Copyright (c) 2014年 ihefe. All rights reserved.
//

#import "NoteInfoDetail.h"

@implementation NoteInfoDetail

-(id)initWithNoteUUID:(NSString *)noteUUID serverDateString:(NSString *)serverString TitleName:(NSString *)titleName
{
   
    if(self = [super init]){
        self.noteUIID = noteUUID;
        self.serverDateString = serverString;
        self.titleName = titleName;
    }
    return self;
}
@end
