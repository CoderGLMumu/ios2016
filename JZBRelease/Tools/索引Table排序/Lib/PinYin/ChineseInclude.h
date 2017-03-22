//
//  ChineseInclude.h
//  Search
//
//  Created by LYZ on 14-1-24.
//  Copyright (c) 2014年 LYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RecommendPersonItem.h"

@interface ChineseInclude : NSObject
+ (BOOL)isIncludeChineseInString:(NSString*)str;

+ (BOOL)isIncludeChineseInString2:(RecommendPersonItem *)item;
@end
