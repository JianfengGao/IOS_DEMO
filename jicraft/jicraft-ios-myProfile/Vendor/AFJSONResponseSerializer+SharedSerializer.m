//
//  AFJSONResponseSerializer+SharedSerializer.m
//  jicraft
//
//  Created by JERRY LIU on 19/9/14.
//  Copyright (c) 2014 com.jicraft. All rights reserved.
//

#import "AFJSONResponseSerializer+SharedSerializer.h"

@implementation AFJSONResponseSerializer (SharedSerializer)
+(instancetype)sharedSerializer {
    return [AFJSONResponseSerializer serializer];
}
@end
