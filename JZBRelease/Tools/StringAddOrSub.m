//
//  StringAddOrSub.m
//  JZBRelease
//
//  Created by zjapple on 16/9/21.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "StringAddOrSub.h"

@implementation StringAddOrSub

+ (NSString *)addStringWithNum:(NSInteger)inte
{

    NSString *resultStr = @"";
    
    inte++;
    
    resultStr = [NSString stringWithFormat:@"%ld",inte];
    
    
    return resultStr;
}

+ (NSString *)SubStringWithNum:(NSInteger)inte
{
    
    NSString *resultStr = @"";
    
    inte--;
    
    resultStr = [NSString stringWithFormat:@"%ld",inte];
    
    
    return resultStr;
}

@end
