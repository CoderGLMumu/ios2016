//
//  FollowGroupModel.m
//  剧能玩2.1
//
//  Created by 大兵布莱恩特  on 15/11/11.
//  Copyright © 2015年 大兵布莱恩特 . All rights reserved.
//

#import "FollowGroupModel.h"
#import "PinYinForObjc.h"
#import "FollowModel.h"

#import "RecommendPersonItem.h"

@implementation FollowGroupModel

//+ (instancetype)getGroupsWithArray:(NSMutableArray*)dataArray groupTitle:(NSString*)title
//{
//    NSMutableArray *tempArray = [NSMutableArray array];
//    FollowGroupModel *group = [[FollowGroupModel alloc] init];
//    for (NSString *str in dataArray)
//    {
//        NSString *header = [PinYinForObjc chineseConvertToPinYinHead:str];
//        if ([header isEqualToString:title])
//        {
//            FollowModel *followM = [[FollowModel alloc] init];
//            followM.img_Url = @"";
//            followM.nickname = str;
//            [tempArray addObject:followM];
//        }
//    }
//    group.groupTitle = title;
//    group.follows = tempArray;
//    return group;
//}

+ (instancetype)getGroupsWithArray:(NSMutableArray*)dataArray groupTitle:(NSString*)title
{
    // 数组模型Users
    NSMutableArray *tempArray = [NSMutableArray array];
    FollowGroupModel *group = [[FollowGroupModel alloc] init];
    
    int i = 0;
    
    for (RecommendPersonItem *item in dataArray)
    {
        
        NSString *str = item.nickname;
        
        NSString *header = [PinYinForObjc chineseConvertToPinYinHead:str];
        if ([header isEqualToString:title])
        {
//            FollowModel *followM = [[FollowModel alloc] init];
//            followM.img_Url = @"";
//            followM.nickname = str;
//            [tempArray addObject:followM];
//            Users *user = [Users new];
////            user.img_Url = @"";
////            user.nickname = str;
//            
//            user = tempArray[i];
            
            [tempArray addObject:item];
            
            
            
        }
        i = i + 1;
    }
    group.groupTitle = title;
    group.follows = tempArray;
    return group;
}


@end
