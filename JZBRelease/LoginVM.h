//
//  LoginVM.h
//  JZBRelease
//
//  Created by zjapple on 16/5/17.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UserInfo.h"
#import "Users.h"

@interface LoginVM : NSObject

@property(nonatomic,copy) void (^jumpToTab)(int state,NSString *info);
@property(nonatomic,copy) void (^isGetToken)();
@property(nonatomic,strong) UserInfo *userInfo;
@property(nonatomic,strong) Users *users;

+(instancetype) getInstance;

-(BOOL)loginWithUserInfo : (UserInfo *) userInfo;

-(BOOL)loginWithUserInfoForGetNewToken : (UserInfo *) userInfo;
-(UserInfo *)readLocal;

-(NSString *) getAccountHomePath;


@end
