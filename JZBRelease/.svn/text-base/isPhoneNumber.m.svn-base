//
//  isPhoneNumber.m
//  KBLove
//
//  Created by ly on 14-10-17.
//  Copyright (c) 2014年 qianfeng. All rights reserved.
//

#import "isPhoneNumber.h"

@implementation isPhoneNumber

+(BOOL)validateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString * phoneRegex = @"^(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

@end
