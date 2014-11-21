//
//  common.m
//  ihefe
//
//  Created by macHs on 14-3-14.
//  Copyright (c) 2014年 shuai huang. All rights reserved.
//

#import "common.h"
#import <UIKit/UIKit.h>
@interface common ()

@end
@implementation common
 
#pragma mark - 获得当前时间
+ (NSString *)gainCurrentDateString
{
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy_MM_dd_HH_mm_ss_SSS"];
    NSString *dateStr = [format stringFromDate:currentDate];
    
    return dateStr;
}

#pragma mark - 检测当前网络状态
+ (BOOL)currentNetworkStatus
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    BOOL connected;
    const char *host = "www.baidu.com";
    
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, host);
    SCNetworkReachabilityFlags flags;
    connected = SCNetworkReachabilityGetFlags(reachability, &flags);
    BOOL isConnected = YES;
    isConnected = connected && (flags & kSCNetworkFlagsReachable) && !(flags & kSCNetworkFlagsConnectionRequired);
    CFRelease(reachability);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if(!isConnected)
    {
        return NO;
    }
    else
    {
        return isConnected;
    }
    
    return isConnected;
}


@end
