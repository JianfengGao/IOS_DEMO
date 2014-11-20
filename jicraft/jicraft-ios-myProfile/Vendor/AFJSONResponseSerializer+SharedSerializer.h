//
//  AFJSONResponseSerializer+SharedSerializer.h
//  jicraft
//
//  Created by JERRY LIU on 19/9/14.
//  Copyright (c) 2014 com.jicraft. All rights reserved.
//

#import "AFURLResponseSerialization.h"

@interface AFJSONResponseSerializer (SharedSerializer)
+(instancetype)sharedSerializer;
@end
