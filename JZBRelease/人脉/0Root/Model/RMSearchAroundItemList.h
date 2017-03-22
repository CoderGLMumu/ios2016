//
//  RMSearchAroundItemList.h
//  JZBRelease
//
//  Created by zjapple on 16/8/17.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Users.h"

@interface RMSearchAroundItemList : NSObject

/** 创建时间 */
@property (nonatomic, strong) NSString *create_time;
/** 地址 */
@property (nonatomic, strong) NSString *address;
/** 城市 */
@property (nonatomic, strong) NSString *city;
/** community */
@property (nonatomic, strong) NSString *community;
/** 市区 */
@property (nonatomic, strong) NSString *district;
/** 省份 */
@property (nonatomic, strong) NSString *province;
/** lat */
@property (nonatomic, strong) NSString *lat;
/** lng */
@property (nonatomic, strong) NSString *lng;
/** uid */
@property (nonatomic, strong) NSString *uid;
/** user */
@property (nonatomic, strong) Users *user;

@end
