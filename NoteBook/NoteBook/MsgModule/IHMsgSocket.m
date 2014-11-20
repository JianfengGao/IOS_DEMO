//
//  IHMsgSocket.m
//  iosocket
//
//  Created by macHs on 14-2-25.
//  Copyright (c) 2014年 ihefe. All rights reserved.
//

#import "IHMsgSocket.h"
#import "ihefecommon.h"
#import "common.h"

@implementation IHSockRequest
- (id)init
{
    self = [super init];
    if (self)
    {
    }
    return self;
}
@end

@interface IHMsgSocket ()
{
    NSString *ipString;
    UInt16 portInt;
    
    NSInteger reconnectNum;
}

@end

@implementation IHMsgSocket

static IHMsgSocket *ihMsgSocket;

+(IHMsgSocket *)sharedRequest
{
    if (!ihMsgSocket) {
        ihMsgSocket=[[IHMsgSocket alloc] init];
        return ihMsgSocket;
    }
    return ihMsgSocket;
    
}

- (id)init
{
    self = [super init];
    if (self) {
        _IHGCDSocket = [[IHGCDSocket alloc] init];
        _IHGCDSocket.delegate=self;
        _IHGCDSocket.isPrint=1;
        _receiveTime=3;
        self.isPrint=1;
        _queueLists=[[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void)connectToHost:(NSString *)host onPort:(UInt16 )port
{
    ipString = host;
    portInt = port;
    
    [_IHGCDSocket connectToHost:host onPort:port];
}

//重连服务器
- (void)reconnectServer
{
    [_IHGCDSocket connectToHost:ipString onPort:portInt];
}

//- (void)addDataToLists:(MessageObject *)msgObj
//{
//    IHSockRequest *request = [[IHSockRequest alloc] init];
//    request.opt = msgObj.sync_optInt;
//    request.requestData = [NSMutableDictionary dictionary];
//    request.sn = msgObj.sync_snStr;
//    [_queueLists setObject:request forKey:request.sn];
//}

#pragma mark 发送数据
-(void)sendMsg:(MessageObject *)msgObj
{
//    [self addDataToLists:msgObj];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:msgObj.jsonDic options:NSJSONWritingPrettyPrinted error:nil];
    NSData *data = [[jsonData compress] base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength];
    [_IHGCDSocket sendDataToServer:data  ];
    
    
    
    
    
}

- (void)sendMsg:(MessageObject *)msgObj selector:(SEL)selector
{
    IHSockRequest *sock=[[IHSockRequest alloc]init];
    sock.opt=msgObj.sync_optInt;
    sock.requestData=msgObj.sync_data;
    sock.sn=msgObj.sync_snStr;
    sock.selector=selector;
    [_queueLists setObject:sock forKey:sock.sn];
    
    [self sendMsg:msgObj];
    
//    [self performSelector:@selector(sendDataOverTime:) withObject:sock afterDelay:_receiveTime];
}
- (void)sendMsg:(MessageObject *)msgObj completed:(void (^)(IHSockRequest *data))completed
{
    IHSockRequest *sock=[[IHSockRequest alloc]init];
    sock.opt=msgObj.sync_optInt;
    sock.requestData=msgObj.sync_data;
    sock.sn=msgObj.sync_snStr;
    sock.block=completed;
    [_queueLists setObject:sock forKey:msgObj.sync_snStr];
    
    [self sendMsg:msgObj];
    
//    [self performSelector:@selector(sendDataOverTime:) withObject:sock afterDelay:_receiveTime];
}
- (void)sendDataOverTime:(IHSockRequest *)request
{
    request.status=-1;
    if ([_queueLists count]>0) {
 
        if (_delegate && [_delegate respondsToSelector:request.selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [_delegate performSelector:request.selector withObject:request];
#pragma clang diagnostic pop
        }else if (request.block) {
            request.block(request);
        }else{
            [_delegate ihSocket:self didReceive:request ];
        }
 
    }else{
        [self ihPrint:@"null sendDataOverTime"];
    }
    
}

#pragma mark 接收回调
-(void)ihSocket:(IHGCDSocket *)ihGcdSock didReceive:(NSData *)data
{
    
    
    
    
    
    NSDictionary *dict=[self returnIdTodata:data];
 
//    [self ihPrint:dict];
    
    NSString *sn=[dict objectForKey:@"sync_sn"];
    
    NSString *opt=[dict objectForKey:@"sync_opt"];
    
    NSInteger resp = [[dict objectForKey:@"sync_resp"] integerValue];
    
    id datas=[dict objectForKey:@"sync_data"];
    
    IHSockRequest *response=(IHSockRequest *)[_queueLists objectForKey:sn];
    response.responseData=datas;
    
    NSInteger optnumber=[opt integerValue];
    
    response.opt = optnumber;
    response.resp = resp;
    
    if (optnumber==0)
    {
        [self sendheartbeatToServer:[dict objectForKey:@"alive"]];
    }
    else
    {
        if (_delegate && [_delegate respondsToSelector:response.selector])
        {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [_delegate performSelector:response.selector withObject:response];
#pragma clang diagnostic pop
        }
        else if (response.block)
        {
            response.block(response);
        }
        else
        {
            [_delegate ihSocket:self didReceive:response ];
        }

    }
//    switch (optnumber) {
//        case 320:
//            [self senderimge:[datas objectForKey:@"imgid"] receiver:[datas objectForKey:@"receiver"]];
//            break;
//            
//        default:
//            break;
//    }
}
//-(void)senderimge:(NSString *)imgid receiver:(NSString *)receiver
//{
//    NSLog(@"###############发送私聊大图片");
//    
//    NSMutableDictionary *dataDic=[NSMutableDictionary dictionary ];
// 
//    [dataDic setObject:imgid forKey:@"imgid"];
//    NSDate *currentDate = [NSDate date];
//    NSDateFormatter *format = [[NSDateFormatter alloc] init];
//    [format setDateFormat:@"yyyy_MM_dd_HH_mm_ss_SSS"];
//    NSString *dateStr = [format stringFromDate:currentDate];
//    [dataDic setObject:dateStr forKey:@"time"];
//    MessageObject *msgObj = [[MessageObject alloc] init];
//    msgObj.sync_usrStr = receiver;
//    msgObj.sync_pwdStr = @"1234";
//    msgObj.sync_optInt = 322;
//    msgObj.sync_dataDic = dataDic;
//    msgObj.sync_snStr=[self requestRandom];
//    
//    [self sendMsg:msgObj];
//}
//获取一个随机整数，范围在[from,to），包括from，不包括to
//-(NSString *)requestRandom
//{
//    NSString *random=[NSString stringWithFormat:@"%d",[self randomFrom:10000000 to:99999999] ];
//    return random;//+1,result is [from to]; else is [from, to)!!!!!!!
//}
//-(int )randomFrom:(int)from to:(int)to
//{
//    return (int)(from + (arc4random() % (to-from + 1)));//+1,result is [from to]; else is [from, to)!!!!!!!
//}
#pragma mark 转换数据
-(id)returnIdTodata:(NSData *)data
{
    NSData *finishData = [[[NSData alloc] initWithBase64EncodedData:data options:NSDataBase64DecodingIgnoreUnknownCharacters] uncompress];
    id jsonDic = [NSJSONSerialization JSONObjectWithData:finishData options:NSJSONReadingMutableContainers error:nil];
    return jsonDic;
}

#pragma mark - 向服务器发心跳包
- (void)sendheartbeatToServer:(NSString *)alive
{
    NSDictionary *dic = [NSDictionary dictionaryWithObject:alive forKey:@"alive"];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSData *data = [[jsonData compress] base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    [_IHGCDSocket sendDataToServer:data];
}

#pragma mark - 与服务器断开连接
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    if (NetworkJudge)
    {
        CGFloat delayTime = 0.0f;
        
        if ([[err localizedFailureReason] isEqualToString:@"Error in connect() function"])
        {
            delayTime = 10.0f;
        }
        
        if (reconnectNum <= 3)
        {
            reconnectNum++;
            
            [self performSelector:@selector(connectServer) withObject:nil afterDelay:delayTime];
        }
    }
}

- (void)connectServer
{
//    [self connectToHost:DataDemandIP onPort:DataDemandPort];
    [self reconnectServer];
}

- (void)connectServerSucceed:(IHGCDSocket *)ihGcdSock
{
    reconnectNum = 0;
    
    if ([self.delegate respondsToSelector:@selector(connectServerSucceed:)])
    {
        [self.delegate connectServerSucceed:self];
    }
    
//    if (self.userStr && self.passwordStr)
//    {
//        MessageObject *msgObj = [[MessageObject alloc] init];
//        
//        msgObj.sync_usrStr = self.userStr;
//        msgObj.sync_pwdStr = self.passwordStr;
//        msgObj.sync_optInt = 300;
//        
//        msgObj.sync_snStr = CurrentDate;
//        
//        [self sendMsg:msgObj];
//    }
    
}

-(void)ihPrint:(id)tit
{
//    if (self.isPrint) {
//        NSLog(@"%@",tit);
//    }
    
}

@end