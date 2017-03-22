//
//  UserInfo.m
//  JZBRelease
//
//  Created by zjapple on 16/5/17.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo


-(NSString *)description
{
    return [NSString stringWithFormat:@"account=%@,password=%@,token=%@",_account,_password,_token];
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.account forKey:@"account"];
    [aCoder encodeObject:self.password forKey:@"password"];
    [aCoder encodeObject:self.token forKey:@"token"];
    [aCoder encodeObject:self._id forKey:@"_id"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self)
    {
        self.account = [aDecoder decodeObjectForKey:@"account"];
        self.password = [aDecoder decodeObjectForKey:@"password"];
        self.token = [aDecoder decodeObjectForKey:@"token"];
        self._id = [aDecoder decodeObjectForKey:@"_id"];
    }
    return self;

}



@end
