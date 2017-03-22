//
//  FollowGroupModel.h
//  剧能玩2.1
//
//  Created by 大兵布莱恩特 on 15/11/11.
//  Copyright © 2015年 大兵布莱恩特 . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FollowGroupModel : NSObject
/**
 *  groupTitle
 */
@property (nonatomic,copy) NSString *groupTitle;
/**
 *  关注的模型类型
 */
@property (nonatomic,strong)NSMutableArray *follows;
/**
 *   根据首字母将相同首字母的字符串生成对应的群组 和一个个成员模型
 *
 *   @param dataArray 原始数组
 *   @param title     标题
 *
 *   @return 返回一个组模型
 */
+ (instancetype)getGroupsWithArray:(NSMutableArray*)dataArray groupTitle:(NSString*)title;

@end
