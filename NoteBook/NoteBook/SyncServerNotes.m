//
//  SyncServerNotes.m
//  NoteBook
//
//  Created by ihefe-JF on 14/11/19.
//  Copyright (c) 2014年 ihefe. All rights reserved.
//

#import "SyncServerNotes.h"
#import "NotebookDatabase.h"
#import  "NoteInfo.h"

@interface SyncServerNotes()
@property(nonatomic,strong)NotebookDatabase *database;
@property(nonatomic,strong) NSString *maxServerTime;
@property(nonatomic,strong)NoteInfo *myDeleteNote;
@property(nonatomic,strong)NoteInfo *updateNote;
@property(nonatomic,strong)NoteInfo *myNewNote;

@end
@implementation SyncServerNotes

static SyncServerNotes *sharedSyncServerNotes = nil;

+(SyncServerNotes *)sharedSyncServerNotes
{
    if(sharedSyncServerNotes != nil){
        return sharedSyncServerNotes;
    }
    static dispatch_once_t pred;
    dispatch_once(&pred,^{
        sharedSyncServerNotes = [[SyncServerNotes alloc] init];
    });
    return sharedSyncServerNotes;
}

-(id)init
{
    self = [super init];
    if(self) {
        _database = [NotebookDatabase initDatabase];
        //[self connectionToServer];
    }
    return self;
}
#pragma mask - 服务器方法
-(void)connectionToServer
{
    _msgSocket = [[IHMsgSocket alloc] init];
    _msgSocket.delegate = self;
    
    [_msgSocket connectToHost:@"192.168.10.106" onPort:2222];
}
#pragma mark - IHMsgSocketDelegate
//连接服务器失败
- (void)connectServerDefeat:(IHMsgSocket *)ihGcdSock
{
    self.connectionServerSucess = NO;
    //连接服务器失败
    NSLog(@"msgSocket 连接服务器失败");
    NSLog(@"连接失败");
    
}
//连接服务器成功
- (void)connectServerSucceed:(IHMsgSocket *)ihGcdSock
{
    //连接服务器成功
    NSLog(@"msgSocket 连接服务器成功");
    NSLog(@"连接成功");
    
    _msgSocket.userStr = _user;
    _msgSocket.passwordStr = _password;
    
    self.connectionServerSucess = YES;
    [self syncServerNotesWhenConnectionToServerSucess:YES];
}
//-(void)syncServerNotesWhenConnectionToServerSucess:(BOOL)connectionToServerSucess success:(void (^)(void))success failed:(void (^)(void))failed
-(void)syncServerNotesWhenConnectionToServerSucess:(BOOL)connectionToServerSucess
{
    if(connectionToServerSucess){
        self.maxServerTime = [self.database getMaxServerTimeByNoteUser:_user];
        if(self.maxServerTime == nil){
            self.maxServerTime = @"";
        }
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:_user forKey:@"user_id"];
        [dict setObject:self.maxServerTime forKey:@"max_stime"];
        [_msgSocket sendMsg:[self msgObjWithOptNumber:1329 dataDic:dict] selector:@selector(loadServerNotes:)];
        
    }else {
        NSLog(@"同步失败，请连接服务器");
        //failed();
    }
}
-(void)loadServerNotes:(IHSockRequest *)req
{
    if([req.responseData count] == 0) {
        NSLog(@"服务器端没有比客户端新的笔记");
    }else {
        NSMutableArray *serverNotes = [[NSMutableArray alloc] init];
        NoteInfo *noteInfoLocal;
        for(int i=0;i<[req.responseData count];i++){
            NoteInfo *noteInfo = [[NoteInfo alloc] init];
            
            NSDictionary *dict = req.responseData[i];
            noteInfo.noteContents = dict[@"content"];
            noteInfo.noteUIID = dict[@"note_id"];
            noteInfo.titleName = dict[@"note_name"];
            noteInfo.note_type = [NSString stringWithFormat:@"%@",dict[@"note_type"]];
            noteInfo.creatDateString = dict[@"create_time"];
            noteInfo.serverTime = dict[@"stime"];
            noteInfo.modf_people = dict[@"modif_people"] == nil ? @"":dict[@"modif_people"];
            noteInfo.is_public = (int)dict[@"is_public"];
            noteInfo.is_delete = 0;
            noteInfo.has_network = 1;
            noteInfo.updateDateString = dict[@"update_time"]== nil ?@"":dict[@"update_time"];
            noteInfo.createNotePeople = _msgSocket.userStr;
            
            if([self.maxServerTime isEqualToString:@"(null)"] || [self.maxServerTime isEqualToString:@""]){
                [serverNotes addObject:noteInfo];
                
            }else {
                noteInfoLocal =[self.database queryLocalNoteContentsByNoteUUID:noteInfo.noteUIID];
                
                if(!noteInfoLocal){
                    //服务器上的新笔记，需要保存到客户端
                    [self.database saveNewNote:noteInfo success:^{
                        NSLog(@"服务器端的新笔记保存到本地成功");
                       // [self reloadTableView:self.displayNotesView.showNoteTitlesTable detailTableView:self.displayNotesView.showNoteDetailTable];
                    } failed:^{
                        NSLog(@"服务器端的新笔记保存到本地失败");
                    }];
                } else {
                    //服务器上有更新的笔记
                    if(![noteInfoLocal.noteContents isEqualToString: noteInfo.noteContents]){
                        if(noteInfoLocal.has_network == 0){
                            //冲突笔记 作为新笔记保存到客户端
                            [self createNewNoteUseNote:noteInfoLocal];
                            
                            //冲突笔记 服务器端的笔记覆盖本地的笔记
                            noteInfo.noteID = noteInfoLocal.noteID;
                            [self.database saveServerNoteContentHasChangeToLocal:noteInfo success:^{
                                NSLog(@"冲突笔记：服务器端的笔记覆盖本地成功");
                              //  [self reloadTableView:self.displayNotesView.showNoteTitlesTable detailTableView:self.displayNotesView.showNoteDetailTable];
                                
                            } failed:^{
                                NSLog(@"冲突笔记：服务器端的笔记覆盖本地失败");
                            }];
                            
                        }else {
                            //本地没更新，但服务器端有更新的笔记
                            noteInfo.noteID = noteInfoLocal.noteID;
                            [self.database saveServerNoteContentHasChangeToLocal:noteInfo success:^{
                                NSLog(@"本地没更新，但服务器端有更新的笔记保存到本地成功");
                               // [self reloadTableView:self.displayNotesView.showNoteTitlesTable detailTableView:self.displayNotesView.showNoteDetailTable];
                                
                            } failed:^{
                                NSLog(@"本地没更新，但服务器端有更新的笔记保存到本地失败");
                            }];
                        }
                    }
                }
            }
            // [serverNotes addObject:noteInfo];
            
        }
        if([self.maxServerTime isEqualToString:@"(null)"] || [self.maxServerTime isEqualToString:@""]){
            [self.database saveNotes:serverNotes success:^{
                NSLog(@"更新服务器端更新的笔记』");
            }];
            
        }else {
           // [self reloadTableView:self.displayNotesView.showNoteTitlesTable detailTableView:self.displayNotesView.showNoteDetailTable];
        }
        //在保存以前要与local的note比较，找出has_network = NO 并且在本地查找noteUUID，如果找到则有冲突笔记，如果没找到则是新笔记应该插入到客户端数据库
        
    }
    //查找本地在断网下更新的笔记和新建的笔记 根据create time,update time,hasNotwork = 0，noteUUID
    //如果卡，可以再异步做
    NSArray *tempArray = [[NSArray alloc] initWithArray:[self.database queryLocalNoteContentsByHasNetwork:0 createPeople:_user]];
    //    NSMutableArray *updateNotes = [[NSMutableArray alloc] init];
    //    NSMutableArray *createNotes = [[NSMutableArray alloc] init];
    
    if(tempArray.count != 0){
        for(NoteInfo *noteInfo in tempArray){
            if(noteInfo.is_delete){
                if(![noteInfo.noteUIID isEqualToString:@"(null)"]){
                    //把在没网的情况下删除的笔记上传到服务器端
                    [self saveDeleteNoteToServer:noteInfo];
                }
                
            }else {
                if(!([noteInfo.noteUIID isEqualToString:@"(null)"]) && !([noteInfo.serverTime isEqualToString:@"(null)"])){
                    //本地离线下更新，需上传到服务器端
                    // [updateNotes addObject:noteInfo];
                    // [self saveToServerOrLocal:noteInfo];
                    //  [self saveToServer:note];
                    [self updateNoteAtFirstConnectedToNetwork:noteInfo];
                }else {
                    //本地离线下新建的
                    //[createNotes addObject:noteInfo];
                    [self saveNewNoteToServer:noteInfo];
                }
            }
        }
    }else {
        NSLog(@"本地在离线状态下没有创建和更新任何笔记");
    }
}
#pragma mask - 保存本地离线下新建的笔记到服务网器
-(void)saveNewNoteToServer:(NoteInfo*)newNote
{
    newNote.createNotePeople = _msgSocket.userStr;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:newNote.titleName forKey:@"note_name"];
    [dict setObject:newNote.noteContents forKey:@"content"];
    [dict setObject:newNote.creatDateString forKey:@"create_time"];
    [dict setObject:newNote.updateDateString forKey:@"update_time"];
    [dict setObject:newNote.createNotePeople forKey:@"create_people"];
    
    self.myNewNote = [[NoteInfo alloc] init];
    self.myNewNote = newNote;
    
    [_msgSocket sendMsg:[self msgObjWithOptNumber:1330 dataDic:dict] selector:@selector(createNoteFinished:)];
    NSLog(@"##########创建一篇新笔记");
    
}
- (void)createNoteFinished:(IHSockRequest *)req
{
    NSLog(@"req.responseDat:%@",req.responseData);
    NSLog(@"req.opt:%ld",(long)req.opt);
    NSLog(@"req.resp:%ld",(long)req.resp);
    //  NSLog(@"rep.resp:%@",req.requestData);
    
    NSMutableArray *reqArray = [NSMutableArray arrayWithArray:req.responseData];
    if(reqArray.count != 0){
        NSDictionary *reqDict = (NSDictionary*)reqArray[0];
        if(reqDict) {
            self.myNewNote.noteUIID = reqDict[@"note_id"];
            self.myNewNote.serverTime = reqDict[@"stime"];
        }
    }
    self.myNewNote.has_network = 1;
    self.myNewNote.createNotePeople = _msgSocket.userStr;
    self.myNewNote.modf_people = _msgSocket.userStr;
    
    [self.database updateNewNoteInfo:self.myNewNote success:^{
        NSLog(@"更新离线下新建的笔记，上传到服务器成功』");
        [self printNoteInfo:self.myNewNote];
        //[self reloadTableView:self.displayNotesView.showNoteTitlesTable detailTableView:self.displayNotesView.showNoteDetailTable];
    } failed:^{
        
    }];
}

#pragma mask - 上传离线下更新的笔记到服务器端
//用于当第一次联网时，update 在离线下的更新的笔记到服务器端
-(void)updateNoteAtFirstConnectedToNetwork:(NoteInfo*)noteInfo
{
    noteInfo.noteContents = [[noteInfo.rowContent valueForKey:@"description"] componentsJoinedByString:@"-"];
    noteInfo.updateDateString = [self convertCurrentDateToString];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:_msgSocket.userStr forKey:@"user_id"];
    [dict setObject:noteInfo.noteUIID forKey:@"note_id"];
    [dict setObject:noteInfo.titleName forKey:@"note_name"];
    [dict setObject:noteInfo.noteContents forKey:@"content"];
    [dict setObject:noteInfo.updateDateString forKey:@"update_time"];
    self.updateNote = [[NoteInfo alloc] init];
    self.updateNote = noteInfo;
    [self printNoteInfo:noteInfo];
    
    [_msgSocket sendMsg:[self msgObjWithOptNumber:1332 dataDic:dict] selector:@selector(updateNoteFinished:)];
    
}
-(void)updateNoteFinished:(IHSockRequest *)req
{
    NSLog(@"req.responseDat:%@",req.responseData);
    NSLog(@"req.opt:%ld",(long)req.opt);
    NSLog(@"req.resp:%ld",req.resp);
    
    NSString *sTime;
    if([req.responseData count] == 1){
        sTime = [req.responseData[0] objectForKey:@"stime"];
        NSLog(@"sTime:%@",sTime);
    }
    
    NSInteger resp = req.resp;
    switch (resp) {
        case 0:{
            //修改成功,保存到local
            self.updateNote.has_network = 1;
            self.updateNote.serverTime = sTime;
            break;
        }
        case -1:{
            //修改失败，用户没权限
            self.updateNote.has_network = 0;
            break;
        }
        case -2:{
            //修改失败，用户没权限
            self.updateNote.has_network = 0;
            break;
        }
        case -3:{
            //修改的笔记不存在
            self.updateNote.has_network = 0;
            break;
        }
        default:{
            NSLog(@"修改笔记失败，服务端返回值错误");
            self.updateNote.has_network = 0;
            break;
        }
    }
    [self saveUpdateNoteToLocal:self.updateNote];
}
-(void)saveUpdateNoteToLocal:(NoteInfo*)noteInfo
{
    [self.database saveUpdateNoteToLocal:noteInfo success:^{
        NSLog(@"保存修改的笔记到本地数据库成功");
        [self printNoteInfo:noteInfo];
    } failed:^{
        NSLog(@"保存修改的笔记到本地数据库失败");
    }];
}
#pragma mask - 保存删除的笔记到服务器端
//保存本地没网络时删除的笔记到服务器端
-(void)saveDeleteNoteToServer:(NoteInfo*)noteInfo
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:noteInfo.noteUIID forKey:@"note_id"];
    [dict setObject:noteInfo.createNotePeople forKey:@"user_id"];
    self.myDeleteNote = [[NoteInfo alloc] init];
    self.myDeleteNote = noteInfo;
    [_msgSocket sendMsg:[self msgObjWithOptNumber:1333 dataDic:dict] selector:@selector(deleteNote:)];
    
}
-(void)deleteNote:(IHSockRequest*)req
{
    NSLog(@"req.responseDat:%@",req.responseData);
    NSLog(@"req.opt:%ld",(long)req.opt);
    NSLog(@"req.resp:%ld",(long)req.resp);
    
    NSInteger resp = req.resp;
    switch (resp) {
        case 0:{
            NSLog(@"成功删除笔记");
            self.myDeleteNote.has_network = 1;
            self.myDeleteNote.modf_people = _msgSocket.userStr;
            //[self afterDeleteNoteSelectedIndexToNextIndexAtCurrentIndex:self.currentIndexPath];
            //[self saveDeleteNoteToLocal:self.myDeleteNote];
            break;
        }
        case 1:{
            NSLog(@"该笔记已被删除");
            self.myDeleteNote.has_network = 1;
            self.myDeleteNote.modf_people = _msgSocket.userStr;
            //[self afterDeleteNoteSelectedIndexToNextIndexAtCurrentIndex:self.currentIndexPath];
            break;
            
        }
        case -1:{
            //修改失败，用户没权限
            self.myDeleteNote.has_network = 0;
            break;
        }
        case -2:{
            //修改失败，用户没权限
            self.myDeleteNote.has_network = 0;
            break;
        }
        case -3:{
            //修改的笔记不存在
            self.myDeleteNote.has_network = 0;
            break;
        }
        default:{
            self.myDeleteNote.has_network = 0;
            NSLog(@"删除笔记失败，服务端返回值错误");
            break;
        }
    }
    [self saveDeleteNoteToLocal:self.myDeleteNote];
    
}
-(void)saveDeleteNoteToLocal:(NoteInfo*)noteInfo
{
    [self.database saveDeleteNoteToLocal:noteInfo success:^{
        NSLog(@"update success");
        //[self afterDeleteNoteSelectedIndexToNextIndexAtCurrentIndex:self.currentIndexPath];
        [self printNoteInfo:noteInfo];
    } failed:^{
        
    }];
}
#pragma mask - 辅助方法
-(void)printNoteInfo:(NoteInfo*)noteInfo
{
    NSLog(@"noteInfo.noteUUID : %@",noteInfo.noteUIID);
    NSLog(@"noteInfo.createNotePeople : %@",noteInfo.createNotePeople);
    NSLog(@"noteInfo content : %@",noteInfo.noteContents);
    NSLog(@"noteInfo creatdate : %@",noteInfo.creatDateString);
    NSLog(@"noteInfo updatedate : %@",noteInfo.updateDateString);
    NSLog(@"noteInfo titleName : %@",noteInfo.titleName);
    NSLog(@"noteInfo.note_type : %@",noteInfo.note_type);
    NSLog(@"noteInfo modf_people : %@",noteInfo.modf_people);
    NSLog(@"noteInfo is_delete : %ld",noteInfo.is_delete);
    NSLog(@"noteInfo is_public : %ld",noteInfo.is_public);
    NSLog(@"noteInfo has_network) : %ld",noteInfo.has_network);
    NSLog(@"noteInfo serverTime:%@",noteInfo.serverTime);
}

-(NSString*)convertCurrentDateToString
{
    NSString *retvString ;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss cc"];
    retvString = [formatter stringFromDate:[NSDate date]];
    NSLog(@"retvString date : %@",retvString);
    return retvString;
}
#pragma mask - 用一篇笔记来创建新的笔记
-(void)createNewNoteUseNote:(NoteInfo*)noteInfo
{
    NoteInfo *tempNoteInfo = [[NoteInfo alloc]init];
    NSString *dateString = [self convertCurrentDateToString];
    tempNoteInfo.noteContents = noteInfo.noteContents;
    tempNoteInfo.creatDateString = dateString;
    tempNoteInfo.updateDateString = dateString;
    tempNoteInfo.has_network = 0;
    tempNoteInfo.note_type = noteInfo.note_type;
    tempNoteInfo.is_public = 0;
    tempNoteInfo.is_delete = 0;
    tempNoteInfo.createNotePeople = noteInfo.createNotePeople;
    tempNoteInfo.modf_people = noteInfo.modf_people;
    tempNoteInfo.titleName = noteInfo.titleName;
    
    [self.database saveNewNote:tempNoteInfo success:^{
        NSLog(@"冲突笔记：客户端的笔记作为新笔记保存到客户端成功");
       // [self reloadTableView:self.displayNotesView.showNoteTitlesTable detailTableView:self.displayNotesView.showNoteDetailTable];
    } failed:^{
        NSLog(@"冲突笔记：客户端的笔记作为新笔记保存到客户端失败");
    }];
}

//生成接口请求对象
- (MessageObject *)msgObjWithOptNumber:(int)optNumber dataDic:(id)aDataDic
{
    MessageObject *msgObj = [[MessageObject alloc] init];
    msgObj.sync_usrStr = _msgSocket.userStr;
    msgObj.sync_pwdStr = _msgSocket.passwordStr;
    msgObj.sync_optInt = optNumber;
    msgObj.sync_snStr = CurrentDate;
    msgObj.sync_data = aDataDic;
    
    NSLog(@"CurrentDate:%@",CurrentDate);
    
    //设备注册,版本检查
    if(optNumber == 393 || optNumber == 397)
    {
        msgObj.sync_usrStr = _user;
        msgObj.sync_pwdStr = @"test";
    }
    
    return msgObj;
}

@end
