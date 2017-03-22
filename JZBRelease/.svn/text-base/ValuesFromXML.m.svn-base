//
//  ValuesFromXML.m
//  goutongbao
//
//  Created by zcl on 15/8/3.
//  Copyright (c) 2015年 zcl. All rights reserved.
//

#import "ValuesFromXML.h"


@implementation ValuesFromXML

+(NSString *) getValueWithName:(NSString *)name WithKind:(XMLType)kind{
    NSString *value = nil;
    NSString *plistPath = nil;
    if (XMLTypePic == kind) {
        plistPath = [[NSBundle mainBundle] pathForResource:@"pic" ofType:@"strings"];
    }else if (XMLTypeColors == kind){
        plistPath = [[NSBundle mainBundle] pathForResource:@"colors" ofType:@"strings"];
    }else if (XMLTypeNetPort == kind){
        plistPath = [[NSBundle mainBundle] pathForResource:@"netport" ofType:@"strings"];
    }else if (XMLTypeBase == kind){
        plistPath = [[NSBundle mainBundle] pathForResource:@"bases" ofType:@"strings"];
    }
    if (plistPath != nil) {
        NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        if (data != nil) {
            value = [[data objectForKey:name] copy];
            data = nil;
            plistPath = nil;
        }
    }
    return value;
}

+ (UIColor *)getColor:(NSString *)hexColor
{
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    
    
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green / 255.0f) blue:(float)(blue / 255.0f) alpha:1.0f];
}

@end
