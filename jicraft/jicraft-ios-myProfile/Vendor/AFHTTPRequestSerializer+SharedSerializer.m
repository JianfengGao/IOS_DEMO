//
//  AFHTTPRequestSerializer+SharedSerializer.m
//  jicraft
//
//  Created by JERRY LIU on 19/9/14.
//  Copyright (c) 2014 com.jicraft. All rights reserved.
//

#import "AFHTTPRequestSerializer+SharedSerializer.h"

@implementation AFHTTPRequestSerializer (SharedSerializer)
+(instancetype)sharedSerializer {
    return [AFHTTPRequestSerializer serializer];
}
@end
