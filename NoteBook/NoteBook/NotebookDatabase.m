//
//  NotebookDatabase.m
//  ihefeNote
//
//  Created by ihefe-JF on 14/11/4.
//  Copyright (c) 2014年 ihefe. All rights reserved.
//

#import "NotebookDatabase.h"
#import "NoteInfoDetail.h"
#import "NoteInfoDetail.h"

@implementation NotebookDatabase
static NotebookDatabase *_database;
+(NotebookDatabase *)initDatabase
{
    if(_database == nil){
        _database = [[NotebookDatabase alloc] init];
    }
    return _database;
}

-(id)init
{
    if((self = [super init])){
        NSString *docsDir;
        NSArray *dirPaths;
        
        dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
        NSLog(@"dirPaths = %@",dirPaths);
        
        docsDir = [dirPaths objectAtIndex:0];
       // _databasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingString:@"/noteListAA.sqlite3"]];
        _databasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingString:@"/noteListA.sqlite3"]];
        NSFileManager *filemgr = [NSFileManager defaultManager];
        //不存在数据库文件“notelist.sqlite3"，创建文件
        if([filemgr fileExistsAtPath:_databasePath] == NO){
            //创建文件
            const char *dbpath = [_databasePath UTF8String];
            if(sqlite3_open(dbpath, &_noteDatabase) != SQLITE_OK){
                NSLog(@"失败的创建/打开数据库");
            }else{
                //创建表
                char *errMsg;
//                const char *sql_stmt = "create table if not exists notes(id integer primary key autoincrement,titleName TEXT,contents TEXT,creatDateString TEXT,updateDateString TEXT,createPeople TEXT,noteUIID TEXT,note_type TEXT,serverTime TEXT,is_delete INTEGER,is_public INTEGER,modif_people TEXT,has_network INTEGER)";
const char *sql_stmt = "create table if not exists notes(id integer primary key autoincrement,titleName TEXT,contents TEXT,creatDateString TEXT,updateDateString TEXT,createPeople TEXT,noteUIID TEXT,note_type TEXT,serverTime TEXT,is_delete INTEGER,is_public INTEGER,modif_people TEXT,has_network INTEGER,profileImage BLOB,area TEXT,location TEXT,name TEXT,gender TEXT,age TEXT)";
                if(sqlite3_exec(_noteDatabase, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK){
                    NSLog(@"创建表失败");
                }
               // sqlite3_close(_noteDatabase);
            }
        }
      //  打开数据库
        if(sqlite3_open([_databasePath UTF8String], &_noteDatabase) != SQLITE_OK){
            NSLog(@"Failed to open database!");
        }
    }
    return self;
}
-(void)dealloc
{
    //关闭数据库
    sqlite3_close(_noteDatabase);
}
//for table localTable 没有网络的情况下，两个表同时会保存笔记
-(void)saveNote:(NoteInfo *)noteInfo success:(void (^)(void))success failed:(void (^)(void))failed
{
    sqlite3_stmt *statement =NULL;
    // const char *dbPath = [_databasePath UTF8String];
    // if(sqlite3_open(dbPath, &(_noteDatabase)) == SQLITE_OK){
    if(noteInfo.noteID > 0){
        NSLog(@"Existing data,update please");
        NSString *updateSQL = [NSString stringWithFormat:@"update localTable set contents = '%@', updateDateString = '%@', modif_people = '%@' where id = ?",noteInfo.noteContents,noteInfo.updateDateString,noteInfo.modf_people];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(_noteDatabase, update_stmt, -1, &statement, NULL);
        
        sqlite3_bind_int(statement, 1, noteInfo.noteID);
        if(sqlite3_step(statement) == SQLITE_DONE){
            success();
            //success();
            // [self.delegate sucessSaveToDataBase];
        }else{
            NSLog(@"存取失败");
            
        }
    }else {
        NSLog(@"New note,insert please");
        
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT into localTable (titleName,contents,creatDateString,updateDateString,createPeople,noteUIID,note_type,serverTime,is_delete,is_public,modif_people,has_network) values (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%ld\",\"%ld\",\"%@\",\"%ld\")",noteInfo.titleName,noteInfo.noteContents,noteInfo.creatDateString,noteInfo.updateDateString,noteInfo.createNotePeople,noteInfo.noteUIID,noteInfo.note_type,noteInfo.serverTime,noteInfo.is_delete,noteInfo.is_public,noteInfo.modf_people,noteInfo.has_network];
    
        const char *insert_stmt = [insertSQL UTF8String];
        if(sqlite3_prepare_v2(_noteDatabase, insert_stmt, -1, &statement, NULL) == SQLITE_OK){
            
            if(sqlite3_step(statement) == SQLITE_DONE){
                NSLog(@"成功存入数据");
                success();
                
            }else {
                NSLog(@"存入数据失败");
            }
            
        };

        sqlite3_finalize(statement);
    }

}

//客户端查询 根据Note UUID
-(BOOL)queryLocalNoteHasOrNotByNoteUUID:(NSString*)noteUUID
{
 //   NoteInfo *noteInfo = NULL;
    BOOL hasNote ;
    sqlite3_stmt *statement;
    NSString *querySQL =[NSString stringWithFormat:@"SELECT * from notes where noteUIID='%@'",noteUUID];
    const char *query_stmt = [querySQL UTF8String];
    
    if(sqlite3_prepare_v2(_noteDatabase, query_stmt, -1, &statement, NULL) == SQLITE_OK){
        if (sqlite3_step(statement) == SQLITE_ROW) {
//            NSInteger noteID = sqlite3_column_int(statement, 0);
//            NSString *titleName = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 1) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 1)];
//            NSString *noteContents = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 2) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 2)];
//            NSString *creatDateString = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 3) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 3)];
//            NSString  *updateDateString = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 4) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 4)];
//            NSString *createNotePeople = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 5) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 5)];
//            NSString *noteUIID = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 6) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 6)];
//            NSString *note_type = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 7) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 7)];
//            NSString *serverTime = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 8) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 8)];
//            NSInteger is_delete = sqlite3_column_int(statement, 9);
//            NSInteger is_public = sqlite3_column_int(statement, 10);
//            NSString *modefPeople = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 11) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 11)];
//            NSInteger hasNetwork = sqlite3_column_int(statement, 12);
//            noteInfo = [[NoteInfo alloc] initWithNoteID:noteID NoteTitleName:titleName NoteContents:noteContents CreateDateString:creatDateString UpdateString:updateDateString NoteUUID:noteUIID CreateNotePeople:createNotePeople noteType:note_type serverTime:serverTime isDelete:is_delete isPublic:is_public modif_people:modefPeople has_network:hasNetwork];
            hasNote = YES;
        } else {
            hasNote = NO;
        }
        sqlite3_finalize(statement);
    }

   // return noteInfo;
    return hasNote;
}
-(NoteInfo*)queryLocalNoteContentsByNoteUUID:(NSString*)noteUUID
{
    NoteInfo *noteInfo = NULL;
  
    sqlite3_stmt *statement;
    int d = 0;
    //NSString *querySQL =[NSString stringWithFormat:@"SELECT * from notes where noteUIID='%@',has_network = '%d'",noteUUID,d];
    NSString *querySQL =[NSString stringWithFormat:@"SELECT * from notes where noteUIID='%@'",noteUUID];
    const char *query_stmt = [querySQL UTF8String];
    
    if(sqlite3_prepare_v2(_noteDatabase, query_stmt, -1, &statement, NULL) == SQLITE_OK){
        if (sqlite3_step(statement) == SQLITE_ROW) {
                        NSInteger noteID = sqlite3_column_int(statement, 0);
                        NSString *titleName = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 1) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 1)];
                        NSString *noteContents = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 2) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 2)];
                        NSString *creatDateString = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 3) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 3)];
                        NSString  *updateDateString = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 4) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 4)];
                        NSString *createNotePeople = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 5) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 5)];
                        NSString *noteUIID = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 6) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 6)];
                        NSString *note_type = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 7) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 7)];
                        NSString *serverTime = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 8) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 8)];
                        NSInteger is_delete = sqlite3_column_int(statement, 9);
                        NSInteger is_public = sqlite3_column_int(statement, 10);
                        NSString *modefPeople = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 11) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 11)];
                        NSInteger hasNetwork = sqlite3_column_int(statement, 12);
            
            //patient data
              NSData *imageData = [NSData dataWithBytes:sqlite3_column_blob(statement, 13) length:sqlite3_column_bytes(statement, 13)];
              NSString *area = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 14) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 14)];
              NSString *location = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 15) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 15)];
              NSString *name = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 16) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 16)];
              NSString *gender = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 17) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 17)];
              NSString *age = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 18) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 18)];
            
               //         noteInfo = [[NoteInfo alloc] initWithNoteID:noteID NoteTitleName:titleName NoteContents:noteContents CreateDateString:creatDateString UpdateString:updateDateString NoteUUID:noteUIID CreateNotePeople:createNotePeople noteType:note_type serverTime:serverTime isDelete:is_delete isPublic:is_public modif_people:modefPeople has_network:hasNetwork];
            PatientData *patientInfo = [[PatientData alloc] initWithProfileImage:imageData area:area location:location name:name gender:gender age:age];
            noteInfo = [[NoteInfo alloc] initWithNoteID:noteID NoteTitleName:titleName NoteContents:noteContents CreateDateString:creatDateString UpdateString:updateDateString NoteUUID:noteUIID CreateNotePeople:createNotePeople noteType:note_type serverTime:serverTime isDelete:is_delete isPublic:is_public modif_people:modefPeople has_network:hasNetwork patientInfo:patientInfo];
           
        }
        sqlite3_finalize(statement);
    }
    
     return noteInfo;

}

-(NSArray*)queryLocalNoteContentsByHasNetwork:(NSInteger)hasNetwork createPeople:(NSString*)createPeople
{
    
     NSMutableArray *notes = [[NSMutableArray alloc]init];
    sqlite3_stmt *statement;
    
    //NSString *querySQL =[NSString stringWithFormat:@"SELECT * from notes where noteUIID='%@',has_network = '%d'",noteUUID,d];
    NSString *querySQL =[NSString stringWithFormat:@"SELECT * from notes where createPeople= '%@' and has_network= '%ld' ",createPeople, hasNetwork];
    const char *query_stmt = [querySQL UTF8String];
    
    if(sqlite3_prepare_v2(_noteDatabase, query_stmt, -1, &statement, NULL) == SQLITE_OK){
        while(sqlite3_step(statement) == SQLITE_ROW) {
            NSInteger noteID = sqlite3_column_int(statement, 0);
            NSString *titleName = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 1) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 1)];
            NSString *noteContents = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 2) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 2)];
            NSString *creatDateString = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 3) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 3)];
            NSString  *updateDateString = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 4) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 4)];
            NSString *createNotePeople = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 5) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 5)];
            NSString *noteUIID = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 6) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 6)];
            NSString *note_type = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 7) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 7)];
            NSString *serverTime = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 8) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 8)];
            NSInteger is_delete = sqlite3_column_int(statement, 9);
            NSInteger is_public = sqlite3_column_int(statement, 10);
            NSString *modefPeople = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 11) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 11)];
            NSInteger hasNetwork = sqlite3_column_int(statement, 12);
            
           // NoteInfo *noteInfo = [[NoteInfo alloc] initWithNoteID:noteID NoteTitleName:titleName NoteContents:noteContents CreateDateString:creatDateString UpdateString:updateDateString NoteUUID:noteUIID CreateNotePeople:createNotePeople noteType:note_type serverTime:serverTime isDelete:is_delete isPublic:is_public modif_people:modefPeople has_network:hasNetwork];
            //patient data
            NSData *imageData = [NSData dataWithBytes:sqlite3_column_blob(statement, 13) length:sqlite3_column_bytes(statement, 13)];
            NSString *area = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 14) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 14)];
            NSString *location = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 15) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 15)];
            NSString *name = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 16) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 16)];
            NSString *gender = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 17) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 17)];
            NSString *age = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 18) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 18)];

            PatientData *patientInfo = [[PatientData alloc] initWithProfileImage:imageData area:area location:location name:name gender:gender age:age];
            NoteInfo *noteInfo = [[NoteInfo alloc] initWithNoteID:noteID NoteTitleName:titleName NoteContents:noteContents CreateDateString:creatDateString UpdateString:updateDateString NoteUUID:noteUIID CreateNotePeople:createNotePeople noteType:note_type serverTime:serverTime isDelete:is_delete isPublic:is_public modif_people:modefPeople has_network:hasNetwork patientInfo:patientInfo];
            [notes addObject:noteInfo];
        }
        sqlite3_finalize(statement);
    }
    
    return notes;
    
}

//客户端保存

//保存离线状态下新建的笔记，当联网之后发送到服务器端，需要更新客户端笔记的信息
-(void)updateNewNoteInfo:(NoteInfo*)noteInfo success:(void (^)(void))success failed:(void (^)(void))failed
{
    sqlite3_stmt *statement = NULL;
    NSLog(@"更新离线下创建的笔记，联网之后保存服务器返回的数据到客户端』");
    if(noteInfo.noteID >0 ){
        NSString *updateSQL = [NSString stringWithFormat:@"update notes set has_network = '%ld' , serverTime = '%@' ,noteUIID= '%@' where id = ? ",noteInfo.has_network,noteInfo.serverTime,noteInfo.noteUIID];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(_noteDatabase, update_stmt, -1, &statement, NULL);
        sqlite3_bind_int(statement, 1, noteInfo.noteID);
        if(sqlite3_step(statement) == SQLITE_DONE){
            success();
        }else{
            NSLog(@"存取失败");
           failed();
        }
    }

}
//保存服务器端有更新而客户端没更新的笔记,先用noteID查询找到该笔记
-(void)saveDeleteNoteToLocal:(NoteInfo*)noteInfo success:(void (^)(void))success failed:(void (^)(void))failed
{
    sqlite3_stmt *statement = NULL;
    NSLog(@"保存删除的笔记到本地数据库");
    NSString *updateSQL = [NSString stringWithFormat:@"update notes set updateDateString = '%@' , modif_people = '%@' ,has_network ='%ld' ,is_delete = '%ld' where id = ?",noteInfo.updateDateString,noteInfo.modf_people,noteInfo.has_network,noteInfo.is_delete];
    const char *update_stmt = [updateSQL UTF8String];
    sqlite3_prepare_v2(_noteDatabase, update_stmt, -1, &statement, NULL);
    sqlite3_bind_int(statement, 1, noteInfo.noteID);
    
    if(sqlite3_step(statement) == SQLITE_DONE){
        success();
    }else{
        NSLog(@"存取失败");
        failed();
    }
    
}
-(void)saveUpdateNoteToLocal:(NoteInfo*)noteInfo success:(void (^)(void))success failed:(void (^)(void))failed
{
    sqlite3_stmt *statement = NULL;
    NSLog(@"保存本地更新的笔记到本地数据库");
    NSString *updateSQL = [NSString stringWithFormat:@"update notes set contents = '%@' ,updateDateString = '%@' , modif_people = '%@' ,has_network ='%ld' ,is_delete = '%ld' ,serverTime = '%@' where id = ? ",noteInfo.noteContents,noteInfo.updateDateString,noteInfo.modf_people,noteInfo.has_network,noteInfo.is_delete,noteInfo.serverTime];
    const char *update_stmt = [updateSQL UTF8String];
    sqlite3_prepare_v2(_noteDatabase, update_stmt, -1, &statement, NULL);
    sqlite3_bind_int(statement, 1, noteInfo.noteID);
    
    if(sqlite3_step(statement) == SQLITE_DONE){
        success();
    }else{
        NSLog(@"存取失败");
        failed();
    }
}
-(void)saveServerNoteContentHasChangeToLocal:(NoteInfo*)noteInfo success:(void (^)(void))success failed:(void (^)(void))failed
{
    sqlite3_stmt *statement =NULL;
     NSLog(@"Existing data,update please");
    
    NSString *updateSQL = [NSString stringWithFormat:@"update notes set contents = '%@', updateDateString = '%@', modif_people = '%@',has_network ='%ld',is_delete = '%ld' where noteUIID = '%@'",noteInfo.noteContents,noteInfo.updateDateString,noteInfo.modf_people,noteInfo.has_network,noteInfo.is_delete,noteInfo.noteUIID];
    const char *update_stmt = [updateSQL UTF8String];
    sqlite3_prepare_v2(_noteDatabase, update_stmt, -1, &statement, NULL);
    
    
    if(sqlite3_step(statement) == SQLITE_DONE){
        success();
    }else{
        NSLog(@"存取失败");
        failed();
    }

}
//保存在客户端新创建的笔记 or 保存服务器端有的而客户端没有的笔记,先在本地查询noteID，如果没有，则调用此方法保存在本地
-(void)saveNewNote:(NoteInfo*)noteInfo success:(void (^)(void))success failed:(void (^)(void))failed
{
    sqlite3_stmt *statement = NULL;
    NSLog(@"new note ,insert");
    NSString *insertSQL;
  //  if(noteInfo.hasPatientData){
        insertSQL = [NSString stringWithFormat:@"INSERT into notes    (titleName,contents,creatDateString,updateDateString,createPeople,noteUIID,note_type,serverTime,is_delete,is_public,modif_people,has_network,profileImage,area,location,name,gender,age) values (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%d\",\"%d\",\"%@\",\"%d\",\"%d\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",noteInfo.titleName,noteInfo.noteContents,noteInfo.creatDateString,noteInfo.updateDateString,noteInfo.createNotePeople,noteInfo.noteUIID,noteInfo.note_type,noteInfo.serverTime,noteInfo.is_delete,noteInfo.is_public,noteInfo.modf_people,noteInfo.has_network,noteInfo.patientInfo.personImage,noteInfo.patientInfo.area,noteInfo.patientInfo.location,noteInfo.patientInfo.name,noteInfo.patientInfo.gender,noteInfo.patientInfo.age];
//    }else {
//        insertSQL = [NSString stringWithFormat:@"INSERT into notes    (titleName,contents,creatDateString,updateDateString,createPeople,noteUIID,note_type,serverTime,is_delete,is_public,modif_people,has_network,profileImage,area,location,name,gender,age) values (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%d\",\"%d\",\"%@\",\"%d\")",noteInfo.titleName,noteInfo.noteContents,noteInfo.creatDateString,noteInfo.updateDateString,noteInfo.createNotePeople,noteInfo.noteUIID,noteInfo.note_type,noteInfo.serverTime,noteInfo.is_delete,noteInfo.is_public,noteInfo.modf_people,noteInfo.has_network];
//    }

    
    const char *insert_stmt = [insertSQL UTF8String];
    if(sqlite3_prepare_v2(_noteDatabase, insert_stmt, -1, &statement, NULL) == SQLITE_OK){
//        if(noteInfo.hasPatientData){
//            sqlite3_bind_blob(statement, 0, [noteInfo.patientInfo.personImage bytes], [noteInfo.patientInfo.personImage length], SQLITE_TRANSIENT);
//        }
        
        if(sqlite3_step(statement) == SQLITE_DONE){
            NSLog(@"成功存入数据");
            success();
            
        }else {
            NSLog(@"存入数据失败");
            failed();
        }
        sqlite3_finalize(statement);
    };
}

//得到客户端某个用户的所有的笔记
-(NSArray*)getAllNotesFromLocalByUser:(NSString*)userName success:(void (^)(void))success failed:(void (^)(void))failed
{
    NSMutableArray *notes = [[NSMutableArray alloc]init];

    sqlite3_stmt *statement;
    int d = 0;
   // NSString *querySQL =[NSString stringWithFormat:@"SELECT * from notes order by DESC where createPeople=%@",userName];
    NSString *querySQL =[NSString stringWithFormat:@"SELECT * from notes where createPeople= '%@' and is_delete = '%d' ",userName,d];
   // NSString *querySQL =[NSString stringWithFormat:@"SELECT * from notes where createPeople = '%@' ",userName];

    const char *query_stmt = [querySQL UTF8String];
    
    if(sqlite3_prepare_v2(_noteDatabase, query_stmt, -1, &statement, NULL) == SQLITE_OK){
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            NSInteger noteID = sqlite3_column_int(statement, 0);
            NSString *titleName = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 1) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 1)];
            NSString *noteContents = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 2) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 2)];
            NSString *creatDateString = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 3) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 3)];
            NSString  *updateDateString = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 4) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 4)];
            NSString *createNotePeople = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 5) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 5)];
            NSString *noteUIID = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 6) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 6)];
            NSString *note_type = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 7) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 7)];
            NSString *serverTime = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 8) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 8)];
            NSInteger is_delete = sqlite3_column_int(statement, 9);
            NSInteger is_public = sqlite3_column_int(statement, 10);
            NSString *modefPeople = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 11) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 11)];
            NSInteger hasNetwork = sqlite3_column_int(statement, 12);
            
           // NoteInfo *noteInfo = [[NoteInfo alloc] initWithNoteID:noteID NoteTitleName:titleName NoteContents:noteContents CreateDateString:creatDateString UpdateString:updateDateString NoteUUID:noteUIID CreateNotePeople:createNotePeople noteType:note_type serverTime:serverTime isDelete:is_delete isPublic:is_public modif_people:modefPeople has_network:hasNetwork];
            
            
            NSData *imageData = [NSData dataWithBytes:sqlite3_column_blob(statement, 13) length:sqlite3_column_bytes(statement, 13)];
            NSString *area = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 14) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 14)];
            NSString *location = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 15) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 15)];
            NSString *name = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 16) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 16)];
            NSString *gender = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 17) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 17)];
            NSString *age = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 18) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 18)];
            
            PatientData *patientInfo = [[PatientData alloc] initWithProfileImage:imageData area:area location:location name:name gender:gender age:age];
           NoteInfo *noteInfo = [[NoteInfo alloc] initWithNoteID:noteID NoteTitleName:titleName NoteContents:noteContents CreateDateString:creatDateString UpdateString:updateDateString NoteUUID:noteUIID CreateNotePeople:createNotePeople noteType:note_type serverTime:serverTime isDelete:is_delete isPublic:is_public modif_people:modefPeople has_network:hasNetwork patientInfo:patientInfo];
            [notes addObject:noteInfo];
        }
      

        NSLog(@"成功load数据");
        success();
        sqlite3_finalize(statement);
    }
    return notes;

}
//得到客户端数据库中的所有笔记
-(NSMutableArray *)getAllNotesFromLocalDatabase
{
    NSMutableArray *notes = [[NSMutableArray alloc]init];

    sqlite3_stmt *statement;
    
    NSString *querySQL = @"SELECT * from notes order by serverTime DESC";
    const char *query_stmt = [querySQL UTF8String];
    
    if(sqlite3_prepare_v2(_noteDatabase, query_stmt, -1, &statement, NULL) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSInteger noteID = sqlite3_column_int(statement, 0);
            
            NSString *titleName = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 1) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 1)];
            NSString *noteContents = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 2) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 2)];
            NSString *creatDateString = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 3) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 3)];
            NSString  *updateDateString = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 4) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 4)];
            NSString *createNotePeople = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 5) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 5)];
            NSString *noteUIID = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 6) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 6)];
            NSString *note_type = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 7) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 7)];
            NSString *serverTime = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 8) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 8)];
            NSInteger is_delete = sqlite3_column_int(statement, 9);
            NSInteger is_public = sqlite3_column_int(statement, 10);
            NSString *modefPeople = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 11) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 11)];
            NSInteger hasNetwork = sqlite3_column_int(statement, 12);
            NoteInfo *noteInfo = [[NoteInfo alloc] initWithNoteID:noteID NoteTitleName:titleName NoteContents:noteContents CreateDateString:creatDateString UpdateString:updateDateString NoteUUID:noteUIID CreateNotePeople:createNotePeople noteType:note_type serverTime:serverTime isDelete:is_delete isPublic:is_public modif_people:modefPeople has_network:hasNetwork];
            [notes addObject:noteInfo];
        }
        sqlite3_finalize(statement);
    }
    return  notes;
}



-(NSMutableArray*)getAllNotesFromTable:(NSString *)tableName ByUser:(NSString *)userName
{
    NSMutableArray *notes = [[NSMutableArray alloc]init];
    // const char *dbPath = [_databasePath UTF8String];
    
    sqlite3_stmt *statement;
    
   NSString *querySQL =[NSString stringWithFormat:@"SELECT * from %@ where createPeople='%@'",tableName,userName];
   // NSString *querySQL =[NSString stringWithFormat:@"SELECT * from notes order by DESC "];
    const char *query_stmt = [querySQL UTF8String];
    
    
    if(sqlite3_prepare_v2(_noteDatabase, query_stmt, -1, &statement, NULL) == SQLITE_OK){
       
        while (sqlite3_step(statement) == SQLITE_ROW) {

            NSInteger noteID = sqlite3_column_int(statement, 0);
            NSString *titleName = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 1) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 1)];
            NSString *noteContents = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 2) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 2)];
            NSString *creatDateString = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 3) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 3)];
            NSString  *updateDateString = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 4) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 4)];
            NSString *createNotePeople = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 5) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 5)];
            NSString *noteUIID = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 6) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 6)];
            NSString *note_type = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 7) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 7)];
            NSString *serverTime = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 8) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 8)];
            NSInteger is_delete = sqlite3_column_int(statement, 9);
            NSInteger is_public = sqlite3_column_int(statement, 10);
            NSString *modefPeople = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 11) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 11)];
            NSInteger hasNetwork = sqlite3_column_int(statement, 12);
            
           NoteInfo *noteInfo = [[NoteInfo alloc] initWithNoteID:noteID NoteTitleName:titleName NoteContents:noteContents CreateDateString:creatDateString UpdateString:updateDateString NoteUUID:noteUIID CreateNotePeople:createNotePeople noteType:note_type serverTime:serverTime isDelete:is_delete isPublic:is_public modif_people:modefPeople has_network:hasNetwork];
            [notes addObject:noteInfo];
        }
        sqlite3_finalize(statement);
    }
    return notes;
}
//for table notes
-(void)saveNotes:(NSArray*)notes success:(void (^)(void))success
{
    sqlite3_stmt *statement;
    
    NSLog(@"New note,insert please");
    
   // NSString *insertSQL =@"INSERT INTO notes (titleName,contents,creatDateString,updateDateString,createPeople,noteUIID,note_type,serverTime,is_delete,is_public,modif_people,has_network) values (?,?,?,?,?,?,?,?,?,?,?,?)";
    NSString *insertSQL =@"INSERT INTO notes (titleName,contents,creatDateString,updateDateString,createPeople,noteUIID,note_type,serverTime,is_delete,is_public,modif_people,has_network,profileImage,area,location,name,gender,age) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    const char *insert_stmt = [insertSQL UTF8String];
    
    sqlite3_exec(_noteDatabase, "BEGIN EXCLUSIVE TRANSACTION", 0, 0, 0);
    if(sqlite3_prepare_v2(_noteDatabase, insert_stmt, -1, &statement,nil) == SQLITE_OK){
        
        for(NoteInfo *noteInfo in notes){
            sqlite3_bind_text(statement, 1, [noteInfo.titleName UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 2, [noteInfo.noteContents UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 3, [noteInfo.creatDateString UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 4, [noteInfo.updateDateString UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 5, [noteInfo.createNotePeople UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 6, [noteInfo.noteUIID UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 7, [noteInfo.note_type UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 8, [noteInfo.serverTime UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_int(statement, 9, noteInfo.is_delete);
            sqlite3_bind_int(statement, 10, noteInfo.is_public);
            sqlite3_bind_text(statement, 11, [noteInfo.titleName UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_int(statement, 12, noteInfo.has_network);
            
            //patient data
           
                sqlite3_bind_blob(statement, 13, [noteInfo.patientInfo.personImage bytes], [noteInfo.patientInfo.personImage length], SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 14, [noteInfo.patientInfo.area UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 15, [noteInfo.patientInfo.location UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 16, [noteInfo.patientInfo.name UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 17, [noteInfo.patientInfo.gender UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 18, [noteInfo.patientInfo.age UTF8String], -1, SQLITE_TRANSIENT);
                
            
            if(sqlite3_step(statement) != SQLITE_OK) NSLog(@"SQL Error: %s",sqlite3_errmsg(_noteDatabase));
            if (sqlite3_reset(statement) != SQLITE_OK) NSLog(@"SQL Error: %s",sqlite3_errmsg(_noteDatabase));
        }
        if (sqlite3_finalize(statement) != SQLITE_OK) NSLog(@"SQL Error: %s",sqlite3_errmsg(_noteDatabase));
        if (sqlite3_exec(_noteDatabase, "COMMIT TRANSACTION", 0, 0, 0) != SQLITE_OK) {
            NSLog(@"SQL Error: %s",sqlite3_errmsg(_noteDatabase));

        }else {
            success();
        }
    } else {
        NSLog(@"sql error");
    }
    // sqlite3_bind_text(statement, <#int#>, <#const char *#>, <#int n#>, <#void (*)(void *)#>)
    //           if(sqlite3_step(statement) == SQLITE_OK){
    //               sucess = true;
    //            }
   // sqlite3_finalize(statement);

}
-(BOOL)saveNote:(NoteInfo *)noteInfo success:(void (^)(void))success
{
    
    NSLog(@"self.saveNote, noteInfo.titleName %@,noteInfo.contents %@,noteInfo.creatDateString %@,noteInfo.updateDateString %@,noteInfo.creatPeople %@,noteInfo.noteUUID %@,noteInfo.note_type %@,noteInfo.serverTime %@,noteInfo.is_delete %d,noteInfo.is_public %d,modif_people %@",noteInfo.titleName,noteInfo.noteContents,noteInfo.creatDateString,noteInfo.updateDateString,noteInfo.createNotePeople,noteInfo.noteUIID,noteInfo.note_type,noteInfo.serverTime,noteInfo.is_delete,noteInfo.is_public,noteInfo.modf_people);
    
    BOOL sucess = false;
    sqlite3_stmt *statement = NULL;
   // const char *dbPath = [_databasePath UTF8String];
   // if(sqlite3_open(dbPath, &(_noteDatabase)) == SQLITE_OK){
        if(noteInfo.noteID > 0){
            NSLog(@"Existing data,update please");
            NSString *updateSQL = [NSString stringWithFormat:@"update notes set contents = '%@', updateDateString = '%@',serverTime = '%@', modif_people = '%@' where id = ?",noteInfo.noteContents,noteInfo.updateDateString,noteInfo.serverTime,noteInfo.modf_people];
            //  NSString *updateSQL = [NSString stringWithFormat:@"update notes set  updateDateString = '%@' where id = ?",noteInfo.updateDateString];
            const char *update_stmt = [updateSQL UTF8String];
            sqlite3_prepare_v2(_noteDatabase, update_stmt, -1, &statement, NULL);
            
            sqlite3_bind_int(statement, 1, noteInfo.noteID);
            if(sqlite3_step(statement) == SQLITE_DONE){
                sucess = true;
                //success();
               // [self.delegate sucessSaveToDataBase];
            }else{
                NSLog(@"存取失败");
                
            }
        }else {
            NSLog(@"New note,insert please");
            
            NSString *insertSQL = [NSString stringWithFormat:@"INSERT into notes (titleName,contents,creatDateString,updateDateString,createPeople,noteUIID,note_type,serverTime,is_delete,is_public,modif_people) values (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%ld\",\"%ld\",\"%@\")",noteInfo.titleName,noteInfo.noteContents,noteInfo.creatDateString,noteInfo.updateDateString,noteInfo.createNotePeople,noteInfo.noteUIID,noteInfo.note_type,noteInfo.serverTime,(long)noteInfo.is_delete,noteInfo.is_public,noteInfo.modf_people];
//            NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO notes(titleName,contents,creatDateString,updateDateString) values (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",noteInfo.createNotePeople,noteInfo.titleName,noteInfo.noteContents,noteInfo.creatDateString,noteInfo.updateDateString];
           // NSString *insertSQL = @"INSERT into notes values(?,?,?,?,?,?,?,?,?,?,?,?,?)";
            const char *insert_stmt = [insertSQL UTF8String];
            if(sqlite3_prepare_v2(_noteDatabase, insert_stmt, -1, &statement, NULL) == SQLITE_OK){
                
                
                if(sqlite3_step(statement) == SQLITE_DONE){
                    NSLog(@"成功存入数据");
                    sucess = true;
                    
                }else {
                    NSLog(@"存入数据失败");
                }
                
            };
           // sqlite3_bind_text(statement, <#int#>, <#const char *#>, <#int n#>, <#void (*)(void *)#>)
//           if(sqlite3_step(statement) == SQLITE_OK){
//               sucess = true;
//            }
            sqlite3_finalize(statement);
        }
//    }else {
//        NSLog(@"Failed to open database!");
//    }
    
   // sqlite3_close(_noteDatabase);
    return sucess;
}
//get all notes
-(NSMutableArray *)getNotes
{
    NSMutableArray *notes = [[NSMutableArray alloc]init];
   // const char *dbPath = [_databasePath UTF8String];
    
    sqlite3_stmt *statement;
    
   // if(sqlite3_open(dbPath, &_noteDatabase) == SQLITE_OK){
       // NSString *querySQL = @"SELECT id, titleName,contents,creatDateString,updateDateString,createPeople,noteUIID,note_type,serverTime,is_delete,is_public) from notes order by serverTime DESC";
   // NSString *querySQL = @"SELECT * from notes order by serverTime DESC";
    NSString *querySQL =[NSString stringWithFormat:@"SELECT * from notes where createPeople='4'"];
   // NSString *querySQL =[NSString stringWithFormat:@"SELECT * from notes from notes WHERE createPeople='%@'",name];
   // NSString *querySQL = @"SELECT * from notes where createPeople='2'";
        const char *query_stmt = [querySQL UTF8String];
        
        if(sqlite3_prepare_v2(_noteDatabase, query_stmt, -1, &statement, NULL) == SQLITE_OK){
            while (sqlite3_step(statement) == SQLITE_ROW) {
               // NoteInfo *noteInfo = [[NoteInfo alloc] init];
                NSInteger noteID = sqlite3_column_int(statement, 0);
                
                NSString *titleName = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 1) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 1)];
                NSString *noteContents = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 2) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 2)];
                NSString *creatDateString = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 3) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 3)];
                NSString  *updateDateString = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 4) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 4)];
                NSString *createNotePeople = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 5) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 5)];
                NSString *noteUIID = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 6) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 6)];
                NSString *note_type = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 7) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 7)];
                NSString *serverTime = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 8) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 8)];
                NSInteger is_delete = sqlite3_column_int(statement, 9);
                NSInteger is_public = sqlite3_column_int(statement, 10);
                NSString *modefPeople = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 11) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 11)];
                NSInteger hasNetwork = sqlite3_column_int(statement, 12);
               NoteInfo *noteInfo = [[NoteInfo alloc] initWithNoteID:noteID NoteTitleName:titleName NoteContents:noteContents CreateDateString:creatDateString UpdateString:updateDateString NoteUUID:noteUIID CreateNotePeople:createNotePeople noteType:note_type serverTime:serverTime isDelete:is_delete isPublic:is_public modif_people:modefPeople has_network:hasNetwork];
                [notes addObject:noteInfo];
            }
            sqlite3_finalize(statement);
        }
        //sqlite3_close(_noteDatabase);
   // }
   
    return  notes;
}
//get user notes by create people
//-(NSMutableArray *)getNotesForUser:(NSString *)user
//{
//    NSMutableArray *notes = [[NSMutableArray alloc]init];
//   // const char *dbPath = [_databasePath UTF8String];
//    
//    sqlite3_stmt *statement;
//    
//   // if(sqlite3_open(dbPath, &_noteDatabase) == SQLITE_OK){
//        NSString *querySQL = [NSString stringWithFormat:@"SELECT id, titleName,contents,creatDateString,updateDateString,createPeople,noteUIID from notes WHERE createPeople=%@",user];
//        //NSString *querySQL = @"SELECT id, titleName,contents,creatDateString,updateDateString,createPeople,noteUIID from notes where";
//        const char *query_stmt = [querySQL UTF8String];
//        
//        if(sqlite3_prepare_v2(_noteDatabase, query_stmt, -1, &statement, NULL) == SQLITE_OK){
//            while (sqlite3_step(statement) == SQLITE_ROW) {
//               // NoteInfoDetail *noteInfoDetail = [[NoteInfoDetail alloc] init];
//                
//                NSString *updateDateString = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 4) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 4)];
//               NSString *noteUIID = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 6) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 6)];
//               NSString *titlename = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 1) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 1)];
//               // NoteInfoDetail *noteInfoDetail  = [[NoteInfoDetail alloc] initWithNoteUUID:noteUIID updateString:updateDateString TitleName:titlename];
//               // [notes addObject:noteInfoDetail];
//            }
//            sqlite3_finalize(statement);
//        }
//       // sqlite3_close(_noteDatabase);
//    //}
//    
//    return  notes;
//}
#warning message
////get notes content
-(NSString*)getNoteContentsByNoteUUID:(NSString*)noteUUID
{
    NSString *noteContent;
    sqlite3_stmt *statement;
   // NSString *user = @"DFGDFGDG";
  //  NSString *querySQL = [NSString stringWithFormat:@"SELECT id, titleName,contents,creatDateString,updateDateString,createPeople,noteUIID from notes WHERE noteUIID=%@",noteUUID];
    NSString *querySQL = [NSString stringWithFormat:@"SELECT id, titleName,contents,creatDateString,updateDateString,createPeople,noteUIID from notes WHERE noteUIID = '%@'",noteUUID];
    //NSString *querySQL = @"SELECT id, titleName,contents,creatDateString,updateDateString,createPeople,noteUIID from notes where";
    const char *query_stmt = [querySQL UTF8String];
    
    if(sqlite3_prepare_v2(_noteDatabase, query_stmt, -1, &statement, NULL) == SQLITE_OK){
        if (sqlite3_step(statement) == SQLITE_ROW) {
            // NoteInfoDetail *noteInfoDetail = [[NoteInfoDetail alloc] init];
            
            NSString *noteContents = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 2) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 2)];
            noteContent = noteContents;
        }
        sqlite3_finalize(statement);
    }
    return noteContent;
}
//get info about a specific note by its id
-(NoteInfo *)getNote:(NSInteger)noteID
{
    NoteInfo *noteInfo = [[NoteInfo alloc]init];
  //  const char *dbPath = [_databasePath UTF8String];
    sqlite3_stmt *statement;
    
   // if(sqlite3_open(dbPath, &_noteDatabase) == SQLITE_OK){
        NSString *querySQL = [NSString stringWithFormat:@"SELECT id, titleName,contents from notes where id=%ld",(long)noteID];
        const char *query_stmt = [querySQL UTF8String];
        if(sqlite3_prepare_v2(_noteDatabase, query_stmt, -1, &statement, NULL) == SQLITE_OK){
            if(sqlite3_step(statement) == SQLITE_ROW){
                noteInfo.noteID = sqlite3_column_int(statement, 0);
                noteInfo.titleName = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 1)];
                noteInfo.noteContents = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 2)];
            }
            sqlite3_finalize(statement);
        }
      //  sqlite3_close(_noteDatabase);
    //}
   
    return noteInfo;
}
//-(BOOL)deleteNote:(NoteInfo *)noteInfo
//{
//    BOOL sucess = false;
//    sqlite3_stmt *statement = NULL;
//    const char *dbPath = [_databasePath UTF8String];
//    //if(sqlite3_open(dbPath, &_noteDatabase)== SQLITE_OK){
//        if(noteInfo.noteID >0){
//            NSLog(@"Existing data,delete please");
//            NSString *deleteSQL = [NSString stringWithFormat:@"delete from notes where id = ?"];
//            
//            const char *delete_stmt = [deleteSQL UTF8String];
//            sqlite3_prepare_v2(_noteDatabase, delete_stmt, -1, &statement, NULL);
//            sqlite3_bind_int(statement, 1, noteInfo.noteID);
//            if(sqlite3_step(statement) == SQLITE_DONE){
//                sucess = true;
//            }
//        }else {
//            NSLog(@"new data,nothing to delete");
//            sucess = true;
//        }
//        
//        sqlite3_finalize(statement);
//       // sqlite3_close(_noteDatabase);
//    //}
//    return sucess;
//}

//得到用户的部分笔记
-(NSArray*)getNotesFromLocalByUser:(NSString*)userName nBaseRow:(NSInteger)indexPathRow nNumRecord:(NSInteger)nNumRecord success:(void (^)(void))success failed:(void (^)(void))failed
{
    NSMutableArray *notes = [[NSMutableArray alloc]init];
    
    sqlite3_stmt *statement;
    int d = 0;
    int flag = 0;
    // NSString *querySQL =[NSString stringWithFormat:@"SELECT * from notes order by DESC where createPeople=%@",userName];
    NSString *querySQL =[NSString stringWithFormat:@"SELECT * from notes where createPeople= '%@' and is_delete = '%d' order by updateDateString DESC limit '%ld' offset '%ld' ",userName,d,nNumRecord,indexPathRow];
    // NSString *querySQL =[NSString stringWithFormat:@"SELECT * from notes where createPeople = '%@' ",userName];
    
    const char *query_stmt = [querySQL UTF8String];
    
    if(sqlite3_prepare_v2(_noteDatabase, query_stmt, -1, &statement, NULL) == SQLITE_OK){
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NoteInfo *noteInfo;
            
            NSInteger noteID = sqlite3_column_int(statement, 0);
            NSString *titleName = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 1) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 1)];
            NSString *noteContents = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 2) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 2)];
            NSString *creatDateString = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 3) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 3)];
            NSString  *updateDateString = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 4) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 4)];
            NSString *createNotePeople = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 5) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 5)];
            NSString *noteUIID = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 6) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 6)];
            NSString *note_type = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 7) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 7)];
            NSString *serverTime = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 8) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 8)];
            NSInteger is_delete = sqlite3_column_int(statement, 9);
            NSInteger is_public = sqlite3_column_int(statement, 10);
            NSString *modefPeople = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 11) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 11)];
            NSInteger hasNetwork = sqlite3_column_int(statement, 12);
            
            
                NSData *imageData = [NSData dataWithBytes:sqlite3_column_blob(statement, 13) length:sqlite3_column_bytes(statement, 13)];
                NSString *area = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 14) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 14)];
                NSString *location = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 15) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 15)];
                NSString *name = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 16) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 16)];
                NSString *gender = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 17) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 17)];
                NSString *age = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 18) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 18)];
            PatientData *patientInfo = [[PatientData alloc] initWithProfileImage:imageData area:area location:location name:name gender:gender age:age];
                noteInfo = [[NoteInfo alloc] initWithNoteID:noteID NoteTitleName:titleName NoteContents:noteContents CreateDateString:creatDateString UpdateString:updateDateString NoteUUID:noteUIID CreateNotePeople:createNotePeople noteType:note_type serverTime:serverTime isDelete:is_delete isPublic:is_public modif_people:modefPeople has_network:hasNetwork patientInfo:patientInfo];
           
            
                [notes addObject:noteInfo];
        }
        
        flag = 1;
        NSLog(@"成功load数据");
       
        sqlite3_finalize(statement);
    }
    
    if(flag == 1){
        success();
    }
    return notes;
    
}


//get max row number
-(NSUInteger)getMaxRowNumberByNoteUser:(NSString*)noteUser success:(void (^)(void))success failed:(void (^)(void))failed
{
    NSUInteger maxRowNumber = 0;
    sqlite3_stmt *statement;
     NSString *querySQL =[NSString stringWithFormat:@"SELECT COUNT(*) from notes where createPeople = '%@' and is_delete = 0",noteUser];
    const char *query_stmt = [querySQL UTF8String];
    
    if(sqlite3_prepare_v2(_noteDatabase, query_stmt, -1, &statement, NULL) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW) {
            maxRowNumber = sqlite3_column_int(statement, 0);
        }
        NSLog(@"max row number is %ld",maxRowNumber);
        success();
    }else {
        NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(_noteDatabase) );
        NSLog(@"找出表中最大的行数失败");
        failed();
    }
    sqlite3_finalize(statement);
    
    return maxRowNumber;
}
//
//get max server time
-(NSString*)getMaxServerTimeByNoteUser:(NSString*)noteUser
{
    NSString *maxServerTime;
    sqlite3_stmt *statement;
  
   // NSString *querySQL = @"SELECT * from notes order by serverTime DESC limit 1";
  //  NSString *querySQL =[NSString stringWithFormat:@"SELECT * from notes order by serverTime ASC limit 1 where createPeople = '%@'",noteUser];
    NSString *querySQL =[NSString stringWithFormat:@"SELECT * from notes where createPeople = '%@' and serverTime != '(null)' and is_delete = 0 order by serverTime DESC limit 1",noteUser];
    const char *query_stmt = [querySQL UTF8String];
    
    if(sqlite3_prepare_v2(_noteDatabase, query_stmt, -1, &statement, NULL) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW) {
            maxServerTime = [NSString stringWithUTF8String:((char*)sqlite3_column_text(statement, 8) == NULL) ? (char*)"":(char*)sqlite3_column_text(statement, 8)];
        }
        sqlite3_finalize(statement);
    }
  
    return maxServerTime;
}

//get table column count
-(NSInteger)getTableColumnCount:(NSString*)tableName
{
    NSInteger columnCount = 0;
    sqlite3_stmt *statement;
    NSString *querySQL = @"SELECT * from notes";
    const char *query_stmt = [querySQL UTF8String];
    if(sqlite3_prepare_v2(_noteDatabase, query_stmt, -1, &statement, NULL) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW) {
            columnCount++;
        }
        sqlite3_finalize(statement);
    }
    return columnCount;

}
@end