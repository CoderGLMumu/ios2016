//
//  GetDynamicList.m
//  JZBRelease
//
//  Created by zjapple on 16/5/31.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "GetDynamicListVM.h"
#import "ValuesFromXML.h"
#import "HttpManager.h"
#import "SBJson.h"
#import "StatusModel.h"
#import "LoginVM.h"

@implementation GetDynamicListVM

-(void) getDynamicListFromNet : (GetDynamicListModel *) getDynamicListModel{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:getDynamicListModel.access_token forKey:@"access_token"];
    [param setObject:getDynamicListModel.id forKey:@"id"];
    [param setObject:getDynamicListModel.pid forKey:@"pid"];
    NSMutableArray *dataAry = [[NSMutableArray alloc]init];
    __block NSMutableArray *wDataAry = dataAry;
    NSString *url = [[ValuesFromXML getValueWithName:@"Sever_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:[ValuesFromXML getValueWithName:@"Get_DynamicList" WithKind:XMLTypeNetPort]];
    
    [HttpManager requestWithUrlString:url parms:param finished:^(AFHTTPRequestOperation *oper, id responseObj) {
        NSDictionary *dict = [[NSDictionary alloc]dictionaryWithJSON:responseObj];
         NSLog(@"%@",dict);
        if ([dict isKindOfClass:[NSDictionary class]]) {
            wDataAry = [self getStatusModelListAndSaveToLocal:dict];
            if (self.returnDataAry) {
                self.returnDataAry(wDataAry);
            }
        }
    } failed:^(AFHTTPRequestOperation *oper, NSError *error) {
        if (self.returnDataAry) {
            self.returnDataAry(nil);
        }
    }];
}

-(NSMutableArray *) getStatusModelListAndSaveToLocal : (NSDictionary *) dict{
    NSMutableArray *dataAry = [[NSMutableArray alloc]init];
    if ([[dict objectForKey:@"state"] intValue] == 1) {
        NSArray *data = [dict objectForKey:@"data"];
        if ([data isKindOfClass:[NSArray class]]) {
            for (int i = 0; i < data.count; i ++) {
                StatusModel *model = [StatusModel mj_objectWithKeyValues:[data objectAtIndex:i]];
                if (model) {
                    [dataAry addObject:model];
                }
            }
            //write to local
            NSString *path = [[[LoginVM getInstance] getAccountHomePath] stringByAppendingPathComponent:@"DynamicList.plist"];
            SBJsonWriter *sbJosn = [[SBJsonWriter alloc]init];
            NSString *dataString = [sbJosn stringWithObject:dict];
            [dataString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
        }
    }
    return dataAry;
}

-(NSMutableArray *) getDynamicListFromLocal{
    NSMutableArray *dataAry = nil;
    NSString *path = [[[LoginVM getInstance] getAccountHomePath] stringByAppendingPathComponent:@"DynamicList.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExist = [fileManager fileExistsAtPath:path];
    if (isExist) {
        NSString *dataString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        if (dataString) {
            NSDictionary *dict = [dataString JSONValue];
            dataAry = [[NSMutableArray alloc]init];
            NSArray *data = [dict objectForKey:@"data"];
            if ([data isKindOfClass:[NSArray class]]) {
                for (int i = 0; i < data.count; i ++) {
                    StatusModel *model = [StatusModel mj_objectWithKeyValues:[data objectAtIndex:i]];
                    if (model) {
                        [dataAry addObject:model];
                    }
                }
            }

        }
    }
    return dataAry;
}

@end
