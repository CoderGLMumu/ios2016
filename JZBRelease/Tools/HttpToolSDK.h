//
//  HttpToolSDK.h
//  revaluation_Bili
//
//  Created by mac on 16/5/22.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
//[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/Friend/add"]

//NSDictionary *parameters = @{
//                             @"access_token":[LoginVM getInstance].readLocal.token,
//                             @"uid":@""
//                             };
//
//[HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/user/info"] parameters:parameters success:^(id json) {

//if ([json[@"state"] isEqual:@(0)]) {
//    [SVProgressHUD show];
//}

//    NSLog(@"TTT--json%@",json);
//} failure:^(NSError *error) {
//    
//}];

//        NSDictionary *parameters = @{
//                                     @"access_token":[LoginVM getInstance].readLocal.token
//                                     };
//  HttpBaseRequestItem *item = [HttpBaseRequestItem new];
//  item.access_token = [[LoginVM getInstance]readLocal].token;
//  item.question_id = question_id;
//  NSDictionary *parameters = item.mj_keyValues;

//
//        [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/Friend/get"] parameters:parameters success:^(id json) {
//
//            publicBaseJsonItem *item = [publicBaseJsonItem mj_objectWithKeyValues:json];
//
//        if ([item.state isEqual:@(0)]) {
//            [SVProgressHUD show];
//        }
//
////            NSLog(@"TTT--json%@",json);
//        } failure:^(NSError *error) {
//
//        }];


@interface HttpToolSDK : NSObject

/**
 *  封装get请求
 *
 *  @param URL        请求地址
 *  @param parameters 请求参数
 *  @param success    成功回调
 *  @param failure    失败回调
 */

+ (void)getWithURL:(NSString *)URL parameters:(NSDictionary *)parameters  success:(void (^)(id json))success failure: (void (^)(NSError *error))failure;

/**
 *  封装返回HTML数据的get请求
 *
 *  @param URL        请求地址
 *  @param parameters 请求参数
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)getHTMLDataWithURL:(NSString *)URL parameters:(NSDictionary *)parameters success:(void (^)(id string))success failure:(void (^)(NSError *error))failure;

/**
 *  封装post请求
 *
 *  @param URL        请求地址
 *  @param parameters 请求参数
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)postWithURL:(NSString *)URL parameters:(NSDictionary *)parameters success:(void (^)(id json))success failure:(void (^)(NSError *))failure;

/**
 *  封装带文件的POST请求
 *
 *  @param URL        请求地址
 *  @param parameters 请求参数
 *  @param dataArray  上传内容数组
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)postWithURL:(NSString *)URL parameters:(NSDictionary *)parameters fromDataArray:(NSArray *)dataArray success:(void (^)(id json))success failure:(void (^)(NSError *))failure;

+ (void)getXMLWithURL:(NSString *)URL parameters:(NSDictionary *)parameters  success:(void (^)(id json))success failure: (void (^)(NSError *error))failure;

+ (void)cancelAllRequest;

@end

/**
 *  上传文件中包含的参数
 */
@interface FromData : NSObject

/** 文件数据 */
@property(nonatomic, strong)NSData *data;
/** 参数名 */
@property (nonatomic, copy) NSString *name;
/** 文件名 */
@property (nonatomic, copy) NSString *filename;
/** 文件类型 */
@property (nonatomic, copy) NSString *mimeType;

@end
