//
//  payForWechat.m
//  JZBRelease
//
//  Created by Apple on 16/10/29.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "payForWechat.h"
#import "wechatPayItem.h"

#import "AppDelegate.h"

@implementation payForWechat

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static payForWechat *instance;
    dispatch_once(&onceToken, ^{
        instance = [[payForWechat alloc] init];
    });
    return instance;
}

// 1：充值 2：升级会员 3:购买课程  [class_id 课时ID]
+ (void)payForWechat:(NSString *)price type:(NSString *)type class_id:(NSString *)class_id
{
    
    AppDelegate *appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    if ([type isEqualToString:@"2"]) {
        appD.payType = @"2";
    }else {
        appD.payType = @"1";
    }
    
    NSDictionary *parameters;
    
    if (class_id) {
        parameters = @{
                                     @"access_token":[[LoginVM getInstance]readLocal].token,
                                     @"price":price,
                                     @"type":type,
                                     @"class_id":class_id
                                     };
    }else {
        parameters = @{
                       @"access_token":[[LoginVM getInstance]readLocal].token,
                       @"price":price,
                       @"type":type
                       };
    }
    
    
    
    
    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Pay/WechatPay/createOrder"] parameters:parameters success:^(id json) {
        
        if ([json[@"state"] isEqual:@(0)]) {
            [SVProgressHUD showInfoWithStatus:json[@"info"]];
            return ;
        }
        
        wechatPayItem *item = [wechatPayItem mj_objectWithKeyValues:json[@"data"]];
        
        NSNumber *timestamp = item.timestamp;
        
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.partnerId           = item.partnerid;
        req.prepayId            = item.prepayid;
        req.nonceStr            = item.noncestr;
        req.timeStamp           = timestamp.intValue;
        req.package             = item.package;
        req.sign                = item.sign;
        
        //日志输出
        NSLog(@"日志输出appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",json[@"data"][@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
        
        NSLog(@"请求结果%d",[WXApi sendReq:req]);
        
        AppDelegate *appD = (AppDelegate*) [UIApplication sharedApplication].delegate;
        appD.isWechatPay = YES;
        
        
    } failure:^(NSError *error) {
        
    }];
}




@end
