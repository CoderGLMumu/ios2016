//
//  SendDynamicVM.m
//  JZBRelease
//
//  Created by zjapple on 16/5/24.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "SendDynamicVM.h"
#import "ValuesFromXML.h"
#import "HttpManager.h"
#import "Defaults.h"
@implementation SendDynamicVM


+(BOOL) sendDynamicModel : (SendDynamicModel *) model{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:model.access_token forKey:@"access_token"];
    [param setObject:model.type forKey:@"type"];
    [param setObject:model.content forKey:@"content"];
    [param setObject:model.address forKey:@"address"];
    
    NSString *url = [[ValuesFromXML getValueWithName:@"Sever_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:[ValuesFromXML getValueWithName:@"Send_Dynamic" WithKind:XMLTypeNetPort]];
    
   // [HttpManager uploadPictures:param WithUrlString:url ImageAry:model.pic];
    
//    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
//    [request setStringEncoding:NSUTF8StringEncoding];
//    [request setRequestMethod:@"POST"];
//    [request setPostValue:model.access_token forKey:@"access_token"];
//    [request setPostValue:model.type forKey:@"type"];
//    [request setPostValue:model.content forKey:@"content"];
//    [request setPostValue:model.address forKey:@"address"];
//    for (int i = 0; i < model.pic.count; i ++) {
//        NSData *imageData = UIImageJPEGRepresentation([model.pic objectAtIndex:i], 0.7);
//        NSString *imgName = [NSString stringWithFormat:@"img%d",i];
//        [request addData:imageData withFileName:imgName andContentType:@"image/jpeg" forKey:imgName];
//    }
//    [request setDelegate:self];
//    [request setDidFinishSelector:@selector(finishRequest:)];
//    [request setDidFailSelector:@selector(failRequest:)];
//    [request startSynchronous];
    return NO;
}

@end
