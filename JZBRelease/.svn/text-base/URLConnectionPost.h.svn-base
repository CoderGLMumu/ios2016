//
//  URLConnectionPost.h
//  SNSPost
//
//  Created by ly on 14-10-17.
//  Copyright (c) 2014年  江 志磊. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef  void (^DownloadFinishedBlock)(NSData *data);
typedef  void (^DownloadFailedBlock)(NSString *errorMessage);

@interface URLConnectionPost : NSObject<NSURLConnectionDataDelegate>
/**
 *2.封装urlConnection post
 *参数包括地址、请求方式、带有请求参数的字典、数据的组织类型(Content-Type)
 */
- (void)postDownloadWithUrlString:(NSString *)urlString method:(NSString *)method parms:(NSDictionary *)dic ContentType:(NSString*)type finished:(DownloadFinishedBlock)finishedBlock failed:(DownloadFailedBlock)failedBlock;
@end
