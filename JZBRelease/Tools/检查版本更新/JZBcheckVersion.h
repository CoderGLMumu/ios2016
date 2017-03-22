//
//  JZBcheckVersion.h
//  JZBRelease
//
//  Created by Apple on 16/12/27.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JZBcheckVersionItem.h"

@interface JZBcheckVersion : NSObject

+ (void)upVersion;

+ (void)checkVersion:(BOOL)isLogin;

+ (void)pop_upTipInfo:(JZBcheckVersionItem *)newVersionItem;

//+ (void)saveNewVersion;

@end
