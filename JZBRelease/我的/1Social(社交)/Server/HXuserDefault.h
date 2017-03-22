//
//  HXuserDefault.h
//  JZBRelease
//
//  Created by zjapple on 16/8/15.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXuserDefault : NSObject

/** 禁言信息 */
@property (nonatomic, strong) NSDictionary *extras;

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)shareTools;

@end
