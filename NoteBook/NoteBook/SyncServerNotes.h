//
//  SyncServerNotes.h
//  NoteBook
//
//  Created by ihefe-JF on 14/11/19.
//  Copyright (c) 2014年 ihefe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IHMsgSocket.h"
#import "IHGCDReconnect.h"
#import <sqlite3.h>

@interface SyncServerNotes : NSObject<IHMsgSocketDelegate>
@property (nonatomic,strong)IHMsgSocket *msgSocket;//新的网络通信模块

@property(nonatomic)BOOL connectionServerSucess;

@property(nonatomic,strong) NSString *user;
@property(nonatomic,strong) NSString *password;

-(void)connectionToServer;
+(SyncServerNotes*)sharedSyncServerNotes;
-(void)syncServerNotesWhenConnectionToServerSucess:(BOOL)connectionToServerSucess;
@end
