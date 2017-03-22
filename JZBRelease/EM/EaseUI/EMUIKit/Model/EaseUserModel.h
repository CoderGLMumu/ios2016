/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import <Foundation/Foundation.h>

#import "IUserModel.h"

@interface EaseUserModel : NSObject<IUserModel , NSCoding>

@property (strong, nonatomic, readonly) NSString *buddy;
// 拼接自定义用户member_
@property (strong, nonatomic) NSString *uid;
@property (strong, nonatomic) NSString *nickname;
@property (strong, nonatomic) NSString *avatarURLPath;
@property (strong, nonatomic) UIImage *avatarImage;

- (instancetype)initWithBuddy:(NSString *)buddy;

@end