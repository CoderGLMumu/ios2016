//
//  Users.m
//  沟通宝
//
//  Created by zcl on 14/10/14.
//  Copyright (c) 2014年 zcl. All rights reserved.
//

#import "Users.h"

@implementation Users

- (void)encodeWithCoder:(NSCoder *)aCoder //将属性进行编码
{
    
    [aCoder encodeObject:self.uid forKey:@"Usersuid"];
    [aCoder encodeObject:self.nickname forKey:@"Usersnickname"];
    [aCoder encodeObject:self.company forKey:@"Userscompany"];
    [aCoder encodeObject:self.job forKey:@"Usersjob"];
    [aCoder encodeObject:self.avatar forKey:@"Usersavatar"];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder //将属性进行解码
{
    self = [super init];
    if (self) {
        self.uid = [aDecoder decodeObjectForKey:@"Usersuid"];
        self.nickname = [aDecoder decodeObjectForKey:@"Usersnickname"];
        self.company = [aDecoder decodeObjectForKey:@"Userscompany"];
        self.job = [aDecoder decodeObjectForKey:@"Usersjob"];
        self.avatar = [aDecoder decodeObjectForKey:@"Usersavatar"];
        
    }
    return self;
}

@end
