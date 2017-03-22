//
//  GLSaveTool.m
//  JZBRelease
//
//  Created by Apple on 16/11/7.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "GLSaveTool.h"

@implementation GLSaveTool

//根据key值从偏好设置中获取指定的值
+ (id) objectForKey:(NSString *)key {
    
    return  [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

//根据指定的key,存储指定的值
+ (void)setObject:(id)object forKey:(NSString *)key {
    
    [[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
}

@end
