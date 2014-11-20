//
//  DisplayNoteViewController.h
//  NoteBook
//
//  Created by ihefe-JF on 14/11/4.
//  Copyright (c) 2014年 ihefe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IHMsgSocket.h"
#import "IHGCDReconnect.h"
#import <sqlite3.h>
@interface DisplayNoteViewController : UIViewController<IHMsgSocketDelegate>
@property (nonatomic,strong)IHMsgSocket *msgSocket;//新的网络通信模块
@end
