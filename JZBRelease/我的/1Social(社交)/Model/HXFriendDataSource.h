//
//  HXFriendDataSource.h
//  JZBRelease
//
//  Created by zjapple on 16/8/3.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXFriendDataSource : GetValueObject

/** jzb用户uid */
@property (nonatomic, strong) NSString *uid;
/** nickname */
@property (nonatomic, strong) NSString *nickname;
/** UserModel */
@property (nonatomic, strong) EaseUserModel *UserModel;

/** 拼接环信id */
@property (nonatomic, strong) NSString *HXid;

@end
