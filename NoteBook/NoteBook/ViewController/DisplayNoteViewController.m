//
//  DisplayNoteViewController.m
//  NoteBook
//
//  Created by ihefe-JF on 14/11/4.
//  Copyright (c) 2014年 ihefe. All rights reserved.
//  noteInfo.createNotePeople = @"defaultPeople"

//离线状态下创建的笔记，noteUUID = NULL;hasNetWork = 0;noteInfo_modfPeople = @"defaultPeople";noteInfo.creatNotePeople = @"defaultPeople"
//离线状态下更新的笔记，更新离线创建的笔记  noteUUID = NULL;hasNetWork = 0;noteInfo_modfPeople = @"defaultPeople";noteInfo.creatNotePeople = @"defaultPeople"
//                  更新在线创建的笔记  noteUUID = origin;hasNetWork = 0;noteInfo_modfPeople = @"defaultPeople";noteInfo.creatNotePeople=_msgSocket_user
//在离线状态下无法判定新创建的笔记用户是谁，所以默认从本地数据库load所有的在离线时创建的笔记，load本地数据库中所有的笔记

#import "DisplayNoteViewController.h"
#import "DisplayNotesView.h"
#import "NotebookDatabase.h"
#import "NoteInfo.h"
#import "PatientDetailTableViewCell.h"
#import "NoteInfoDetail.h"
#import "TempView.h"

@interface DisplayNoteViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate,PatientNoteDetailTableViewDelegate>
@property(strong,nonatomic) DisplayNotesView *displayNotesView;

@property(strong,nonatomic) NotebookDatabase *database;

//@property(strong,nonatomic) NSMutableArray *rowContent;
@property(strong,nonatomic) NSMutableArray *rowHeights;

@property(strong,nonatomic) NSMutableArray *notes;
@property(strong,nonatomic) NoteInfo *noteInfo;

@property(strong,nonatomic)UISearchDisplayController *strongSearchDisplayController;
@property(strong,nonatomic)NSMutableArray *filiterNotes;

@property(strong,nonatomic)NoteInfo *selectedNoteInfo;

@property(strong,nonatomic)NSIndexPath *currentIndexPath;
@property(strong,nonatomic) UITextView *currentTextView;

@property(nonatomic) BOOL keyboardShow;
@property(nonatomic) CGFloat keyboardOverlap;

@property(nonatomic) CGRect keyboardRect;

@property(nonatomic) CGRect showDetailTableFrame;

@property(nonatomic,strong) NSString *selectedNoteInitContents;

@property(nonatomic,strong) UIView *viewForSearchBar;

@property(nonatomic)BOOL connectionServerSucess;

@property(nonatomic,strong) NSMutableArray *notesFromServer;

@property(nonatomic,strong) NSMutableArray *noteInfoDetail;

@property(nonatomic,strong) NSString *maxServerTime;

@property(nonatomic) BOOL firstFlag;

@property(nonatomic,strong)NoteInfo *myNewNote;

@property(nonatomic,strong)NoteInfo *myDeleteNote;

@property(nonatomic,strong)NoteInfo *updateNote;

@property(nonatomic,strong)UIRefreshControl *syncServerNotesRefreshControl;

@property(nonatomic) CGRect  viewForSearchBarFrame;
@end

@implementation DisplayNoteViewController
#define TitleTableCellTextLabelColor [UIColor darkGrayColor]
//#define CellBackgroundViewColor [UIColor colorWithRed:241.0/255.0 green:250.0/255.0 blue:250/255.0 alpha:1]
#define CellBackgroundViewColor [UIColor redColor]
static CGFloat displayViewHeight = 600;
static NSString *user = @"test55";



#pragma mask 属性方法
-(void)setSelectedNoteInfo:(NoteInfo *)selectedNoteInfo
{
    self.selectedNoteInitContents = selectedNoteInfo.noteContents;
    _selectedNoteInfo = selectedNoteInfo;
    CGFloat height = 0;
    [self.rowHeights removeAllObjects];
    // selectedNoteInfo.rowContent = [[NSMutableArray alloc] initWithArray:[selectedNoteInfo.noteContents componentsSeparatedByString:@"-]]";
    //selectedNoteInfo.noteContents = [[selectedNoteInfo.rowContent valueForKey:@"description"] componentsJoinedByString:@"-"];
    if(selectedNoteInfo.rowContent.count != 0){
        for(int num=0; num < selectedNoteInfo.rowContent.count;num++){
            height = [self setRowHeightForDetailTableViewFromCellTextString:selectedNoteInfo.rowContent[num]];
            [self.rowHeights addObject:@(height+8)];
        }
    }
}

//get row height for self.searchView.showPatientNoteDetailTableView
-(CGFloat)setRowHeightForDetailTableViewFromCellTextString:(NSString *)textString
{
  
    UITextView *tempTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, 578, 37)];
    
    tempTextView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //tempTextView.font = [UIFont systemFontOfSize:17];
    tempTextView.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17 ];
    //_inputField.textColor = [UIColor lightTextColor];
    tempTextView.textAlignment = NSTextAlignmentLeft;
    tempTextView.showsHorizontalScrollIndicator = NO;
    tempTextView.showsVerticalScrollIndicator = NO;
    tempTextView.scrollEnabled = NO;
    
    tempTextView.text = textString;
    CGSize size = [tempTextView sizeThatFits:CGSizeMake(578, 36)];
    //[self.cellHeights addObject:@(size.height)];
    NSLog(@"self.rowheight%@",self.rowHeights);
    tempTextView = nil;
    return size.height;
}
#pragma mask - 服务器方法
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
        msgObj.sync_usrStr = user;
        msgObj.sync_pwdStr = @"test";
    }
    
    return msgObj;
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
    
    _msgSocket.userStr = user;
    _msgSocket.passwordStr = @"test";
    
    self.connectionServerSucess = YES;
#warning 数据库恢复后，设为yes
    [self syncServerNotesWhenConnectionToServerSucess:YES];
}
#pragma mask - 同步方法
-(void)syncServerNotesWhenConnectionToServerSucess:(BOOL)connectionToServerSucess
{
    if(connectionToServerSucess){
        self.maxServerTime = [self.database getMaxServerTimeByNoteUser:user];
        if(self.maxServerTime == nil){
            self.maxServerTime = @" ";
        }
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:user forKey:@"user_id"];
        [dict setObject:self.maxServerTime forKey:@"max_stime"];
        [_msgSocket sendMsg:[self msgObjWithOptNumber:1329 dataDic:dict] selector:@selector(loadServerNotes:)];
        
    }else {
        NSLog(@"同步失败，请连接服务器");
        [self endUIRefreshControl];
        
    }
}
-(void)loadServerNotes:(IHSockRequest *)req
{
    if([req.responseData count] == 0) {
        NSLog(@"服务器端没有比客户端新的笔记");
        [self endUIRefreshControl];
         //[self reloadTableView:self.displayNotesView.showNoteTitlesTable detailTableView:self.displayNotesView.showNoteDetailTable];
    }else {
        NSMutableArray *serverNotes = [[NSMutableArray alloc] init];
        NoteInfo *noteInfoLocal = [[NoteInfo alloc] init];
        NSUInteger reqNumber = [req.responseData count];
        for(int i=0;i<reqNumber;i++){
           
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
                           //[self reloadTableView:self.displayNotesView.showNoteTitlesTable detailTableView:self.displayNotesView.showNoteDetailTable];
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
                              // [self reloadTableView:self.displayNotesView.showNoteTitlesTable detailTableView:self.displayNotesView.showNoteDetailTable];

                           } failed:^{
                               NSLog(@"冲突笔记：服务器端的笔记覆盖本地失败");
                           }];
                           
                        }else {
                         //本地没更新，但服务器端有更新的笔记
                            noteInfo.noteID = noteInfoLocal.noteID;
                            [self.database saveServerNoteContentHasChangeToLocal:noteInfo success:^{
                                NSLog(@"本地没更新，但服务器端有更新的笔记保存到本地成功");
                                //[self reloadTableView:self.displayNotesView.showNoteTitlesTable detailTableView:self.displayNotesView.showNoteDetailTable];

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
                //[self.displayNotesView.showNoteTitlesTable reloadData];
                [self reloadTableView:self.displayNotesView.showNoteTitlesTable detailTableView:self.displayNotesView.showNoteDetailTable];
               // [self endUIRefreshControl];
            }];

        }else {
            [self endUIRefreshControl];
            [self reloadTableView:self.displayNotesView.showNoteTitlesTable detailTableView:self.displayNotesView.showNoteDetailTable];
            //[self endUIRefreshControl];
        }
        //在保存以前要与local的note比较，找出has_network = NO 并且在本地查找noteUUID，如果找到则有冲突笔记，如果没找到则是新笔记应该插入到客户端数据库
        
    }
    //查找本地在断网下更新的笔记和新建的笔记 根据create time,update time,hasNotwork = 0，noteUUID
    //如果卡，可以再异步做
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 2), ^{
        [self uploadLocalNotes];
    });
    
}
-(void)uploadLocalNotes
{
    NSArray *tempArray = [[NSArray alloc] initWithArray:[self.database queryLocalNoteContentsByHasNetwork:0 createPeople:user]];
    
    if(tempArray.count != 0){
        if([self.syncServerNotesRefreshControl isRefreshing]){
            [self.syncServerNotesRefreshControl endRefreshing];
        }
        for(NoteInfo *noteInfo in tempArray){
            if(noteInfo.is_delete){
                if(![noteInfo.noteUIID isEqualToString:@"(null)"]){
                    //把在没网的情况下删除的笔记上传到服务器端
                    [self saveDeleteNoteToServer:noteInfo];
                }
                
            }else {
                if(!([noteInfo.noteUIID isEqualToString:@"(null)"]) && !([noteInfo.serverTime isEqualToString:@"(null)"])){
                    //本地离线下更新，需上传到服务器端
                    [self updateNoteAtFirstConnectedToNetwork:noteInfo];
                }else {
                    //本地离线下新建的
                    //[createNotes addObject:noteInfo];
                    [self saveNewNoteToServer:noteInfo];
                }
            }
        }
    }else {
       // [self endUIRefreshControl];
       
        NSLog(@"本地在离线状态下没有创建和更新任何笔记");
    }

}
-(void)endUIRefreshControl
{
    
    if([self.syncServerNotesRefreshControl isRefreshing]){
        [self.syncServerNotesRefreshControl endRefreshing];
    }
  
}
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
//删除的笔记保存到本地
-(void)saveDeleteNoteToLocalOrServer:(NoteInfo*)noteInfo
{
    noteInfo.is_delete = 1;
    noteInfo.updateDateString = [self convertCurrentDateToString];
    
    if(NetworkJudge){
        noteInfo.has_network = 1;
        
        [self saveDeleteNoteToServer:noteInfo];
    }else {
        noteInfo.has_network  = 0;
        [self saveDeleteNoteToLocal:noteInfo];
    }
}
-(void)saveDeleteNoteToLocal:(NoteInfo*)noteInfo
{
    [self.database saveDeleteNoteToLocal:noteInfo success:^{
        NSLog(@"update success");
        //[self afterDeleteNoteSelectedIndexToNextIndexAtCurrentIndex:self.currentIndexPath];
        [self printNoteInfo:noteInfo];
    } failed:^{
        
    }];
    //[self endUIRefreshControl];
}
//保存离线下新建的笔记到服务器端
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
        //[self reloadTableView:self.displayNotesView.showNoteTitlesTable detailTableView:self.displayNotesView.showNoteDetailTable];
    } failed:^{
        NSLog(@"冲突笔记：客户端的笔记作为新笔记保存到客户端失败");
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //keyboard
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    [self changeShowNoteDetailTableFrame];
    //页面出现时连接服务器
    //同步数据
    [self connectionToServer];
}
-(void)printNotes:(NSArray*)notes
{
    for(int i=0;i<notes.count;i++){
        NoteInfo *noteInfo = [[NoteInfo alloc] init];
        noteInfo = notes[i];
        [self printNoteInfo:noteInfo];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //init
    self.firstFlag = YES;
    
    self.notes = [[NSMutableArray alloc] init];
    self.noteInfo = [[NoteInfo alloc] init];
    self.filiterNotes = [[NSMutableArray alloc] init];
    self.rowHeights = [[NSMutableArray alloc] init];
    self.notesFromServer = [[NSMutableArray alloc] init];
    self.noteInfoDetail = [[NSMutableArray alloc] init];
    self.selectedNoteInfo = [[NoteInfo alloc] init];
    // self.rowContent = [[NSMutableArray alloc] init];

    //data base
    self.database = [NotebookDatabase initDatabase];

    self.notes =[[NSMutableArray alloc]initWithArray:[self.database getNotesFromLocalByUser:user nBaseRow:0 nNumRecord:13 success:^{
        
    } failed:^{
        
    }]];
    [self printNotes:self.notes];
    
#pragma mark - 连接服务器
    [self connectionToServer];
    
    
    self.displayNotesView = [[DisplayNotesView alloc] initWithFrame:CGRectMake(80, 30, 900, displayViewHeight)];
    //table
    UITableView *showNotesTitleTable = self.displayNotesView.showNoteTitlesTable;
    UITableView *showNoteDetailTable = self.displayNotesView.showNoteDetailTable;
    
    showNotesTitleTable.delegate = self;
    showNotesTitleTable.dataSource = self;
    showNoteDetailTable.delegate = self;
    showNoteDetailTable.dataSource = self;

    self.showDetailTableFrame = showNoteDetailTable.frame;
    //添加下拉刷新
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [showNotesTitleTable addSubview:refreshControl];
    self.syncServerNotesRefreshControl = refreshControl;
   [self.view addSubview:self.displayNotesView];
    /////////////////////////////////////////////////////////////////////////////////////////////
    //////////////         search display view controller            ///////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////
    self.displayNotesView.searchBar.searchBar.delegate = self;
    
    UIViewController *viewVC = [[UIViewController alloc] init];
    
    viewVC.view.backgroundColor = [UIColor clearColor];
    viewVC.view.alpha = 0;
    CGRect rect = showNotesTitleTable.frame;
    rect = [self.view convertRect:rect fromView:self.displayNotesView];

    viewVC.view.frame = rect;
    self.viewForSearchBar = viewVC.view;
    self.viewForSearchBarFrame = rect;
    self.viewForSearchBar.alpha = 0;
    
    [self addChildViewController:viewVC];
   
    self.strongSearchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:self.displayNotesView.searchBar.searchBar contentsController:viewVC];
    
    self.strongSearchDisplayController.searchResultsDataSource = self;
    self.strongSearchDisplayController.searchResultsDelegate = self;
    self.strongSearchDisplayController.delegate = self;
    
    [self.view addSubview:viewVC.view];

    [self setTableViewSelectedFirstRow:showNotesTitleTable dataSources:self.notes];
    
}

-(void)connectionToServer
{
    
    _msgSocket = [[IHMsgSocket alloc] init];
    _msgSocket.delegate = self;
    
    [_msgSocket connectToHost:@"192.168.10.106" onPort:2222];
}
//下拉刷新，从服务器端load数据，更新本地数据库，并用table view 显示
-(void)refresh:(UIRefreshControl*)refresh
{
    // do other thing
    if(NetworkJudge){
        if(self.connectionServerSucess){
            [self syncServerNotesWhenConnectionToServerSucess:YES];
        }else {
            
            [self connectionToServer];
        }

    }else {
        [refresh endRefreshing];
        //[self showAlertView];
        [self showTempView];
    }
}
-(void)showTempView
{
    TempView *temp = [[TempView alloc] initWithView:self.displayNotesView text:@"网络连接失败,请检查网络连接"];
    [temp showWithAnimation:YES];
}
//-(void)showAlertView
//{
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"网络连接失败，请检查网络" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
//    
//    alertView.transform = CGAffineTransformTranslate(alertView.transform, 0, 100);
//     [alertView show];
//    [self performSelector:@selector(dismissAlert:) withObject:alertView afterDelay:2];
//}
//-(void)dismissAlert:(UIAlertView*)alert
//{
//    [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
//}

-(void)reloadTableView:(UITableView*)showTitleTableView detailTableView:(UITableView*)detailTableView
{
  __block  NSInteger flag = 0;
//    self.notes =[[NSMutableArray alloc] initWithArray:[self.database getAllNotesFromLocalByUser:user success:^{
//        flag = 1;
//    } failed:^{
//        flag = 0;
//    }]];
    self.notes =[[NSMutableArray alloc]initWithArray:[self.database getNotesFromLocalByUser:user nBaseRow:0 nNumRecord:13 success:^{
        flag = 1;
    } failed:^{
        
    }]];
    //[self endUIRefreshControl];
     //需要先终止UIrefresh,然后reload tableView;
    if(flag == 1){
      
        [showTitleTableView reloadData];

        [self setTableViewSelectedFirstRow:showTitleTableView dataSources:self.notes];
        [detailTableView reloadData];
        [self changeShowNoteDetailTableFrame];
    }

}

-(void)setTableViewSelectedFirstRow:(UITableView*)tableView dataSources:(NSArray *)notes
{
    if(notes.count != 0){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
        self.selectedNoteInfo= [notes objectAtIndex:indexPath.row];
        self.selectedNoteInitContents = self.selectedNoteInfo.noteContents;
    }

}

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
    NSLog(@"req.resp:%ld",(long)req.resp);
    
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
//仅仅用于在本地修改，包括离线和在线 update 
-(void)saveToServerOrLocal:(NoteInfo*)noteInfo
{
    noteInfo.noteContents = [self convertContainsNoBlankLineArrayToString:noteInfo.rowContent];
    self.selectedNoteInitContents = [self convertContainsNoBlankLineArrayToString:[self.selectedNoteInitContents componentsSeparatedByString:@"-"]];
    if([self.selectedNoteInitContents isEqualToString:noteInfo.noteContents]){
        return;
    }
    noteInfo.updateDateString = [self convertCurrentDateToString];
    
    if(NetworkJudge){
        //有网络
        if(self.connectionServerSucess){
            //有网络且网络连接服务器成功
            [self saveToServer:self.selectedNoteInfo];
        }

    }else{
        //无网络更新笔记，仅仅保存到local
        //此时要改变has_network与modf_people的值
        self.selectedNoteInfo.has_network = 0;
        self.selectedNoteInfo.modf_people = @"definePeople";
        [self saveUpdateNoteToLocal:self.selectedNoteInfo];
    }
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
-(NSString*)convertArrayToString:(NSArray *)array
{
    NSString *retvString = [[array valueForKey:@"description"] componentsJoinedByString:@"-"];
    NSLog(@"retvString : %@",retvString);
    return retvString;
    
}
-(void)saveUpdateNoteToLocal:(NoteInfo*)noteInfo
{
    [self.database saveUpdateNoteToLocal:noteInfo success:^{
        NSLog(@"保存修改的笔记到本地数据库成功");
        //更新完成以后tableView reload
       // [self reloadTableView:self.displayNotesView.showNoteTitlesTable detailTableView:self.displayNotesView.showNoteDetailTable];
        self.notes =[[NSMutableArray alloc]initWithArray:[self.database getNotesFromLocalByUser:user nBaseRow:0 nNumRecord:13 success:^{
           
        } failed:^{
            
        }]];
   
        [self.displayNotesView.showNoteTitlesTable reloadData];

        [self printNoteInfo:noteInfo];
    } failed:^{
        NSLog(@"保存修改的笔记到本地数据库失败");
    }];
}
-(void)saveToServer:(NoteInfo*)noteInfo
{
    //在有网情况下更新的笔记上传到服务器
   
    self.selectedNoteInfo.modf_people = _msgSocket.userStr;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:_msgSocket.userStr forKey:@"user_id"];
    [dict setObject:noteInfo.noteUIID forKey:@"note_id"];
    [dict setObject:noteInfo.titleName forKey:@"note_name"];
    [dict setObject:noteInfo.noteContents forKey:@"content"];
    [dict setObject:noteInfo.updateDateString forKey:@"update_time"];

    [self printNoteInfo:noteInfo];

    [_msgSocket sendMsg:[self msgObjWithOptNumber:1332 dataDic:dict] selector:@selector(modifyNoteFinished:)];
}
- (void)modifyNoteFinished:(IHSockRequest *)req
{
    NSLog(@"req.responseDat:%@",req.responseData);
    NSLog(@"req.opt:%ld",(long)req.opt);
    NSLog(@"req.resp:%ld",(long)req.resp);
    NSString *sTime;
    if([req.responseData count] == 1){
        sTime = [req.responseData[0] objectForKey:@"stime"];
        NSLog(@"sTime:%@",sTime);
    }
    
    NSInteger resp = req.resp;
    switch (resp) {
        case 0:{
            //修改成功,保存到local
           self.selectedNoteInfo.has_network = 1;
            self.selectedNoteInfo.serverTime = sTime;
            break;
        }
        case -1:{
            //修改失败，用户没权限
            self.selectedNoteInfo.has_network = 0;
            break;
        }
        case -2:{
            //修改失败，用户没权限
            self.selectedNoteInfo.has_network = 0;
            break;
        }
        case -3:{
            //修改的笔记不存在
             self.selectedNoteInfo.has_network = 0;
            break;
        }
        default:{
            NSLog(@"修改笔记失败，服务端返回值错误");
             self.selectedNoteInfo.has_network = 0;
            break;
        }
    }
    [self saveUpdateNoteToLocal:self.selectedNoteInfo];
}

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
    NSLog(@"noteInfo patientData area:%@",noteInfo.patientInfo.area);
    NSLog(@"noteInfo patientData location:%@",noteInfo.patientInfo.location);
    NSLog(@"noteInfo patientData name:%@",noteInfo.patientInfo.name);
    NSLog(@"noteInfo patientData gender:%@",noteInfo.patientInfo.gender);
    NSLog(@"noteInfo patientData age:%@",noteInfo.patientInfo.age);
    NSLog(@"noteInfo create note people:%@",noteInfo.createNotePeople);
}

-(void)changeShowNoteDetailTableFrame
{
    if(self.notes.count != 0){
        UITableView *tableView = self.displayNotesView.showNoteDetailTable;
        PatientData *tempPatientData = self.selectedNoteInfo.patientInfo;
        if([tempPatientData.area isEqualToString:@""] && [tempPatientData.location isEqualToString:@""] &&[tempPatientData.name isEqualToString:@""] && [tempPatientData.gender isEqualToString:@""] && [tempPatientData.age isEqualToString:@""]){
            CGRect rect = self.showDetailTableFrame;
            rect.origin.y = 47;//search bar height + 2
            rect.size.height = displayViewHeight - 47;
            
            [UIView animateWithDuration:0.25 animations:^{
                tableView.frame = rect;
            }];
        }else {
            [UIView animateWithDuration:0.25 animations:^{
                tableView.frame = self.showDetailTableFrame;
            }];
        }

    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//keyboard method
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    if(self.keyboardShow){
        return;
    }
    self.keyboardShow = YES;
    
    //UITableView *showNotesTitleTable = self.displayNotesView.showNoteTitlesTable;
    UITableView *showNoteDetailTable = self.displayNotesView.showNoteDetailTable;
    
    // Get the keyboard size
    UIScrollView *tableView;
    if([showNoteDetailTable.superview isKindOfClass:[UIScrollView class]])
        tableView = (UIScrollView *)showNoteDetailTable.superview;
    else {
        tableView = showNoteDetailTable;
    }
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [tableView.superview convertRect:[aValue CGRectValue] fromView:nil];
    self.keyboardRect = keyboardRect;
    // Get the keyboard's animation details
    NSTimeInterval animationDuration;
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    UIViewAnimationCurve animationCurve;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    
    // Determine how much overlap exists between tableView and the keyboard
    CGRect tableFrame = tableView.frame;
    CGFloat tableLowerYCoord = tableFrame.origin.y + tableFrame.size.height;
    self.keyboardOverlap = tableLowerYCoord - keyboardRect.origin.y;
    if(self.currentTextView && self.keyboardOverlap>0)
    {
        CGFloat accessoryHeight = self.currentTextView.frame.size.height;
        self.keyboardOverlap -= accessoryHeight;
        
        tableView.contentInset = UIEdgeInsetsMake(0, 0, accessoryHeight, 0);
        tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, accessoryHeight, 0);
    }
    
    if(self.keyboardOverlap < 0)
        self.keyboardOverlap = 0;
    
    if(self.keyboardOverlap != 0)
    {
        tableFrame.size.height -= self.keyboardOverlap;
        
        NSTimeInterval delay = 0;
        if(keyboardRect.size.height)
        {
            delay = (1 - self.keyboardOverlap/keyboardRect.size.height)*animationDuration;
            animationDuration = animationDuration * self.keyboardOverlap/keyboardRect.size.height;
        }
        
        [UIView animateWithDuration:animationDuration delay:delay
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{ tableView.frame = tableFrame;  CGRect caret1 = [self.currentTextView caretRectForPosition:self.currentTextView.selectedTextRange.end];
                             showNoteDetailTable.contentOffset = CGPointMake(0, caret1.origin.y); }
                         completion:^(BOOL finished){ [self tableAnimationEnded:nil finished:nil contextInfo:nil]; }];
    }
    
 
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    if(!self.keyboardShow)
        return;
    
    self.keyboardShow = NO;
    
   // UITableView *showNotesTitleTable = self.displayNotesView.showNoteTitlesTable;
    UITableView *showNoteDetailTable = self.displayNotesView.showNoteDetailTable;
    
    UIScrollView *tableView;
    if([showNoteDetailTable.superview isKindOfClass:[UIScrollView class]])
        tableView = (UIScrollView *)showNoteDetailTable.superview;
    else
        tableView = showNoteDetailTable;
    if(self.currentTextView)
    {
        tableView.contentInset = UIEdgeInsetsZero;
        tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
    }
    
    if(self.keyboardOverlap == 0)
        return;
    
    // Get the size & animation details of the keyboard
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [tableView.superview convertRect:[aValue CGRectValue] fromView:nil];
    
    NSTimeInterval animationDuration;
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    UIViewAnimationCurve animationCurve;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    
    CGRect tableFrame = tableView.frame;
    tableFrame.size.height += self.keyboardOverlap;
    
    if(keyboardRect.size.height)
        animationDuration = animationDuration * self.keyboardOverlap/keyboardRect.size.height;
    
    [UIView animateWithDuration:animationDuration delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{ tableView.frame = tableFrame; }
                    completion:^(BOOL finished){ [self tableAnimationEnded:nil finished:nil contextInfo:nil]; }];
    
    //save to data base
    [self saveToServerOrLocal:self.selectedNoteInfo];
    
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
- (void) tableAnimationEnded:(NSString*)animationID finished:(NSNumber *)finished contextInfo:(void *)context
{
    // Scroll to the active cell
    UITableView *tableView = self.displayNotesView.showNoteDetailTable;
    if(self.currentIndexPath)
    {
        [tableView scrollToRowAtIndexPath:self.currentIndexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
        [tableView selectRowAtIndexPath:self.currentIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}
#pragma mask - table view delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.displayNotesView.showNoteTitlesTable){
        return self.notes.count == 0 ? 0:self.notes.count;
    }else if(tableView == self.displayNotesView.showNoteDetailTable){
       
        NSLog(@"%ld",self.selectedNoteInfo.rowContent.count);
        return self.selectedNoteInfo.rowContent.count == 0 ? 0:self.selectedNoteInfo.rowContent.count;
        
    }else{
        return self.filiterNotes.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellId";
    static NSString *cellForDetailTableView = @"cellForDetailTableView";
    UITableViewCell  *cell = nil;
     NoteInfo *noteInfo = nil;
    UITableView *showNotesTitleTable = self.displayNotesView.showNoteTitlesTable;
    UITableView *showNoteDetailTable = self.displayNotesView.showNoteDetailTable;
    if(self.notes.count == 0){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }else {
       if(tableView == showNotesTitleTable){
           cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
           if(cell == nil){
              cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
               
           }
           
           noteInfo = [self.notes objectAtIndex:indexPath.row];
           cell.textLabel.textColor = TitleTableCellTextLabelColor;
           cell.textLabel.text = noteInfo.titleName;
           
           //[cell setSelectedBackgroundView:[self titleTableViewCellBankgroundView]];
           //set  cell background color
           
        //return cell;
      }else if(tableView == self.strongSearchDisplayController.searchResultsTableView){
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
            if(cell == nil){
              cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
           noteInfo = [self.filiterNotes objectAtIndex:indexPath.row];
          
          cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
           cell.textLabel.text = noteInfo.titleName;
        
       }else if (tableView == showNoteDetailTable){
        
           PatientDetailTableViewCell *reuseCell = [tableView dequeueReusableCellWithIdentifier:cellForDetailTableView];
        
           if(reuseCell == nil){
               reuseCell = [[PatientDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellForDetailTableView];
            
           }
        
           noteInfo= self.selectedNoteInfo;
          
           if(noteInfo.rowContent != nil) {
               reuseCell.inputField.text = [noteInfo.rowContent objectAtIndex:indexPath.row];
           }
           self.displayNotesView.titleLabel.text = noteInfo.titleName;
        
           self.displayNotesView.areaLabel.text = noteInfo.patientInfo.area;
           self.displayNotesView.locationLabel.text  = noteInfo.patientInfo.location;
           self.displayNotesView.nameLabel.text  = noteInfo.patientInfo.name;
           self.displayNotesView.genderLabel.text = noteInfo.patientInfo.gender;
           self.displayNotesView.ageLabel.text = noteInfo.patientInfo.age;
           self.displayNotesView.creatDateLabel.text =[self dateStringFromDateString:noteInfo.updateDateString];
           reuseCell.delegate = self;
           reuseCell.indexStr = [NSString stringWithFormat:@"%ld",indexPath.row];
           reuseCell.inputField.tag = indexPath.row;
        
           cell = reuseCell;
           [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
           noteInfo = nil;
           reuseCell = nil;
       }
    }
    cell.separatorInset = UIEdgeInsetsZero;
    
    UIView *bgColorView = [[UIView alloc]init];
    //bgColorView.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:250.0/255.0 blue:250/255.0 alpha:1];
    bgColorView.backgroundColor = [UIColor orangeColor];
    [cell setSelectedBackgroundView:bgColorView];
    return cell;
    
}
-(UIView*)titleTableViewCellBankgroundView
{
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor redColor];
    //bgColorView.layer.masksToBounds = YES;
    return bgColorView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 44;
    if(tableView == self.displayNotesView.showNoteDetailTable){
        
        if(self.rowHeights.count != 0  && indexPath.row < self.rowHeights.count){
            height = [[self.rowHeights objectAtIndex:indexPath.row] floatValue] ;
            
        }else {
            height = 44;
        }
       // NSLog(@"indexPath.row %d cell height: %lf",indexPath.row,height);
        if(height < 44.0f){
            height = 44.0f;
        }
        // tempCell = nil;
    }
    return height + 1;
    
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   // return UITableViewAutomaticDimension;
    NSInteger rowHeightsCount = self.rowHeights.count;
    if(rowHeightsCount != 0 && indexPath.row < rowHeightsCount){
        return [[self.rowHeights objectAtIndex:indexPath.row] floatValue];
    }else {
        return UITableViewAutomaticDimension;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.strongSearchDisplayController.searchResultsTableView){
        [self.strongSearchDisplayController.searchBar resignFirstResponder];
        
       // self.selectedNoteInfo = nil;
       // self.rowContent = nil;
        self.selectedNoteInfo = [self.filiterNotes objectAtIndex:indexPath.row];
        self.selectedNoteInitContents = self.selectedNoteInfo.noteContents;
        
       //self.selectedNoteInfo.rowContent =[[NSMutableArray alloc] initWithArray:[self.selectedNoteInfo.noteContents componentsSeparatedByString:@"-"]];
       //self.rowContent =[[NSMutableArray alloc] initWithArray:[self.selectedNoteInfo.noteContents componentsSeparatedByString:@"-"]];
        
        //hide or show patientInfo
        [self changeShowNoteDetailTableFrame];
      
        [self.displayNotesView.showNoteDetailTable reloadData];
        
        //close search bar
       // [self.strongSearchDisplayController.searchBar resignFirstResponder];
        
    }else if(tableView == self.displayNotesView.showNoteTitlesTable){
        
       // [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if(self.notes.count != 0 && self.selectedNoteInfo == [self.notes objectAtIndexedSubscript:indexPath.row]){
            return;
        }
        self.selectedNoteInfo = [[NoteInfo alloc] init];
        self.selectedNoteInfo.noteContents = nil;
        self.currentIndexPath = indexPath;
        
        if(self.notes.count != 0){
            self.selectedNoteInfo = [self.notes objectAtIndex:indexPath.row];
            self.selectedNoteInitContents = self.selectedNoteInfo.noteContents;
        }
        
        [self printNoteInfo:self.selectedNoteInfo];
       // self.selectedNoteInfo.rowContent =[[NSMutableArray alloc] initWithArray:[self.selectedNoteInfo.noteContents componentsSeparatedByString:@"-"]];
       // self.rowContent = [[NSMutableArray alloc] initWithArray:[self.selectedNoteInfo.noteContents componentsSeparatedByString:@"-"]];
        
        //hide or show patientInfo
        [self changeShowNoteDetailTableFrame];
      
        [self.displayNotesView.showNoteDetailTable reloadData];
    }
    
}
-(NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // self.selectedNoteInfo.noteContents = [[self.selectedNoteInfo.rowContent valueForKey:@"description"] componentsJoinedByString:@"-"];
  
    //save to data base
    if(tableView == self.displayNotesView.showNoteTitlesTable){
        [self saveToServerOrLocal:self.selectedNoteInfo];
        
        [self.notes setObject:self.selectedNoteInfo atIndexedSubscript:indexPath.row];
    }
    

    return indexPath;
}
//tableView 分页显示
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{

    if(tableView == self.displayNotesView.showNoteTitlesTable){
 
        NSLog(@"indexPath.row:%ld",indexPath.row);
        NSInteger lastSectionIndex = [tableView numberOfSections] - 1;
        NSInteger lastRowIndex = [tableView numberOfRowsInSection:lastSectionIndex];
        
        if((lastSectionIndex == indexPath.section) && ((lastRowIndex - 1) == indexPath.row)){
            __block BOOL flag = NO;
            NSInteger maxRowNumber = [self.database getMaxRowNumberByNoteUser:user success:^{
                flag = YES;
            } failed:^{
                flag = NO;
            }];
            
            if((flag == YES) && (maxRowNumber > 13) && (lastRowIndex+1 < maxRowNumber)){
                
                NSUInteger offset =  13;
                //        if(lastRowIndex + 11 <= maxRowNumber){
                //            offset = 10;
                //        }else {
                //            offset = maxRowNumber - lastRowIndex;
                //        }
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [self loadMoreNotesFromLocal:lastRowIndex offset:offset];

                });
            }
        }
    }
}

-(void)loadMoreNotesFromLocal:(NSInteger)lastRowIndex offset:(NSInteger)offset
{
    NSArray *tempArray = [[NSMutableArray alloc] init];
    
    tempArray = [self.database getNotesFromLocalByUser:user nBaseRow:lastRowIndex nNumRecord:offset success:^{
        
    } failed:^{
        
    }];
    [self.notes addObjectsFromArray:tempArray];
    __weak DisplayNoteViewController *Weakself = self;
    //异步加载数据
    dispatch_async(dispatch_get_main_queue(), ^{
        [Weakself.displayNotesView.showNoteTitlesTable reloadData];
        NSLog(@"[self.notes.count : %ld,tempArray.count : %ld",self.notes.count,tempArray.count);
    });
    [self.displayNotesView.showNoteTitlesTable reloadData];
    NSLog(@"[self.notes.count : %ld,tempArray.count : %ld",self.notes.count,tempArray.count);
}
//edit tableview
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.displayNotesView.showNoteTitlesTable){
        return YES;
    }
    if(tableView ==self.displayNotesView.showNoteDetailTable){
        return YES;
    }
    
    return NO;
    
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableView *showNotesTitleTable = self.displayNotesView.showNoteTitlesTable;
    
    if(tableView == showNotesTitleTable){
        if(editingStyle == UITableViewCellEditingStyleDelete && self.notes.count != 0){
    
            NoteInfo *tempNote = [[NoteInfo alloc] init];
            tempNote = self.selectedNoteInfo;
            [self saveDeleteNoteToLocalOrServer:tempNote];

            [self.notes removeObjectAtIndex:indexPath.row];
            
            
            [tableView beginUpdates];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            [tableView endUpdates];
            
            [self afterDeleteNoteSelectedIndexToNextIndexAtCurrentIndex:indexPath];
            
        }
    }
    if(tableView == self.displayNotesView.showNoteDetailTable){
        if(editingStyle == UITableViewCellEditingStyleDelete && self.selectedNoteInfo != nil){
         
            [self.selectedNoteInfo.rowContent removeObjectAtIndex:indexPath.row];
            self.selectedNoteInfo.noteContents = [[self.selectedNoteInfo.rowContent valueForKey:@"description"] componentsJoinedByString:@"-"];
            
            //save to data base
            [self saveToServerOrLocal:self.selectedNoteInfo];
            
            
            [tableView beginUpdates];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView endUpdates];
        }
    }
}
//删除一行之后，自动选择下一行
-(void)afterDeleteNoteSelectedIndexToNextIndexAtCurrentIndex:(NSIndexPath*)indexPath
{
    if(self.notes.count != 0){
        NSInteger rowIndex;
        if(indexPath.row == 0){
            rowIndex = indexPath.row;
        }else{
            rowIndex = indexPath.row - 1;
        }
        
        self.selectedNoteInfo = [self.notes objectAtIndex:rowIndex];
        self.selectedNoteInitContents = self.selectedNoteInfo.noteContents;
        //self.selectedNoteInfo.updateDateString = [self convertCurrentDateToString];
        //[showNotesTitleTable reloadData];
        
        [self.displayNotesView.showNoteTitlesTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:rowIndex inSection:indexPath.section] animated:YES scrollPosition:UITableViewScrollPositionTop];
        //[self.displayNotesView.showNoteDetailTable reloadData];
    }else {
        self.selectedNoteInfo = nil;
        
        //[showNotesTitleTable reloadData];
        //[self.displayNotesView.showNoteDetailTable reloadData];
    }
    
    [self.displayNotesView.showNoteDetailTable reloadData];
}
- (void)growingCell:(PatientDetailTableViewCell *)cell didChangeSize:(CGSize)size
{
    
//
   UITableView *showNoteDetailTable = self.displayNotesView.showNoteDetailTable;
   
    
    [self.rowHeights setObject:@(size.height+8) atIndexedSubscript:[cell.indexStr intValue]];
    [showNoteDetailTable beginUpdates];
    [showNoteDetailTable endUpdates];

    
   // CGRect caret2 = [cell.inputField caretRectForPosition:cell.inputField.selectedTextRange.end];
   // showNoteDetailTable.contentOffset = CGPointMake(0, caret2.origin.y);
    
}
-(void)cellId:(PatientDetailTableViewCell *)cell textView:(UITextView *)textView text:(NSString *)text
{
   //  UITableView *showNoteDetailTable = self.displayNotesView.showNoteDetailTable;
    
    [self.selectedNoteInfo.rowContent setObject:text atIndexedSubscript:[cell.indexStr intValue]];
    self.selectedNoteInfo.noteContents = [[self.selectedNoteInfo.rowContent valueForKey:@"description"] componentsJoinedByString:@"-"];

    
    NSLog(@"self.cellHeights %@",self.rowHeights);
    NSLog(@"self.cellTextString %@",self.selectedNoteInfo.rowContent);
    
}
-(void)cell:(PatientDetailTableViewCell *)cell textView:(UITextView *)textView
{
    
}
-(void)textViewDidStartEditing:(UITextView *)textView cell:(PatientDetailTableViewCell*)cell
{
    self.currentIndexPath = [NSIndexPath indexPathForRow:cell.inputField.tag inSection:0];
    self.currentTextView = textView;
    if(cell.inputField.tag == self.rowHeights.count - 1){
        
        [self insertNewCellToDetailTableViewAfterCell:cell];
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView cell:(PatientDetailTableViewCell *)cell
{
    CGRect caret1 = [cell.inputField caretRectForPosition:cell.inputField.selectedTextRange.end];
    self.displayNotesView.showNoteDetailTable.contentOffset = CGPointMake(0, caret1.origin.y);

    [self.selectedNoteInfo.rowContent setObject:textView.text atIndexedSubscript:[cell.indexStr intValue]];
    self.selectedNoteInfo.noteContents = [[self.selectedNoteInfo.rowContent valueForKey:@"description"] componentsJoinedByString:@"-"];
    
    self.currentTextView = nil;
}
//如果被选中的cell为最后一行的cell,table view 新增一行
-(void)insertNewCellToDetailTableViewAfterCell:(PatientDetailTableViewCell*)cell
{
    UITableView *showNoteDetailTable = self.displayNotesView.showNoteDetailTable;
    //if(cell.inputField.tag == self.cellHeights.count - 1){
    [self.rowHeights addObject:@(44)];
    [self.selectedNoteInfo.rowContent addObject:@""];
    [showNoteDetailTable beginUpdates];
    [showNoteDetailTable insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:cell.inputField.tag + 1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    [showNoteDetailTable endUpdates];
 
}
#pragma mask - search bar delegate

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    CGRect rect = searchBar.bounds;
    rect.size.width = 320;
    searchBar.bounds = rect;
    return YES;
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.filiterNotes removeAllObjects];
    self.filiterNotes = nil;
}
#pragma mask -UISearchDisplayController delegate methods
-(void)filiterContentForSearchText:(NSString *)searchText scope:(NSString*)scope
{
    [self.filiterNotes removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.titleName contains[c] %@",searchText];
    
    self.filiterNotes = [NSMutableArray arrayWithArray:[self.notes filteredArrayUsingPredicate:predicate]];
}
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filiterContentForSearchText:searchString scope:[[self.strongSearchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
}
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filiterContentForSearchText:self.strongSearchDisplayController.searchBar.text scope:[[self.strongSearchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    return YES;
}
-(void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView
{
    //tableView.backgroundColor = [UIColor whiteColor];
   // UITableView *showNotesTitleTable = self.displayNotesView.showNoteTitlesTable;
    tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    CGRect rect = self.viewForSearchBarFrame;
    rect.origin = CGPointMake(0, 45);
    
    tableView.frame = [self changeRectToRect:rect];
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
  
}
-(CGRect)changeRectToRect:(CGRect)rect
{
    CGRect mYrect = rect;
    mYrect.size.height = rect.size.height;
    mYrect.size.width = rect.size.width;
    return mYrect;
}
-(void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
    self.viewForSearchBar.alpha = 1;
    
    CGRect rect = self.viewForSearchBarFrame;
    rect.origin = CGPointMake(0, 45);
    
    tableView.frame = [self changeRectToRect:rect];
  
}
-(void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView
{
    CGRect rect = self.viewForSearchBarFrame;
    rect.origin = CGPointMake(0, 45);
    
    tableView.frame = [self changeRectToRect:rect];

}
-(void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
        [UIView animateWithDuration:0.25 animations:^{
        CGRect rect = self.displayNotesView.searchBar.searchBar.frame;
        controller.searchBar.frame = rect;
    }];
    
}

-(void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    self.viewForSearchBar.alpha = 0;
}
-(void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    //self.strongSearchDisplayController.searchBar.frame = CGRectMake(10, 10, 320,44);
    //[self correctFramesForSearchDisplayControllerBeginSearch:NO];
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        CGRect rect = self.displayNotesView.searchBar.searchBar.frame;
        controller.searchBar.frame = rect;
        self.viewForSearchBar.alpha = 0;
    } completion:^(BOOL finished) {
        
    }];
    
}
////fix search problem
//static UIView *PSPDFViewWithSuffix(UIView *view, NSString *classNameSuffix) {
//    if (!view || classNameSuffix.length == 0) return nil;
//    
//    UIView *theView = nil;
//    for (__unsafe_unretained UIView *subview in view.subviews) {
//        if ([NSStringFromClass(subview.class) hasSuffix:classNameSuffix]) {
//            return subview;
//        }else {
//            if ((theView = PSPDFViewWithSuffix(subview, classNameSuffix))) break;
//        }
//    }
//    return theView;
//}
//- (void)correctSearchDisplayFrames {
//    // Update search bar frame.
//     UITableView *showNotesTitleTable = self.displayNotesView.showNoteTitlesTable;
//    
//    CGRect superviewFrame = self.strongSearchDisplayController.searchBar.superview.frame;
//    superviewFrame.origin.y = 0.0f;
//    self.strongSearchDisplayController.searchBar.superview.frame = superviewFrame;
//    //self.strongSearchDisplayController.searchBar.frame = CGRectMake(10, 10, 320,44);
//    // Strech dimming view.
//    UIView *dimmingView = PSPDFViewWithSuffix(self.view, @"DimmingView");
//    if (dimmingView) {
//        CGRect dimmingFrame = dimmingView.superview.frame;
//        //dimmingFrame.origin.x = self.strongSearchDisplayController.searchBar.frame.origin.x;
//        dimmingFrame.origin.x = showNotesTitleTable.frame.origin.x;
//        dimmingFrame.origin.y = self.strongSearchDisplayController.searchBar.frame.size.height;
//        dimmingFrame.size.height = showNotesTitleTable.frame.size.height - dimmingFrame.origin.y;
//        dimmingFrame.size.width = 320;
//        // dimmingFrame = CGRectMake(20, 20, 320, 640);
//        // dimmingFrame.origin.x = self.strongSearchDisplayController.
//        // [dimmingView setAlpha:0];
//        dimmingView.superview.frame = dimmingFrame;
//    }
//}
//
//- (void)correctFramesForSearchDisplayControllerBeginSearch:(BOOL)beginSearch {
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self correctSearchDisplayFrames];
//        
//    });
//    self.strongSearchDisplayController.searchBar.frame = CGRectMake(10, 10, 320,44);
//}

//get date string
-(NSString*)getWeakDayStringFromDateComponents:(NSInteger)weekDay
{
    NSString *weakDayString;
   
    switch (weekDay) {
        case 1:{
            weakDayString = @"星期天";
            break;
        }
        case 2:{
            weakDayString = @"星期一";
            break;
        }
        case 3:{
            weakDayString = @"星期二";
            break;
        }
        case 4:{
            weakDayString = @"星期三";
            break;
        }
        case 5:{
            weakDayString = @"星期四";
            break;
        }
        case 6:{
            weakDayString = @"星期五";
            break;
        }
        case 7:{
            weakDayString = @"星期六";
            break;
        }
        default:
            NSLog(@"weak day error");
            break;
    }
    
    return weakDayString;
}

-(NSString*)dateStringFromDateString:(NSString*)string
{
    NSString *retvString;
    
    if(string != nil && ![string isEqualToString:@""] && ![string isEqualToString:@"undefined"]) {
        NSMutableArray *components =[[NSMutableArray alloc]initWithArray:[string componentsSeparatedByString:@" "]];
        
        NSString *timeString = components[1];
        
        NSArray *time = [[NSMutableArray alloc] initWithArray:[timeString componentsSeparatedByString:@":"]];
        
        NSString *hourString = time[0];
        hourString = [NSString stringWithFormat:@"%@ %@",[hourString integerValue] > 12 ? @"下午" : @"上午",timeString];
        
        NSString *weekDay = components[2];
        weekDay = [self getWeakDayStringFromDateComponents:[weekDay integerValue]];
        
        retvString = [NSString stringWithFormat:@"%@ %@ %@",components[0],weekDay,hourString];
        NSLog(@"retvString ; %@",retvString);
       // retvString = [NSString stringWithFormat:@"%@ %@",components[0],hourString];
    }else {
        retvString = @"";
    }
    return retvString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
