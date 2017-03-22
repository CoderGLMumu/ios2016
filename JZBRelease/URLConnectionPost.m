//
//  URLConnectionPost.m
//  SNSPost
//
//  Created by ly on 14-10-17.
//  Copyright (c) 2014年  江 志磊. All rights reserved.
//

#import "URLConnectionPost.h"

@implementation URLConnectionPost
{
    NSURLConnection *_urlConnection;
    NSMutableData *_downloadData;
    DownloadFinishedBlock _finishedBlock;
    DownloadFailedBlock _failedBlock;
}
/**
 *2.封装urlConnection post
 *参数包括地址、请求方式、带有请求参数的字典、数据的组织类型(Content-Type)
 */
- (void)postDownloadWithUrlString:(NSString *)urlString method:(NSString *)method parms:(NSDictionary *)dic ContentType:(NSString*)type finished:(DownloadFinishedBlock)finishedBlock failed:(DownloadFailedBlock)failedBlock{
    if (_finishedBlock!=finishedBlock) {
        _finishedBlock = nil;
        _finishedBlock = finishedBlock;
    }
    if (_failedBlock!=failedBlock) {
        _failedBlock = nil;
        _failedBlock = failedBlock;
    }
    NSURL *url = [NSURL URLWithString:urlString];
    //请求用可变的,能够配置请求头、请求体和请求方法
    //请求地址默认作为请求头的信息
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //设置请求方式 (GET/POST)
    [request setHTTPMethod:method];
    //Content-Type (作为请求头，告诉服务器 请求体参数的组织形式)
    [request setValue:type forHTTPHeaderField:@"Content-Type"];
    //拼接请求体参数(urlencoded)
    NSMutableString *bodyString = [NSMutableString string];
    //快速遍历字典的方法
    int i =0;
    for (NSString *key in dic) {
        id obj = [dic objectForKey:key];
        if (i==0) {
            [bodyString appendFormat:@"%@=%@",key,obj];
        }else{
            [bodyString appendFormat:@"&%@=%@",key,obj];
        }
        i++;
    }
    NSLog(@"body:%@",bodyString);
    //将参数转化成data
    NSData *body = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    //将参数的长度作为请求头
    [request setValue:[NSString stringWithFormat:@"%ld",body.length] forHTTPHeaderField:@"Content-Length"];
    /*******************请求体******************/
    [request setHTTPBody:body];
    if (_urlConnection) {
        [_urlConnection cancel];
        _urlConnection = nil;
    }
    //将设置好的request 给到connection
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
        _failedBlock(error.localizedDescription);
    }
}
@end
