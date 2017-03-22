//
//  payFOrAlipay.m
//  JZBRelease
//
//  Created by Apple on 16/10/29.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "payForAlipay.h"
#import "publicBaseJsonItem.h"
#import "AlipaySDK.h"

#import "payAlipayItem.h"

#import "AppDelegate.h"

@implementation payForAlipay


// 1：充值 2：升级会员 3:购买课程  [class_id 课时ID]
+ (void)payForAlipay:(NSString *)price type:(NSString *)type class_id:(NSString *)class_id
{
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
    
    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Pay/AliPay/createOrder"] parameters:parameters success:^(id json) {
        
        publicBaseJsonItem *item = [publicBaseJsonItem mj_objectWithKeyValues:json];
        
        if ([item.state isEqual:@(0)]) {
            [SVProgressHUD showInfoWithStatus:item.info];
            return ;
        }
        
        NSString *appScheme = @"jzbrelease";
        
        [[AlipaySDK defaultService] payOrder:item.data fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//            NSLog(@"reslut = %@",resultDic);
//            [SVProgressHUD showInfoWithStatus:@"支付完成了"];
            payAlipayItem *item = [payAlipayItem mj_objectWithKeyValues:resultDic];
            
            if (item.resultStatus.integerValue == AlipayCallBackType9000) {
                [SVProgressHUD showInfoWithStatus:@"支付完成了"];
            }else if (item.resultStatus.integerValue == AlipayCallBackType8000) {
                [SVProgressHUD showInfoWithStatus:@"正在处理中"];
            }else if (item.resultStatus.integerValue == AlipayCallBackType4000) {
                [SVProgressHUD showInfoWithStatus:@"订单支付失败"];
            }else if (item.resultStatus.integerValue == AlipayCallBackType5000) {
                [SVProgressHUD showInfoWithStatus:@"重复请求"];
            }else if (item.resultStatus.integerValue == AlipayCallBackType6001) {
                [SVProgressHUD showInfoWithStatus:@"用户中途取消"];
            }else if (item.resultStatus.integerValue == AlipayCallBackType6002) {
                [SVProgressHUD showInfoWithStatus:@"网络连接出错"];
            }else if (item.resultStatus.integerValue == AlipayCallBackType6004) {
                [SVProgressHUD showInfoWithStatus:@"支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态"];
            }else {
                [SVProgressHUD showInfoWithStatus:@"支付失败"];
            }
        }];
        
    } failure:^(NSError *error) {
        
    }];
}


+ (void)payforShowCallBackInfo:(NSDictionary *)dict
{
   payAlipayItem *item = [payAlipayItem mj_objectWithKeyValues:dict];
    
    if (item.resultStatus.integerValue == AlipayCallBackType9000) {
        [SVProgressHUD showInfoWithStatus:@"支付成功了"];
        
        AppDelegate *appD = (AppDelegate*)[UIApplication sharedApplication].delegate;

        
        if ([appD.payType isEqualToString:@"2"]) {
            
            [[LoginVM getInstance]loginWithUserInfo:[[LoginVM getInstance]readLocal]];
        }
        
    }else if (item.resultStatus.integerValue == AlipayCallBackType8000) {
        [SVProgressHUD showInfoWithStatus:@"正在处理中"];
    }else if (item.resultStatus.integerValue == AlipayCallBackType4000) {
        [SVProgressHUD showInfoWithStatus:@"订单支付失败"];
    }else if (item.resultStatus.integerValue == AlipayCallBackType5000) {
        [SVProgressHUD showInfoWithStatus:@"重复请求"];
    }else if (item.resultStatus.integerValue == AlipayCallBackType6001) {
        [SVProgressHUD showInfoWithStatus:@"用户中途取消"];
    }else if (item.resultStatus.integerValue == AlipayCallBackType6002) {
        [SVProgressHUD showInfoWithStatus:@"网络连接出错"];
    }else if (item.resultStatus.integerValue == AlipayCallBackType6004) {
        [SVProgressHUD showInfoWithStatus:@"支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态"];
    }else {
        [SVProgressHUD showInfoWithStatus:@"支付失败"];
    }
    
    
    
}

@end
