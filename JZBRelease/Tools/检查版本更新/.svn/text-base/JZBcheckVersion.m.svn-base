//
//  JZBcheckVersion.m
//  JZBRelease
//
//  Created by Apple on 16/12/27.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "JZBcheckVersion.h"

#import "GLSaveTool.h"

#import "BCH_Alert.h"

@implementation JZBcheckVersion

#define JZBNetVersion @"JZBNetVersion"

+ (void)upVersion
{
    
    HttpBaseRequestItem *item = [HttpBaseRequestItem new];
    item.version = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    item.access_token = [LoginVM getInstance].readLocal.token;
    
    NSDictionary *parameters = item.mj_keyValues;
    
    
    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/User/version"] parameters:parameters success:^(id json) {
        
//        JZBcheckVersionItem *item = [JZBcheckVersionItem mj_objectWithKeyValues:json];
        GLLog(@"%@",json)
        
    } failure:^(NSError *error) {
        
    }];

}

+ (void)checkVersion:(BOOL)isLogin
{
      HttpBaseRequestItem *item = [HttpBaseRequestItem new];
      item.type = @"2";

      NSDictionary *parameters = item.mj_keyValues;

        [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/Version/checkVersion"] parameters:parameters success:^(id json) {

            JZBcheckVersionItem *item = [JZBcheckVersionItem mj_objectWithKeyValues:json];

//            NSString *preV = [GLSaveTool objectForKey:JZBNetVersion];
            
            NSString *curV =  [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
            NSString *netV = item.versionname;
            
            if (netV) {
                
                if ([curV isEqualToString:netV]) {
                    
                    if (!isLogin) {
                        [SVProgressHUD showInfoWithStatus:@"亲，当前版本没有更新"];
                    }
                    
                }else {
                    // 弹出提示框 跳转 AppStore 下载
                    
                    [self pop_upTipInfo:item];
                }
                
            }else {
//                [GLSaveTool setObject:item.versioncode forKey:JZBNetVersion];
            }

    //            NSLog(@"TTT--json%@",json);
        } failure:^(NSError *error) {

        }];
}

+ (void)pop_upTipInfo:(JZBcheckVersionItem *)newVersionItem
{
//    [UIView bch_showWithTitle:@"请进行版本更新" cancelTitle:@"取消" destructiveTitle:nil otherTitles:@[@"立即更新"] callback:^(id sender, NSInteger buttonIndex) {
//        
//        if (buttonIndex == 0) {
//            
//            // 立即更新
//            
//            [payForWechat payForWechat:fateLabel.text type:@"2" class_id:nil];
//            
//        }else if (buttonIndex == 1) {
//
//        }
//        
//    }];
    
    [UIView bch_showWithTitle:@"请进行版本更新" message:[NSString stringWithFormat:@"更新内容\n%@",newVersionItem.updatetips] buttonTitles:@[@"取消",@"立即更新"] callback:^(id sender, NSUInteger buttonIndex) {
        if (buttonIndex == 0) {
            
            // 取消
            
//            [payForWechat payForWechat:fateLabel.text type:@"2" class_id:nil];
            
        }else if (buttonIndex == 1) {
            
            // 立即更新
            [self pushAppstore:newVersionItem];
        }
    }];
}

+ (void)pushAppstore:(JZBcheckVersionItem *)newVersionItem
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:newVersionItem.apkurl]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:newVersionItem.apkurl]];
    }
    
}

//+ (void)saveNewVersion
//{
//    NSString *preV = [GLSaveTool objectForKey:JZBNetVersion];
//    
//    int i = preV.intValue;
//    
//    i = i + 1;
//    
//    [GLSaveTool setObject:[NSString stringWithFormat:@"%d",i] forKey:JZBNetVersion];
//    
//}

@end
