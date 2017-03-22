//
//  GLSaveTool.h
//  JZBRelease
//
//  Created by Apple on 16/11/7.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLSaveTool : NSObject

//根据key值从偏好设置中获取指定的值
+ (id) objectForKey:(NSString *)key;
//根据指定的key,存储指定的值
+ (void)setObject:(id)object forKey:(NSString *)key;

@end
