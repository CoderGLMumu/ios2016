//
//  URLConnectionGet.m
//  SNSPost
//
//  Created by ly on 14-10-17.
//  Copyright (c) 2014年  江 志磊. All rights reserved.
//

#import "URLConnectionGet.h"

@implementation URLConnectionGet
{
    NSURLConnection *_urlConnection;
    NSMutableData *_downloadData;
    DownloadFinishedBlock _finishedBlock;
    DownloadFailedBlock _failedBlock;

}
/**
 *1.封装urlConnection get
 */
- (void)downloadDataWithUrlString:(NSString *)urlString finished:(DownloadFinishedBlock)finishedBlock failed:(DownloadFailedBlock)failedBlock{
    if (_finishedBlock!=finishedBlock) {
        _finishedBlock = nil;
        _finishedBlock = finishedBlock;
    }
    if (_failedBlock!=failedBlock) {
        _failedBlock = nil;
        _failedBlock = failedBlock;
    }
    NSURL *url = [NSURL URLWithString:urlString];

    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //清除旧的connecton
    if (_urlConnection) {
        [_urlConnection cancel];
        _urlConnection = nil;
    }
    //http协议  get请求
    _urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}
#pragma mark - delegate-get
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    if (_downloadData==nil) {
        _downloadData = [[NSMutableData alloc] init];
    }
    [_downloadData setLength:0];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [_downloadData appendData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    if (_downloadData&&_finishedBlock) {
        _finishedBlock(_downloadData);
    }
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    if (error&&_failedBlock) {
        //    void *_reserved;
        //NSInteger _code;
        //NSString *_domain;
        //NSDictionary *_userInfo;
        //NSString *error = [NSString stringWithFormat:@"error:%@ %@",error,error.description];
        _failedBlock(error.localizedDescription);
        NSLog(@"%@",error);
    }
}

@end
