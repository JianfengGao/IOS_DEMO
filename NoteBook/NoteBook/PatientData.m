//
//  PatientData.m
//  NoteBook
//
//  Created by ihefe-JF on 14-10-15.
//  Copyright (c) 2014年 ihefe. All rights reserved.
//

#import "PatientData.h"

@implementation PatientData
-(id)initWithProfileImage:(NSData*)profileImage area:(NSString*)area location:(NSString*)location name:(NSString*)name gender:(NSString*)gender age:(NSString*)age
{
    if(self = [super init]){
        self.personImage = profileImage;
        self.area = [area isEqualToString:@"(null)"] ? @"":area;
        self.location = [location isEqualToString:@"(null)"] ? @"":location;
        self.name = [name isEqualToString:@"(null)"] ? @"":name;
        self.gender = [gender isEqualToString:@"(null)"] ? @"":gender;
        self.age = [age isEqualToString:@"(null)"] ? @"":age;
    }
    return self;
}
@end
