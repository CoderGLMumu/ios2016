//
//  GetDynamicDetailVM.m
//  JZBRelease
//
//  Created by zjapple on 16/6/2.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "GetDynamicDetailVM.h"
#import "LoginVM.h"
#import "ValuesFromXML.h"
#import "HttpManager.h"
#import "SBJson.h"
@implementation GetDynamicDetailVM


-(void) getDynamicDetailFromNet : (StatusModel *) model{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:[[LoginVM getInstance] readLocal].token forKey:@"access_token"];
    [param setObject:model.id forKey:@"id"];
    [param setObject:@"0" forKey:@"pid"];
    NSString *url = [[ValuesFromXML getValueWithName:@"Sever_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:[ValuesFromXML getValueWithName:@"Get_DynamicList" WithKind:XMLTypeNetPort]];
    __block StatusModel *wModel = model;
    [HttpManager requestWithUrlString:url parms:param finished:^(AFHTTPRequestOperation *oper, id responseObj) {
        NSDictionary *dict = [[NSDictionary alloc]dictionaryWithJSON:responseObj];
        NSLog(@"%@",dict);
        if ([dict isKindOfClass:[NSDictionary class]]) {
            wModel = [self getStatusModelListAndSaveToLocal:dict];
            if (self.returnStatusModel) {
                self.returnStatusModel(wModel);
            }
        }
    } failed:^(AFHTTPRequestOperation *oper, NSError *error) {
        
    }];
}

-(StatusModel *) getStatusModelListAndSaveToLocal : (NSDictionary *) dict{
    if ([[dict objectForKey:@"state"] intValue] == 1) {
        NSDictionary *data = [dict objectForKey:@"data"];
        if ([data isKindOfClass:[NSDictionary class]]) {
            StatusModel *model = [StatusModel mj_objectWithKeyValues:data];
            return model;
        }
    }
    return nil;
}

@end
