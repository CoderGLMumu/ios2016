//
//  PublicLogOutUser.m
//  JZBRelease
//
//  Created by Apple on 17/1/10.
//  Copyright © 2017年 zjapple. All rights reserved.
//

#import "PublicLogOutUser.h"

#import "PlayerDowning.h"
#import "ZFDownloadManager.h"
#import "LoginVC.h"

@implementation PublicLogOutUser

+ (void)logOutUser:(UINavigationController *)nav
{
    [[PlayerDowning sharePlayerDowning]ClickAllPause:nil];
    
    [ZFDownloadManager sharedInstance].sessionModelsArray = nil;
    
    LoginVC *loginVC = [[LoginVC alloc]init];
    
    AppDelegate *appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    appD.notAutoLogin = YES;
    NSUserDefaults *defautls = [NSUserDefaults standardUserDefaults];
    [defautls setBool:appD.notAutoLogin forKey:@"notAutoLogin"];
    
    loginVC.isClearPassword = YES;
    
    [nav pushViewController:loginVC animated:YES];
    
    EMError *error = [[EMClient sharedClient] logout:YES];
    if (!error) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD showInfoWithStatus:@"退出成功"];
        });
    }
}

+ (void)logOutUser:(UINavigationController *)nav netWorkLoOut:(BOOL)isnetWorkLoOut 
{
    [[PlayerDowning sharePlayerDowning]ClickAllPause:nil];
    
    [ZFDownloadManager sharedInstance].sessionModelsArray = nil;
    
    LoginVC *loginVC = [[LoginVC alloc]init];
    
    AppDelegate *appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    appD.notAutoLogin = YES;
    NSUserDefaults *defautls = [NSUserDefaults standardUserDefaults];
    [defautls setBool:appD.notAutoLogin forKey:@"notAutoLogin"];
    
    [nav pushViewController:loginVC animated:YES];
    
    EMError *error = [[EMClient sharedClient] logout:YES];
    if (!error) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD showInfoWithStatus:@"网络原因,需要您重新登录"];;
        });
    }
}

@end
