//
//  HXDataHelper.m
//  JZBRelease
//
//  Created by zjapple on 16/8/6.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "HXDataHelper.h"
#import "HXFriendList.h"
#import "HXFriendDataSource.h"
#import "UserInfo.h"

#import "AddHostToLoadPIC.h"
#import "SendAndGetDataFromNet.h"

@interface HXDataHelper ()

/** userInfo */
@property (nonatomic, strong) UserInfo *userInfo;

/** FMDBTool */
@property (nonatomic, strong) GLFMDBToolSDK *FMDBTool;

@end

@implementation HXDataHelper

- (UserInfo *)userInfo
{
    if (_userInfo == nil) {
        _userInfo = [[UserInfo alloc] init];
    }
    return _userInfo;
}

- (GLFMDBToolSDK *)FMDBTool
{
    if (_FMDBTool == nil) {
        _FMDBTool = [GLFMDBToolSDK shareToolsWithCreateDDL:@""];
    }
    return _FMDBTool;
}

/** 获取服务器的好友并存入本地[中间有转换环信好友] */
- (void)loadHXDataWithComplete:(void(^)())complete
{
    //    获取好友列表
    //    接口：/Web/Friend/get
    //    参数:access_token
    //    返回：
    self.userInfo = [[LoginVM getInstance]readLocal];
    
    //    NSString *temp_str = [loginUsername substringFromIndex:7];
    
    NSDictionary *parameters = @{
                                 @"access_token":self.userInfo.token
                                 };
    
    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/Friend/get"] parameters:parameters success:^(id json) {
        
        if ([json[@"state"] isEqual:@(0)]) return ;
        
        NSArray *lists = [HXFriendList mj_objectArrayWithKeyValuesArray:json[@"data"]];
        if (lists) {
            NSDictionary *newLists = [self changeHXData:lists];
            
            //            NSCache *hxUserCache = [[NSCache alloc]init];
            //            [hxUserCache setObject:newLists forKey:@"HXData"];
            
            HXFriendDataSource *friendDataSource = [HXFriendDataSource new];
            
            /** FMDB缓存 */
            NSString *delete_sql = @"delete from t_HXFriendDataSource";
            [self.FMDBTool deleteWithSql:delete_sql];
            // 调用方法传递模型-数组
            if (newLists.count) {
//                self.FMDBTool = [GLFMDBToolSDK shareToolsWithCreateDDL:nil];
                
                for (NSString *nickname in newLists) {
                    friendDataSource.nickname = nickname;
                    friendDataSource.UserModel = newLists[nickname];
                    friendDataSource.uid = friendDataSource.UserModel.uid;
                    friendDataSource.HXid = [NSString stringWithFormat:@"member_%@",friendDataSource.uid];
                    NSString *insert_sql = [NSString stringWithFormat:@"insert into t_HXFriendDataSource (uid,nickname,HXid,UserModel) values('%@','%@','%@',?);",friendDataSource.uid,friendDataSource.nickname,friendDataSource.HXid];
                    [self.FMDBTool insertWithSql:insert_sql,[NSKeyedArchiver archivedDataWithRootObject:friendDataSource.UserModel] , nil];
                }
                
            }
            if (complete) {
                complete();
            }
        }
    } failure:^(NSError *error) {
        
    }];
    
}

/** 中间有转换环信好友 */
- (NSDictionary *)changeHXData:(NSArray *)lists
{
    NSMutableDictionary *ListsM = [NSMutableDictionary dictionary];
    
    for (HXFriendList *flists in lists) {
        NSString *buddy = flists.user[@"nickname"];
        EaseUserModel *model = [[EaseUserModel alloc] initWithBuddy:buddy];
        model.uid = flists.user[@"uid"];
        model.nickname = flists.user[@"nickname"];
//        model.avatarURLPath = [AddHostToLoadPIC AddHostToLoadPICWithString:flists.user[@"avatar"]];
        
        model.avatarURLPath = [LocalDataRW getImageAllStr:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:flists.user[@"avatar"]]];
        
//        [LocalDataRW getImageWithDirectory:Directory_WD RetalivePath:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:self.users.avatar] WithContainerImageView:self.avatarImageView];
        
        [ListsM setObject:model forKey:flists.user[@"nickname"]];
    }
    
    NSDictionary *newLists = [NSDictionary dictionaryWithDictionary:ListsM];
    
    return newLists;
}

- (NSString *)changeUidWithHXid:(NSString *)hxid
{
    
    NSString *result_str;
    
    // 传入DDL 创建表打开数据库[banner][entranceIcons][partitions]
    self.FMDBTool = [GLFMDBToolSDK shareToolsWithCreateDDL:nil];
    
    // 查询数据【banner】
    NSString *query_sql = @"select * from t_HXFriendDataSource";
    
    FMResultSet *result = [self.FMDBTool queryWithSql:query_sql];
    while ([result next]) { // next方法返回yes代表有数据可取
        HXFriendDataSource *friendDataSource = [HXFriendDataSource new];
        friendDataSource.uid = [result stringForColumn:@"uid"];
        friendDataSource.HXid = [result stringForColumn:@"HXid"];
        
        
        friendDataSource.nickname = [result stringForColumn:@"nickname"];
        friendDataSource.UserModel = [NSKeyedUnarchiver unarchiveObjectWithData:[result dataNoCopyForColumn:@"UserModel"]];
        
        if ([friendDataSource.HXid isEqualToString:hxid]) {
            result_str = friendDataSource.uid;
        }

    }
    return result_str;
}

@end
