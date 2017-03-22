//
//  payFOrAlipay.h
//  JZBRelease
//
//  Created by Apple on 16/10/29.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, AlipayCallBackType) {
    AlipayCallBackType9000 = 9000, //订单支付成功
    AlipayCallBackType8000 = 8000, //正在处理中，支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
    AlipayCallBackType4000 = 4000, //订单支付失败
    AlipayCallBackType5000 = 5000, //重复请求
    AlipayCallBackType6001 = 6001, //用户中途取消
    AlipayCallBackType6002 = 6002, //网络连接出错
    AlipayCallBackType6004 = 6004, //支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态【其它	其它支付错误】
};

@interface payForAlipay : NSObject

+ (void)payForAlipay:(NSString *)price type:(NSString *)type class_id:(NSString *)class_id;

+ (void)payforShowCallBackInfo:(NSDictionary *)dict;

@end
