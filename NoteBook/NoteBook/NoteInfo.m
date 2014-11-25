//
//  NoteInfo.m
//  ihefeNote
//
//  Created by ihefe-JF on 14/11/4.
//  Copyright (c) 2014年 ihefe. All rights reserved.
//

#import "NoteInfo.h"

@implementation NoteInfo
@synthesize rowContent = _rowContent;
@synthesize noteContents = _noteContents;

-(NSMutableArray *)rowContent
{
    if(!_rowContent){
        _rowContent = [[NSMutableArray alloc] initWithArray:[self.noteContents componentsSeparatedByString:@"-"]];
        NSString *tempString = [self convertContainsNoBlankLineArrayToString:_rowContent];
        _rowContent = [[NSMutableArray alloc] initWithArray:[tempString componentsSeparatedByString:@"-"]];
    }
    return _rowContent;
}
-(NSString*)convertArrayToString:(NSArray *)array
{
    NSString *retvString = [[array valueForKey:@"description"] componentsJoinedByString:@"-"];
    NSLog(@"retvString : %@",retvString);
    return retvString;
    
}
-(NSString*)convertContainsNoBlankLineArrayToString:(NSArray*)array
{
    NSString *tempStr;
    NSMutableArray  *tempArray = [[NSMutableArray alloc] init];
    for(NSString *str in array){
        if(![str isEqualToString:@""]){
            [tempArray addObject:str];
        }
    }
    tempStr = [self convertArrayToString:tempArray];
    return tempStr;
}

-(id)initWithNoteID:(NSInteger)noteID NoteTitleName:(NSString*)titleName NoteContents:(NSString*)noteContents CreateDateString:(NSString*)createDate UpdateString:(NSString*)updateString NoteUUID:(NSString*)noteUUID CreateNotePeople:(NSString*)createNotePeople noteType:(NSString*)noteType serverTime:(NSString*)serverTime isDelete:(NSInteger)is_delete isPublic:(NSInteger)is_public modif_people:(NSString*)modefPeople has_network:(NSInteger)has_network patientInfo:(PatientData*)patientInfo
{
    if(self = [super init]){
        self.noteID = noteID;
        self.titleName = titleName;
        self.noteContents = noteContents;
        self.creatDateString = createDate;
        self.updateDateString = updateString;
        self.noteUIID = noteUUID;
        self.createNotePeople = createNotePeople;
        self.note_type = noteType;
        self.serverTime = serverTime;
        self.is_delete = is_delete;
        self.is_public = is_public;
        self.modf_people = modefPeople;
        self.has_network = has_network;
        self.patientInfo = patientInfo;
       
    }
    return self;

}

-(id)initWithNoteID:(NSInteger)noteID NoteTitleName:(NSString*)titleName NoteContents:(NSString*)noteContents CreateDateString:(NSString*)createDate UpdateString:(NSString*)updateString NoteUUID:(NSString*)noteUUID CreateNotePeople:(NSString*)createNotePeople noteType:(NSString*)noteType serverTime:(NSString*)serverTime isDelete:(NSInteger)is_delete isPublic:(NSInteger)is_public modif_people:(NSString*)modefPeople has_network:(NSInteger)has_network
{
    if(self = [super init]){
        self.noteID = noteID;
        self.titleName = titleName;
        self.noteContents = noteContents;
        self.creatDateString = createDate;
        self.updateDateString = updateString;
        self.noteUIID = noteUUID;
        self.createNotePeople = createNotePeople;
        self.note_type = noteType;
        self.serverTime = serverTime;
        self.is_delete = is_delete;
        self.is_public = is_public;
        self.modf_people = modefPeople;
        self.has_network = has_network;
    }
    return self;
}
-(id)initWithNoteTitleName:(NSString*)titleName NoteContents:(NSString*)noteContents CreateDateString:(NSString*)createDate UpdateString:(NSString*)updateString NoteUUID:(NSString*)noteUUID CreateNotePeople:(NSString*)createNotePeople noteType:(NSString*)noteType serverTime:(NSString*)serverTime isDelete:(NSInteger)is_delete isPublic:(NSInteger)is_public modif_people:(NSString*)modefPeople has_network:(NSInteger)has_network
{
    if(self = [super init]){
       
        self.titleName = titleName;
        self.noteContents = noteContents;
        self.creatDateString = createDate;
        self.updateDateString = updateString;
        self.noteUIID = noteUUID;
        self.createNotePeople = createNotePeople;
        self.note_type = noteType;
        self.serverTime = serverTime;
        self.is_delete = is_delete;
        self.is_public = is_public;
        self.modf_people = modefPeople;
        self.has_network = has_network;
    }
    return self;
}

@end
