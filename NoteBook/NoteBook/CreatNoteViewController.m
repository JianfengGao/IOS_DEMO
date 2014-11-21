//
//  CreatNoteViewController.m
//  NoteBook
//
//  Created by ihefe-JF on 14/11/4.
//  Copyright (c) 2014年 ihefe. All rights reserved.
//离线状态下创建的笔记，noteUUID = NULL;hasNetWork = 0;noteInfo_modfPeople = @"defaultPeople";noteInfo.creatNotePeople = @"defaultPeople"

#import "CreatNoteViewController.h"
#import "createNoteView.h"
#import "EditingTableViewCell.h"
#import "NoteInfo.h"
#import "NotebookDatabase.h"
#import "SyncServerNotes.h"
#import "IHMsgSocket.h"
#import "IHGCDReconnect.h"

@interface CreatNoteViewController ()<UITableViewDataSource,UITableViewDelegate,EditingTableViewCellDelegate,UITextFieldDelegate>
@property(nonatomic,strong) CreateNoteView *createNoteView;
@property(nonatomic,strong) NoteInfo *noteInfo;

@property(nonatomic,strong) NSMutableArray *noteContent;
@property(nonatomic,strong) NSMutableArray *rowHeights;

@property(nonatomic) NSInteger rowCount;

@property(nonatomic,strong) NSIndexPath *currentIndexPath;
@property(nonatomic,strong) UITextView *currentTextView;

@property(nonatomic) BOOL keyboardShow;
@property(nonatomic) CGFloat keyboardOverlap;

@property(nonatomic,strong) NotebookDatabase *dataBase;

@property(nonatomic)BOOL connectionServerSucess;
@property(nonatomic)CGRect createNoteTableViewFrame;

@property(nonatomic,strong)SyncServerNotes *syncServerNotes;
@property(nonatomic)CGRect createTitleFrame;
@end

@implementation CreatNoteViewController
#pragma mask - 网络通信
static NSString *user = @"test55";

#pragma mask - 服务器相关的方法
//生成接口请求对象
- (MessageObject *)msgObjWithOptNumber:(int)optNumber dataDic:(id)aDataDic
{
    MessageObject *msgObj = [[MessageObject alloc] init];
    msgObj.sync_usrStr = _msgSocket.userStr;
    msgObj.sync_pwdStr = _msgSocket.passwordStr;
    msgObj.sync_optInt = optNumber;
    msgObj.sync_snStr = [self convertCurrentDateToString];
    msgObj.sync_data = aDataDic;
    
    NSLog(@"CurrentDate:%@",msgObj.sync_snStr);
    
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
    [self.dataBase saveNewNote:self.noteInfo success:^{
        
    } failed:^{
        
    }];

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
    
    self.syncServerNotes =  [SyncServerNotes sharedSyncServerNotes];
    self.syncServerNotes.user = _msgSocket.userStr;
    self.syncServerNotes.password = _msgSocket.passwordStr;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self.syncServerNotes syncServerNotesWhenConnectionToServerSucess:YES];
    });
}
//连接服务器
-(void)connectServer
{
    _msgSocket = [[IHMsgSocket alloc] init];
    _msgSocket.delegate = self;
    
    [_msgSocket connectToHost:@"192.168.10.106" onPort:2222];
}
#pragma mask - view生命周期
-(void)viewWillAppear:(BOOL)animated
{
    //keyboard
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //server
    [self connectServer];
    
    self.syncServerNotes = [SyncServerNotes sharedSyncServerNotes];
   // self.view.backgroundColor = [UIColor yellowColor];
    // Do any additional setup after loading the view.
    
    self.rowHeights = [[NSMutableArray alloc] init];
    self.noteContent = [[NSMutableArray alloc] init];
    
//    self.createNoteView = [[CreateNoteView alloc]initWithFrame:CGRectMake(120, 120, 350, 560)];
//    self.createNoteView.creatNoteTableView.delegate = self;
//    self.createNoteView.creatNoteTableView.dataSource = self;
//    self.createNoteView.creatNoteTableView.showsVerticalScrollIndicator = NO;
//    self.createNoteTableViewFrame = self.createNoteView.creatNoteTableView.frame;
//    
//    [self.createNoteView.cancel addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.createNoteView.save addTarget:self action:@selector(saveBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.createNoteView.zoomInOut addTarget:self action:@selector(zoomInOutAction:) forControlEvents:UIControlEventTouchUpInside];
    //init note info
    self.noteInfo = [[NoteInfo alloc]init];
    ////for test
    PatientData *patient1 = [[PatientData alloc]init];
    patient1.area = @"病区1";
    patient1.location = @"+1床";
    patient1.name = @"YOUYOU";
    patient1.gender = @"女";
    patient1.creatDate = @"2014.10.22 星期五 上午8：20";
    patient1.age = @"25";
  
    patient1.personImage = UIImagePNGRepresentation([UIImage imageNamed:@"profileImage"]);
    
    self.noteInfo.patientInfo = patient1;
    
    //self.noteInfo.hasPatientData = YES;
    self.rowCount = 19;
#warning 从服务器上load patient info,load完后掉用方法[self changeShowNoteDetailTableFrame]显示信息;
    [self.view addSubview:self.createNoteView];
  
    [self showPatientData:self.noteInfo.patientInfo inView:self.createNoteView];
    //data base
    self.dataBase = [NotebookDatabase initDatabase];
    
 
    [self changeShowNoteDetailTableFrame];
}
-(void)showPatientData:(PatientData*)patientData inView:(CreateNoteView*)createNoteView
{
    if(patientData){
        createNoteView.imageView.image = [UIImage imageWithData:patientData.personImage];
        createNoteView.areaLabel.text = patientData.area;
        createNoteView.nameLabel.text = patientData.name;
        createNoteView.locationLabel.text = patientData.location;
        createNoteView.genderLabel.text = patientData.gender;
        createNoteView.ageLabel.text = patientData.age;
    }
}
-(CreateNoteView *)createNoteView
{
    if(_createNoteView == nil){
        _createNoteView = [[CreateNoteView alloc]initWithFrame:CGRectMake(120, 120, 350, 560)];
        _createNoteView.creatNoteTableView.delegate = self;
        _createNoteView.creatNoteTableView.dataSource = self;
        _createNoteView.creatNoteTableView.showsVerticalScrollIndicator = NO;
        _createNoteTableViewFrame = self.createNoteView.creatNoteTableView.frame;
        _createNoteView.textField.delegate = self;
        _createTitleFrame = _createNoteView.textField.frame;
        
        [_createNoteView.cancel addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_createNoteView.save addTarget:self action:@selector(saveBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_createNoteView.zoomInOut addTarget:self action:@selector(zoomInOutAction:) forControlEvents:UIControlEventTouchUpInside];
    
    }
    return _createNoteView;
}
-(void)changeShowNoteDetailTableFrame
{
    
        UITableView *tableView = self.createNoteView.creatNoteTableView;
        UITextField *tempTextField = self.createNoteView.textField;
    
        if(self.noteInfo.patientInfo == nil){
            CGRect rect = self.createNoteTableViewFrame;
            rect.origin.y = rect.origin.y - 73;//search bar height + 2
            rect.size.height = CGRectGetHeight(self.createNoteTableViewFrame) + 73;
            
            CGRect tempTextFieldRect = self.createTitleFrame;
            tempTextFieldRect.origin.y =tempTextFieldRect.origin.y - 73;
            [UIView animateWithDuration:0.25 animations:^{
                tableView.frame = rect;
                self.createNoteView.tempViewForPatient.alpha = 0;
                tempTextField.frame = tempTextFieldRect;
            }];
        }else {
            
            [UIView animateWithDuration:0.25 animations:^{
                tableView.frame = self.createNoteTableViewFrame;
                tempTextField.frame = self.createTitleFrame;
                self.createNoteView.tempViewForPatient.alpha = 1;
            }];
        }
}

#pragma mask - 键盘方法
//keyboard method
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    if(self.keyboardShow)
        return;
    
    self.keyboardShow = YES;
    
    // Get the keyboard size
    UIScrollView *tableView;
    if([self.createNoteView.creatNoteTableView.superview isKindOfClass:[UIScrollView class]])
        tableView = (UIScrollView *)self.createNoteView.creatNoteTableView.superview;
    else
        tableView = self.createNoteView.creatNoteTableView;
    
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [tableView.superview convertRect:[aValue CGRectValue] fromView:nil];
    
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
                         animations:^{ tableView.frame = tableFrame; }
                         completion:^(BOOL finished){ [self tableAnimationEnded:nil finished:nil contextInfo:nil]; }];
    }
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    if(!self.keyboardShow)
        return;
    
    self.keyboardShow = NO;
    
    UIScrollView *tableView;
    if([self.createNoteView.creatNoteTableView.superview isKindOfClass:[UIScrollView class]])
        tableView = (UIScrollView *)self.createNoteView.creatNoteTableView.superview;
    else
        tableView = self.createNoteView.creatNoteTableView;
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
                     completion:nil];
}

- (void) tableAnimationEnded:(NSString*)animationID finished:(NSNumber *)finished contextInfo:(void *)context
{
    // Scroll to the active cell
    UITableView *tableView = self.createNoteView.creatNoteTableView;
    if(self.currentIndexPath)
    {
        [tableView scrollToRowAtIndexPath:self.currentIndexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
        [tableView selectRowAtIndexPath:self.currentIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

#pragma mask - 控制按钮方法
// button method
-(void)zoomInOutAction:(UIButton*)sender
{
  
}
-(void)cancelBtnAction:(UIButton*)sender
{
    
}
-(void)saveBtnAction:(UIButton*)sender
{
    NSString *dateString = [self convertCurrentDateToString];
    
    self.noteInfo.noteContents = [self convertContainsNoBlankLineArrayToString:self.noteContent];
    self.noteInfo.creatDateString = dateString;
    self.noteInfo.updateDateString = dateString;
    self.noteInfo.has_network = 1;
   // self.noteInfo.note_type = @"default_type";
    self.noteInfo.is_public = 0;
    self.noteInfo.is_delete = 0;
    self.noteInfo.modf_people = user;
   // self.noteInfo.serverTime = @"default_time";
    
    NSLog(@"noteinfo: title: %@, contents:%@, creatDate:%@,updateDate:%@",self.noteInfo.titleName,self.noteInfo.noteContents,self.noteInfo.creatDateString,self.noteInfo.updateDateString);
    NSLog(@"self.noteContent : %@",self.noteContent);
    NSLog(@"self.note title : %@",self.noteInfo.titleName);
    //save to data base
    
    NSLog(@"note content : %@",self.noteInfo.noteContents);
    NSLog(@"note creatdate : %@",self.noteInfo.creatDateString);
    NSLog(@"note updatedate : %@",self.noteInfo.updateDateString);
    NSLog(@"note titleName : %@",self.noteInfo.titleName);

// 判断当前网络是否存在
    if(NetworkJudge){
        if(self.connectionServerSucess){
            [self saveDataToServer];
        }else {
            [self connectServer];
            if(self.connectionServerSucess){
                 [self saveDataToServer];
            }
        }
    }else {
        self.noteInfo.createNotePeople = user;
        self.noteInfo.has_network = 0;
        self.noteInfo.is_delete = 0;

        //self.noteInfo.noteUIID = @"defaultUUID";
        [self.dataBase saveNewNote:self.noteInfo success:^{
            [self printNoteInfo:self.noteInfo];
        } failed:^{
            
        }];
    }
}

-(void)saveDataToServer
{
    self.noteInfo.createNotePeople = _msgSocket.userStr;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:self.noteInfo.titleName forKey:@"note_name"];
    [dict setObject:self.noteInfo.noteContents forKey:@"content"];
    [dict setObject:self.noteInfo.creatDateString forKey:@"create_time"];
    [dict setObject:self.noteInfo.createNotePeople forKey:@"create_people"];
    [dict setObject:self.noteInfo.updateDateString forKey:@"update_time"];
    
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
            self.noteInfo.noteUIID = reqDict[@"note_id"];
            self.noteInfo.serverTime = reqDict[@"stime"];
        }
    }
    self.noteInfo.has_network = 1;
    self.noteInfo.is_delete = 0;
    self.noteInfo.createNotePeople = _msgSocket.userStr;
    self.noteInfo.modf_people = _msgSocket.userStr;
    [self.dataBase saveNewNote:self.noteInfo success:^{
       [self printNoteInfo:self.noteInfo];
    } failed:^{
       
    }];
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
-(NSString*)convertCurrentDateToString
{
    NSString *retvString;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss cc SSS"];
    retvString = [formatter stringFromDate:[NSDate date]];
    NSLog(@"retvString date : %@",retvString);
    return retvString;
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
#pragma mask - table view delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.rowCount;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"creatNoteTableCell";
    EditingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil){
        cell = [[EditingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.delegate = self;
        
    }
    NSInteger contentCount = self.noteContent.count;
    if(contentCount != 0 && indexPath.row < contentCount){
        cell.inputField.text = [self.noteContent objectAtIndex:indexPath.row];
        
    }else {
        cell.inputField.text = @"";
    }
    
    
    cell.indexStr = [NSString stringWithFormat:@"%ld",indexPath.row];
    cell.inputField.tag = indexPath.row;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowHeightsCount = self.rowHeights.count;
    if(rowHeightsCount != 0 && indexPath.row < rowHeightsCount){
        return [[self.rowHeights objectAtIndex:indexPath.row] floatValue];
    }else {
        return UITableViewAutomaticDimension;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    NSInteger rowHeightsCount = self.rowHeights.count;
    if(rowHeightsCount != 0 && indexPath.row < rowHeightsCount){
        height = [[self.rowHeights objectAtIndex:indexPath.row] floatValue];
        //NSLog(@"self.cellHeights:%d,height:%lf,indexPath.ro:%d",rowHeightsCount,height,indexPath.row);
    }else {
        height = 44;
    }
    
    if(height < 44.0f){
        height = 44.0f;
    }
    return height;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{

    //只允许对有数据的行进行删除操作
    NSInteger rowHeightsCount = self.rowHeights.count;
    if(rowHeightsCount != 0 && indexPath.row <= rowHeightsCount){
        return YES;
    }else {
        return NO;
    }
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete && self.noteContent.count > 0 && self.noteContent.count != indexPath.row){
    
        self.rowCount -=1;
        
        [self.rowHeights removeObjectAtIndex:indexPath.row];
        [self.noteContent removeObjectAtIndex:indexPath.row];
        
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView endUpdates];
    }
}
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    CGRect headerRect = CGRectMake(0, 0, tableView.frame.size.width, 45);
//    UITextField *tableHeader = [[UITextField alloc] initWithFrame:headerRect];
//    tableHeader.textColor = [UIColor blackColor];
//    tableHeader.backgroundColor = [UIColor whiteColor];
//    tableHeader.opaque = YES;
//    tableHeader.delegate = self;
//    tableHeader.placeholder = @"输入标题";
//    tableHeader.textAlignment = NSTextAlignmentCenter;
//    tableHeader.font = [UIFont boldSystemFontOfSize:22];
//    tableHeader.layer.borderColor = [UIColor orangeColor].CGColor;
//    tableHeader.layer.borderWidth = 3;
//    //tableHeader.text = @"术前讨论";
//    return tableHeader;
//    
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 45;
//}
#pragma mask - textfield delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    self.noteInfo.titleName = textField.text;
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
   
    self.noteInfo.titleName = textField.text;
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if([textField isFirstResponder]){
        [textField resignFirstResponder];
    }
    self.noteInfo.titleName = textField.text;
    NSLog(@"noteinfo titlename : %@",self.noteInfo.titleName);
}

#pragma  mask - cell delegate
- (void)growingCell:(EditingTableViewCell *)cell didChangeSize:(CGSize)size
{
   // [self.rowHeights setObject:@(size.height) atIndexedSubscript:[cell.indexStr intValue]];
    NSInteger rowHeightsCount = self.rowHeights.count;
    
    if(rowHeightsCount != 0 && [cell.indexStr intValue] < rowHeightsCount ){
        [self.rowHeights setObject:@(size.height) atIndexedSubscript:[cell.indexStr intValue]];
        [self.noteContent setObject:cell.inputField.text atIndexedSubscript:[cell.indexStr intValue]];
    }else {
        [self.rowHeights addObject:@(size.height)];
        [self.noteContent addObject:cell.inputField.text];
    }
    [self.createNoteView.creatNoteTableView beginUpdates];
    [self.createNoteView.creatNoteTableView endUpdates];
    
}
-(void)cellId:(EditingTableViewCell *)cell textView:(UITextView *)textView text:(NSString *)text
{
    CGSize size = [textView sizeThatFits:textView.frame.size];
    
    NSInteger rowHeightsCount = self.rowHeights.count;
    
    if(rowHeightsCount != 0 && [cell.indexStr intValue] < rowHeightsCount ){
        [self.rowHeights setObject:@(size.height) atIndexedSubscript:[cell.indexStr intValue]];
        [self.noteContent setObject:text atIndexedSubscript:[cell.indexStr intValue]];
    }else {
        [self.rowHeights addObject:@(size.height)];
        [self.noteContent addObject:text];
    }

    NSLog(@"self.cellHeights %@",self.rowHeights);
    NSLog(@"self.cellTextString %@",self.noteContent);
    [self insertNewCell];
}
-(void)cell:(EditingTableViewCell*)cell textView:(UITextView*)textView
{
    //当按下return事，从当前cell跳到下一个cell
    if(cell.inputField.tag+1 <= self.noteContent.count){
        UIView *nextResponder = [self.createNoteView.creatNoteTableView viewWithTag:cell.inputField.tag+1];
        if(nextResponder){
            if([nextResponder isKindOfClass:[UITextView class]]){
                
                [nextResponder becomeFirstResponder];
                
                NSIndexPath *temp = [NSIndexPath indexPathForRow:nextResponder.tag inSection:0];
                [self.createNoteView.creatNoteTableView scrollToRowAtIndexPath:temp atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
        }
    }

}
//如果self.rowCount != 10,table view 新增一行
-(void)insertNewCell
{
    if(self.rowCount < 19 || self.rowCount - self.noteContent.count < 2){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.rowCount++ inSection:0];
        [self.createNoteView.creatNoteTableView beginUpdates];
        [self.createNoteView.creatNoteTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.createNoteView.creatNoteTableView endUpdates];
    }
}

-(void)textViewDidStartEditing:(UITextView *)textView cell:(EditingTableViewCell *)cell
{
    self.currentIndexPath = [NSIndexPath indexPathForRow:cell.inputField.tag inSection:0];
    self.currentTextView = textView;
}
-(BOOL)textviewShouldBeginEditing:(UITextView *)textView
{
    if(textView.tag <= self.noteContent.count){
        return YES;
    }
    else {
        return NO;
    }
}

@end
