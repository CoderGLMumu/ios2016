//
//  StatusModel.h
//  LWAsyncDisplayViewDemo
//
//  Created by 刘微 on 16/4/5.
//  Copyright © 2016年 WayneInc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LWAlchemy.h"
#import "Users.h"
#import "GetValueObject.h"
@interface StatusModel : GetValueObject

@property (nullable, nonatomic, retain) NSString* id;
@property (nullable, nonatomic, retain) NSString *uid;
@property (nullable, nonatomic, retain) NSString *describe,*content;
@property (nullable, nonatomic, retain) NSString *address;
@property (nullable, nonatomic, retain) Users *user;
@property (nullable, nonatomic, retain) NSString *create_time;
@property (nullable, nonatomic, retain) NSNumber *status;
@property (nullable, nonatomic, retain) NSNumber *evaluation_count;
@property (nullable, nonatomic, retain) NSNumber *zan_count,*iszan;
@property (nullable, nonatomic, retain) NSNumber *reward_count;
@property (nullable, nonatomic, retain) NSNumber *share_count;
@property (nullable, nonatomic, retain) NSArray *images;
@property (nullable, nonatomic, retain) NSArray *evaluate;
@property (nullable, nonatomic, retain) NSArray *goodAry;
@property (nullable, nonatomic, retain) NSArray *shareAry;
@property (nullable, nonatomic, retain) NSArray *rewardAry;

@end
