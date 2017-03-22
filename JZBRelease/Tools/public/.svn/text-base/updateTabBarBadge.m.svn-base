//
//  updateTabBarBadge.m
//  JZBRelease
//
//  Created by Apple on 16/11/9.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "updateTabBarBadge.h"

@implementation updateTabBarBadge

+ (NSString *)updateTabBarBadgeNum
{
    NSUserDefaults *udefault = [NSUserDefaults standardUserDefaults];
//    NSInteger activity_newNum = [udefault integerForKey:@"Message_question_newNum233"];
    NSInteger question_newNum = [udefault integerForKey:@"Message_question_newNum"];
    NSInteger activity_newNum = [udefault integerForKey:@"Message_activity_newNum"];
    NSInteger MessageFriend_newNum = [udefault integerForKey:@"MessageFriend"];
    NSInteger GroupIdBadge = [udefault integerForKey:@"aGroupIdBadge"];
    NSInteger PInfoavatarBadge = [udefault integerForKey:@"PInfoavatarBadge"];
    
    NSInteger reference_newNum = [udefault integerForKey:@"Message_reference_newNum"];
    
    NSInteger course_LivenewNum = [udefault integerForKey:@"Message_course_LivenewNum"];
    NSInteger course_NownewNum = [udefault integerForKey:@"Message_course_NownewNum"];
    NSInteger wisdom_newNum = [udefault integerForKey:@"Message_wisdom_newNum"];
    
    return [NSString stringWithFormat:@"%ld",reference_newNum + question_newNum + activity_newNum + MessageFriend_newNum + GroupIdBadge + PInfoavatarBadge + course_LivenewNum + course_NownewNum + wisdom_newNum];
}

@end
