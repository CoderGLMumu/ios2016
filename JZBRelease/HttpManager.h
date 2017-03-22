//
//  HttpManager.h
//  D1CM
//
//  Created by ly on 14-10-27.
//  Copyright (c) 2014年 LiangYong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "AFHTTPRequestOperation.h"

///数据请求完成的block
typedef void(^AFFinishedBlock)(AFHTTPRequestOperation *oper,id responseObj);
///请求失败的block
typedef void (^AFFailedBlock)(AFHTTPRequestOperation *oper,NSError *error);

///封装AFNetWorking操作
@interface HttpManager : NSObject

///单例
+(HttpManager *)shareManager;

///类方法封装post请求，方便外部调用
///请求地址，参数字典，请求完成和失败后的回调
+(void)requestWithUrlString:(NSString *)urlString parms:(NSDictionary *)dic finished:(AFFinishedBlock)finished failed:(AFFailedBlock)failed;

///取消当前所有请求
-(void)cancelAllRequests;

///判断网络环境的方法,传递过来一个block
-(void)netStatus:(void(^)(AFNetworkReachabilityStatus status))statusBlock;

+(BOOL) checkNetIsNormal;

@property(nonatomic, copy)void(^returnData)(NSDictionary *dict);

//uploadPictures和信息
+(void) uploadPictures : (NSDictionary *) param WithUrlString : (NSString *)urlString Image : (UIImage *) image;

+ (NSString *)postRequestWithURL: (NSString *)url
                      postParems: (NSMutableDictionary *)postParems
                         picFile: (NSMutableArray *)picAry;
@end
