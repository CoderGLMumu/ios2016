//
//  XBLiveListItem.m
//  JZBRelease
//
//  Created by zjapple on 16/9/14.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "XBLiveListItem.h"

@implementation XBLiveListItem

#pragma mark - 写在字典里
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"aid":@"id"};
}

@end
