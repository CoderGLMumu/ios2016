//
//  UserInfo.h
//  JZBRelease
//
//  Created by zjapple on 16/5/17.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GetValueObject.h"

@interface UserInfo : GetValueObject<NSCoding>
@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *account;

@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *token;

@property (nonatomic, copy) NSString *imei;


@end
