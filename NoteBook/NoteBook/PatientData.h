//
//  PatientData.h
//  NoteBook
//
//  Created by ihefe-JF on 14-10-15.
//  Copyright (c) 2014年 ihefe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PatientData : NSObject
@property(strong,nonatomic) NSData *personImage;
@property(strong,nonatomic) NSString *area;
@property(strong,nonatomic) NSString *location;
@property(strong,nonatomic) NSString *name;
@property(strong,nonatomic) NSString *gender;
@property(nonatomic,strong) NSString *age;
@property(nonatomic,strong) NSString *creatDate;
-(id)initWithProfileImage:(NSData*)profileImage area:(NSString*)area location:(NSString*)location name:(NSString*)name gender:(NSString*)gender age:(NSString*)age;
@end
