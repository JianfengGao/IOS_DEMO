//
//  NotebookDatabase.h
//  ihefeNote
//
//  Created by ihefe-JF on 14/11/4.
//  Copyright (c) 2014年 ihefe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "NoteInfo.h"

@interface NotebookDatabase : NSObject{
   
}
@property (nonatomic) sqlite3 *noteDatabase;
@property(strong,nonatomic) NSString *databasePath;

+(NotebookDatabase*)initDatabase;

//load data from database
//-(NSArray*)noteInfos;


//save note
-(BOOL)saveNote:(NoteInfo *)noteInfo success:(void (^)(void))success;
-(BOOL)deleteNote:(NoteInfo *)noteInfo;

-(NSMutableArray *)getNotes;
-(NoteInfo *)getNote:(NSInteger)noteID;
-(NSMutableArray *)getNotesForUser:(NSString *)user;//user = create people
-(NSString*)getNoteContentsByNoteUUID:(NSString*)noteUUID;
//-(NSString*)getMaxServerTime;
-(NSInteger)getTableColumnCount:(NSString*)tableName;
-(void)saveNotes:(NSArray*)notes success:(void (^)(void))success;
-(NSMutableArray*)getAllNotesFromTable:(NSString *)tableName ByUser:(NSString *)userName;
//
-(NSString*)getMaxServerTimeByNoteUser:(NSString*)noteUser;
-(void)saveNewNote:(NoteInfo*)noteInfo success:(void (^)(void))success failed:(void (^)(void))failed;
-(void)saveServerNoteContentHasChangeToLocal:(NoteInfo*)noteInfo success:(void (^)(void))success failed:(void (^)(void))failed;
-(NoteInfo*)queryLocalNoteContentsByNoteUUID:(NSString*)noteUUID;
-(BOOL)queryLocalNoteHasOrNotByNoteUUID:(NSString*)noteUUID;
-(NSMutableArray *)getAllNotesFromLocalDatabase;
-(NSArray*)queryLocalNoteContentsByHasNetwork:(NSInteger)hasNetwork createPeople:(NSString*)createPeople;
-(NSArray*)getAllNotesFromLocalByUser:(NSString*)userName success:(void (^)(void))success failed:(void (^)(void))failed;
-(void)updateNewNoteInfo:(NoteInfo*)noteInfo success:(void (^)(void))success failed:(void (^)(void))failed;
-(void)saveDeleteNoteToLocal:(NoteInfo*)noteInfo success:(void (^)(void))success failed:(void (^)(void))failed;
-(void)saveUpdateNoteToLocal:(NoteInfo*)noteInfo success:(void (^)(void))success failed:(void (^)(void))failed;
-(NSUInteger)getMaxRowNumberByNoteUser:(NSString*)noteUser success:(void (^)(void))success failed:(void (^)(void))failed;
-(NSArray*)getNotesFromLocalByUser:(NSString*)userName nBaseRow:(NSInteger)indexPathRow nNumRecord:(NSInteger)nNumRecord success:(void (^)(void))success failed:(void (^)(void))failed;
@end


