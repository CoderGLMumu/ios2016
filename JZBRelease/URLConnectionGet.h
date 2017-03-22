//
//  URLConnectionGet.h
//  SNSPost
//
//  Created by ly on 14-10-17.
//  Copyright (c) 2014年  江 志磊. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef  void (^DownloadFinishedBlock)(NSData *data);
typedef  void (^DownloadFailedBlock)(NSString *errorMessage);

@interface URLConnectionGet : NSObject<NSURLConnectionDataDelegate>
/**
 *1.封装urlConnection get
 */
- (void)downloadDataWithUrlString:(NSString *)urlString finished:(DownloadFinishedBlock)finishedBlock failed:(DownloadFailedBlock)failedBlock;

@end
