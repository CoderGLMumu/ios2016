//
//  AddHostToLoadPIC.m
//  JZBRelease
//
//  Created by zjapple on 16/7/29.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "AddHostToLoadPIC.h"

@implementation AddHostToLoadPIC

+ (NSString *)AddHostToLoadPICWithString:(NSString *)str
{
    if (str) {
        str = [@"https://bang.jianzhongbang.com" stringByAppendingString:str];
    }
    return str;
}

//图片绝对地址
//"Images_Absolute_Address"="http://bang.jianzhongbang.com";

//http://192.168.10.154

@end
