//
//  NetworkExceptionHandle.m
//  JZBRelease
//
//  Created by zjapple on 16/8/4.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "NetworkExceptionHandle.h"
#import "HttpToolSDK.h"
#import "SendAndGetDataFromNet.h"

@implementation NetworkExceptionHandle

+ (void)UpdataNewUserToken:(NSString *)access_token complete:(void(^)(NSString *access_token))complete
{
//    更新token
//    接口：/Web/web/get_token
//    参数：access_token
//    返回：access_token,例如（{"state":1,"info":"","data":{"access_token":"MTQ2MzU2MDY0MZzer6WLeqyZtLinysV3nKiMh3xnsoyEk32uiZSG3oqVhLjcnouPy9rGvXrNxGFppJSdfGezsnzYfXxkoA"},"error":{"errcode":0,"errmsg":""}}）
    
    
    
    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/web/get_token"] parameters:@{@"access_token":access_token} success:^(id json) {
//        NSLog(@"json%@",json);
        NSString *access_token = json[@"data"][@"access_token"];
        
        complete(access_token);
        
    } failure:^(NSError *error) {
        
    }];
}

@end
