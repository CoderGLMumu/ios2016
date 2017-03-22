//
//  payForWechat.h
//  JZBRelease
//
//  Created by Apple on 16/10/29.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

@interface payForWechat : NSObject<WXApiDelegate>

+ (void)payForWechat:(NSString *)price type:(NSString *)type class_id:(NSString *)class_id;

@end
