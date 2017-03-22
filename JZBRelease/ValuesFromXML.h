//
//  ValuesFromXML.h
//  goutongbao
//
//  Created by zcl on 15/8/3.
//  Copyright (c) 2015年 zcl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Foundation/NSObject.h>

typedef NS_ENUM(NSInteger,XMLType) {
    XMLTypePic = 0,
    XMLTypeColors = 1,
    XMLTypeNetPort = 2,
    XMLTypeBase = 3,
};

@interface ValuesFromXML : NSObject

+ (NSString *) getValueWithName : (NSString *) name WithKind : (XMLType) kind;

+ (UIColor *)getColor:(NSString *)hexColor;

@end
