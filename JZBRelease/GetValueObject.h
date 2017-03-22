//
//  GetValueObject.h
//  JZBRelease
//
//  Created by zjapple on 16/5/28.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
#import "LWAlchemy.h"
#import "ValuesFromXML.h"

typedef NS_ENUM(NSInteger,Clink_Type){
    Clink_Type_One = 0,
    Clink_Type_Two = 1,
    Clink_Type_Three = 2,
    Clink_Type_Four = 3,
    Clink_Type_Five = 4,
    Clink_Type_Six = 5,
    Clink_Type_Seven = 6,
    Clink_Type_Eight = 7,
    Clink_Type_Nine = 8,
    Clink_Type_Ten = 9,
    Clink_Type_UserIcon = 99,
    Clink_Type_Background = 98,
};

@interface GetValueObject : NSObject

- (NSArray *) allPropertyNames;

- (SEL) creatGetterWithPropertyName: (NSString *) propertyName;

-(id) getValueWithPropertyName : (NSString *) name;

+ (NSDictionary *) entityToDictionary:(id)entity;
@property(nonatomic,assign) int inteval;
@property(nonatomic,assign) int imageWidth;
@property(nonatomic,assign) int avatarWidth;
@property(nonatomic,assign) float fontSize;
@property(nonatomic,copy) NSString *info;

+(NSString *) compareCurrentTime:(NSDate*) compareDate;
@end
