//
//  HXuserDefault.m
//  JZBRelease
//
//  Created by zjapple on 16/8/15.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "HXuserDefault.h"

@implementation HXuserDefault

static HXuserDefault *_instance;

- (instancetype)initWithDict:(NSDictionary *)dict
{
    
    self = [super init];
    if (self) {
        self.extras = dict;
    }
    return self;
}


//类方法，返回一个单例对象
+ (instancetype)shareTools
{
    //注意：使用self（考虑继承）
    
    return [[self alloc]init];
}

//保证永远只分配一次存储空间
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    //    使用GCD中的一次性代码
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });

    return _instance;
}

@end
