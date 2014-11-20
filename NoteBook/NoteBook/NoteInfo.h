//
//  NoteInfo.h
//  ihefeNote
//
//  Created by ihefe-JF on 14/11/4.
//  Copyright (c) 2014年 ihefe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PatientData.h"

@interface NoteInfo : NSObject
@property (nonatomic)NSInteger noteID;
@property(nonatomic,strong) NSString *titleName;
@property(nonatomic,strong) NSString *noteContents;

@property(nonatomic,strong) NSString *creatDateString;
@property(nonatomic,strong) NSString *updateDateString;

@property(nonatomic,strong) NSString *createNotePeople;

@property(nonatomic,strong) PatientData *patientInfo;

@property(strong,nonatomic) NSMutableArray *rowContent;
//@property(strong,nonatomic) NSString *name;
@property(strong,nonatomic) NSString *note_type;
@property(strong,nonatomic) NSString *noteUIID;

@property(nonatomic) NSInteger is_delete;
@property(nonatomic) NSInteger is_public;
@property(nonatomic) NSInteger has_network;
@property(nonatomic,strong) NSString *modf_people;
@property(strong,nonatomic) NSString *serverTime;
-(id)initWithNoteID:(NSInteger)noteID NoteTitleName:(NSString*)titleName NoteContents:(NSString*)noteContents CreateDateString:(NSString*)createDate UpdateString:(NSString*)updateString NoteUUID:(NSString*)noteUUID CreateNotePeople:(NSString*)createNotePeople noteType:(NSString*)noteType serverTime:(NSString*)serverTime isDelete:(NSInteger)is_delete isPublic:(NSInteger)is_public modif_people:(NSString*)modefPeople has_network:(NSInteger)has_network;

-(id)initWithNoteTitleName:(NSString*)titleName NoteContents:(NSString*)noteContents CreateDateString:(NSString*)createDate UpdateString:(NSString*)updateString NoteUUID:(NSString*)noteUUID CreateNotePeople:(NSString*)createNotePeople noteType:(NSString*)noteType serverTime:(NSString*)serverTime isDelete:(NSInteger)is_delete isPublic:(NSInteger)is_public modif_people:(NSString*)modefPeople has_network:(NSInteger)has_network;
@end
