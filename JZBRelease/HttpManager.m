//
//  HttpManager.m
//  D1CM
//
//  Created by ly on 14-10-27.
//  Copyright (c) 2014年 LiangYong. All rights reserved.
//

#import "HttpManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "Defaults.h"
#import "SBJson.h"

@implementation HttpManager
///单例
+(HttpManager *)shareManager
{
    static HttpManager *manager;
    static dispatch_once_t once;
    //一次只允许一个线程访问
    dispatch_once(&once, ^{
        if (manager == nil) {
            manager = [[HttpManager alloc] init];
        }
    });
    return manager;
}

///类方法封装post请求，方便外部调用
///请求地址，参数字典，请求完成和失败后的回调
+(void)requestWithUrlString:(NSString *)urlString parms:(NSDictionary *)dic finished:(AFFinishedBlock)finished failed:(AFFailedBlock)failed
{
//    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
//    [securityPolicy setAllowInvalidCertificates:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer.timeoutInterval = 30;
    //这里进行设置；
//    [manager setSecurityPolicy:securityPolicy];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //设置接收的服务器数据格式
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    //post 请求，并将两个block作为参数，manager,每执行一次请求方法，都自动创建一个NSOperation，并将operation加到了OperationQueue中
    [manager POST:urlString parameters:dic success:finished failure:failed];
}
///新东西，一定要严谨
///取消当前所有请求,在vc的dealloc方法中调用，防止数据请求下来之前，vc已经销毁二造成的崩溃
-(void)cancelAllRequests
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    if (manager.operationQueue.operationCount) {
        //通过queue取消请求
        [manager.operationQueue cancelAllOperations];
    }
}

///判断网络环境的方法,传递过来一个block
-(void)netStatus:(void(^)(AFNetworkReachabilityStatus status))statusBlock
{
    //AFNetworkReachabilityManager能够检测网络的状态和环境
    //开启网络监测
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    //调用网络状态方法，传进block参数，网络状态的判断为异步？意味着什么?
    //statusBlock:AFNetworkReachabilityStatusReachableViaWiFi-wifi或以太网环境
    //statusBlock:AFNetworkReachabilityStatusReachableViaWWAN-运营商的网络环境
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:statusBlock];
}

//uploadPictures和信息
+(void) uploadPictures : (NSDictionary *) param WithUrlString : (NSString *)urlString Image : (UIImage *) image{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //如果还需要上传其他的参数，参考上面的POST请求，创建一个可变字典，存入需要提交的参数内容，作为parameters的参数提交
    [manager POST:urlString parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         //_imageArray就是图片数组，我的_imageArray里面存的都是图片的data，下面可以直接取出来使用，如果存的是image，将image转换data的方法如下：NSData *imageData =
         
            NSData *data = UIImageJPEGRepresentation(image, 0.7);
            //上传的参数名
            NSString *name = [NSString stringWithFormat:@"file"];
            //上传的filename
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
         // 设置时间格式
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
         NSString *fileName = [NSString stringWithFormat:@"%@.png",str];
            [formData appendPartWithFileData:data
                                             name:name
                                         fileName:fileName
                                         mimeType:@"image/png"];
     }success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
        //json解析
         
         NSDictionary *dict = [[NSDictionary alloc]dictionaryWithJSON:responseObject];
         NSLog(@"---resultDic--%@",dict);
         if ([HttpManager shareManager].returnData) {
             [HttpManager shareManager].returnData(dict);
         }
         
         
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
              NSLog(@"---resultDic--%@",error);
          }];
}

+(BOOL) checkNetIsNormal{
    __block BOOL isNet = NO;
    [[HttpManager shareManager] netStatus:^(AFNetworkReachabilityStatus status) {
        if(status == AFNetworkReachabilityStatusReachableViaWWAN || status ==AFNetworkReachabilityStatusReachableViaWiFi){
            isNet = YES;
        }else{
            [Toast makeShowCommen:@"您的网络有问题 " ShowHighlight:@"请重置" HowLong:1.2];
        }
    }];
    return isNet;
}



+ (NSString *)postRequestWithURL: (NSString *)url
                      postParems: (NSMutableDictionary *)postParems
                         picFile: (NSMutableArray *)picAry
{
    
    
    NSString *hyphens = @"--";
    NSString *boundary = @"*****";
    NSString *end = @"\r\n";
    
    NSMutableData *myRequestData1=[NSMutableData data];
    //遍历数组，添加多张图片
    for (int i = 0; i < picAry.count; i ++) {
        NSData* data;
        UIImage *image=[picAry objectAtIndex:i];
        //判断图片是不是png格式的文件
        if (UIImagePNGRepresentation(image)) {
            //返回为png图像。
            data = UIImagePNGRepresentation(image);
        }else {
            //返回为JPEG图像。
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        
        //所有字段的拼接都不能缺少，要保证格式正确
        [myRequestData1 appendData:[hyphens dataUsingEncoding:NSUTF8StringEncoding]];
        [myRequestData1 appendData:[boundary dataUsingEncoding:NSUTF8StringEncoding]];
        [myRequestData1 appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSMutableString *fileTitle=[[NSMutableString alloc]init];
        //要上传的文件名和key，服务器端用file接收
        [fileTitle appendFormat:@"Content-Disposition:form-data;name=\"%@\";filename=\"%@\"",[NSString stringWithFormat:@"img%d",i+1],[NSString stringWithFormat:@"image%d.jpg",i+1]];
        
        [fileTitle appendString:end];
        
        [fileTitle appendString:[NSString stringWithFormat:@"Content-Type:application/octet-stream%@",end]];
        [fileTitle appendString:end];
        
        [myRequestData1 appendData:[fileTitle dataUsingEncoding:NSUTF8StringEncoding]];
        
        [myRequestData1 appendData:data];
        
        [myRequestData1 appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
        
    }
    
    
    [myRequestData1 appendData:[hyphens dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData1 appendData:[boundary dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData1 appendData:[hyphens dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData1 appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    //参数的集合的所有key的集合
    NSArray *keys= [postParems allKeys];
    
    //添加其他参数
    for(int i=0;i<[keys count];i++)
    {
        
        NSMutableString *body=[[NSMutableString alloc]init];
        [body appendString:hyphens];
        [body appendString:boundary];
        [body appendString:end];
        //得到当前key
        NSString *key=[keys objectAtIndex:i];
        //添加字段名称
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"",key];
        
        [body appendString:end];
        
        [body appendString:end];
        //添加字段的值
        [body appendFormat:@"%@",[postParems objectForKey:key]];
        
        [body appendString:end];
        
        [myRequestData1 appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"添加字段的值==%@",[postParems objectForKey:key]);
    }
    
    //根据url初始化request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:20];
    
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",boundary];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData1 length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData1];
    //http method
    [request setHTTPMethod:@"POST"];
    
    NSHTTPURLResponse *urlResponese = nil;
    NSError *error = [[NSError alloc]init];
    
    NSData* resultData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponese error:&error];
    NSString* result= [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    
    if([urlResponese statusCode] >=200&&[urlResponese statusCode]<300){
        NSLog(@"返回结果=====%@",result);
        SBJsonParser *parser = [[SBJsonParser alloc ] init];
        NSDictionary *jsonobj = [parser objectWithString:result];
        
        if (jsonobj == nil || (id)jsonobj == [NSNull null] || [[jsonobj objectForKey:@"flag"] intValue] == 0)
        {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"提交失败." delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"提交成功." delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                
                [alert show];
            });
        }
        
        return result;
    }
    else if (error) {
        NSLog(@"%@",error);
        [[NSNotificationCenter defaultCenter]postNotificationName:@"dissmissSVP" object:nil];
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"提交失败." delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return nil;
        
    }
    else
        return nil;
    
}



@end
