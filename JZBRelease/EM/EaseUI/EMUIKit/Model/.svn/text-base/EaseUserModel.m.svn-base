/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import "EaseUserModel.h"

@implementation EaseUserModel

- (instancetype)initWithBuddy:(NSString *)buddy
{
    self = [super init];
    if (self) {
        _buddy = buddy;
        _nickname = @"";
        _avatarImage = [UIImage imageNamed:@"EaseUIResource.bundle/user"];
//        _avatarImage = [UIImage imageNamed:@"pic_USER.png"];
//        NSLog(@"test,,%@",_avatarImage);
    }
    
    return self;
}

//archiveRootObject这个方法底层会去调用保存对象的encodeWithCoder方法,去询问要保存这个对象的哪些属性.
//只有遵守了NSCoding协议之后才能够实现这个方法.
-(void)encodeWithCoder:(NSCoder *)encode{
    
    [encode encodeObject:self.buddy forKey:@"buddy"];
    [encode encodeObject:self.uid forKey:@"uid"];
    [encode encodeObject:self.nickname forKey:@"nickname"];
    [encode encodeObject:self.avatarURLPath forKey:@"avatarURLPath"];
    [encode encodeObject:self.avatarImage forKey:@"avatarImage"];
}

//NSKeyedUnarchiver会调用initWithCoder这个方法,来让你告诉它去获取这个对象的哪些属性.
//initWithCoder什么时候调用:解析一个文件的时候就会调用.
-(instancetype)initWithCoder:(NSCoder *)decoder{
    
    if (self = [super init]) {
//        self.buddy = [decoder decodeObjectForKey:@"buddy"];
        self.uid = [decoder decodeObjectForKey:@"uid"];
        self.nickname = [decoder decodeObjectForKey:@"nickname"];
        self.avatarURLPath = [decoder decodeObjectForKey:@"avatarURLPath"];
        self.avatarImage = [decoder decodeObjectForKey:@"avatarImage"];
    }
    return self;
}

@end
