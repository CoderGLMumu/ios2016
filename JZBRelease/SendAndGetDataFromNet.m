//
//  SendAndGetDataFromNet.m
//  JZBRelease
//
//  Created by zjapple on 16/6/6.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "SendAndGetDataFromNet.h"
#import "HttpManager.h"
@implementation SendAndGetDataFromNet

-(void) commenDataFromNet : (GetValueObject *) model WithRelativePath:(NSString *)relPath{
    NSDictionary *param = [[model class] entityToDictionary:model];
    NSString *url = [[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:[ValuesFromXML getValueWithName:relPath WithKind:XMLTypeNetPort]];
    NSLog(@"%@",param);
    
    NSRange range0 = [url rangeOfString:@"https:/"];
    if (range0.length > 0) {
        url = [url stringByReplacingOccurrencesOfString:@"https:/" withString:@"https://"];
    }
    
    NSRange range1 = [url rangeOfString:@"https:///"];
    if (range1.length > 0) {
        url = [url stringByReplacingOccurrencesOfString:@"https:///" withString:@"https://"];
    }
    
    __weak GetValueObject *wModel = model;
    [HttpManager requestWithUrlString:url parms:param finished:^(AFHTTPRequestOperation *oper, id responseObj) {
        NSDictionary *dict = [[NSDictionary alloc]dictionaryWithJSON:responseObj];
        
        NSLog(@"%@",[dict objectForKey:@"info"]);
        wModel.info = [dict objectForKey:@"info"];
        if ([dict isKindOfClass:[NSDictionary class]]) {
            if (self.returnModel) {
                int state = [[dict objectForKey:@"state"] intValue];
                self.returnModel(wModel,state);
            }
        }
    } failed:^(AFHTTPRequestOperation *oper, NSError *error) {
        if (self.returnModel) {
            self.returnModel(nil,0);
        }
        NSLog(@"%@",error);
    }];
}

-(void) commenDictFromNet : (NSDictionary *) param WithRelativePath:(NSString *)relPath{
    //NSDictionary *param = [[model class] entityToDictionary:model];
    
    NSString *url = [[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:[ValuesFromXML getValueWithName:relPath WithKind:XMLTypeNetPort]];
    NSLog(@"%@",param);
    
    NSRange range0 = [url rangeOfString:@"https:/"];
    if (range0.length > 0) {
        url = [url stringByReplacingOccurrencesOfString:@"https:/" withString:@"https://"];
    }
    
    NSRange range1 = [url rangeOfString:@"https:///"];
    if (range1.length > 0) {
        url = [url stringByReplacingOccurrencesOfString:@"https:///" withString:@"https://"];
    }
    
    //__block GetValueObject *wModel = model;
    [HttpManager requestWithUrlString:url parms:param finished:^(AFHTTPRequestOperation *oper, id responseObj) {
        NSDictionary *dict = [[NSDictionary alloc]dictionaryWithJSON:responseObj];
        NSLog(@"%@",dict);
        if ([dict isKindOfClass:[NSDictionary class]]) {
            if (self.returnModel) {
                int state = [[dict objectForKey:@"state"] intValue];
                self.returnModel(nil,state);
            }
        }
    } failed:^(AFHTTPRequestOperation *oper, NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void) dictDataFromNet : (GetValueObject *) model WithRelativePath : (NSString *) relPath{
    NSDictionary *param = [[model class] entityToDictionary:model];
    NSString *url = [[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:[ValuesFromXML getValueWithName:relPath WithKind:XMLTypeNetPort]];
    NSLog(@"%@",param);
    
    NSRange range0 = [url rangeOfString:@"https:/"];
    if (range0.length > 0) {
        url = [url stringByReplacingOccurrencesOfString:@"https:/" withString:@"https://"];
    }
    
    NSRange range1 = [url rangeOfString:@"https:///"];
    if (range1.length > 0) {
        url = [url stringByReplacingOccurrencesOfString:@"https:///" withString:@"https://"];
    }
    
    [HttpManager requestWithUrlString:url parms:param finished:^(AFHTTPRequestOperation *oper, id responseObj) {
        NSDictionary *dict = [[NSDictionary alloc]dictionaryWithJSON:responseObj];
        NSLog(@"%@",dict);
        if ([dict isKindOfClass:[NSDictionary class]]) {
            if (self.returnArray) {
                int state = [[dict objectForKey:@"state"] intValue];
                NSArray *ary;
                if (1 == state) {
                    ary = [dict objectForKey:@"data"];
                }
                if ([ary isKindOfClass:[NSArray class]]) {
                    self.returnArray(ary);
                }else{
                    self.returnArray(nil);
                }
            }
        }
    } failed:^(AFHTTPRequestOperation *oper, NSError *error) {
        self.returnArray(nil);
        NSLog(@"%@",error);
    }];
}

-(void) dictFromNet : (GetValueObject *) model WithRelativePath : (NSString *) relPath{
    NSDictionary *param = [[model class] entityToDictionary:model];
    NSString *url = [[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:[ValuesFromXML getValueWithName:relPath WithKind:XMLTypeNetPort]];
    NSLog(@"%@",param);
    
    NSRange range0 = [url rangeOfString:@"https:/"];
    if (range0.length > 0) {
        url = [url stringByReplacingOccurrencesOfString:@"https:/" withString:@"https://"];
    }
    
    NSRange range1 = [url rangeOfString:@"https:///"];
    if (range1.length > 0) {
        url = [url stringByReplacingOccurrencesOfString:@"https:///" withString:@"https://"];
    }
    
    [HttpManager requestWithUrlString:url parms:param finished:^(AFHTTPRequestOperation *oper, id responseObj) {
        NSDictionary *dict = [[NSDictionary alloc]dictionaryWithJSON:responseObj];
        NSLog(@"%@",dict);
        if ([dict isKindOfClass:[NSDictionary class]]) {
            if (self.returnDict) {
                self.returnDict(dict);
            }
        }
    } failed:^(AFHTTPRequestOperation *oper, NSError *error) {
        if (self.returnDict) {
            self.returnDict(nil);
        }
        NSLog(@"%@",error);
    }];
}

-(void) arrayDataFromNet : (GetValueObject *) model WithRelativePath : (NSString *) relPath{
    NSDictionary *param = [[model class] entityToDictionary:model];
    NSString *url = [[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:[ValuesFromXML getValueWithName:relPath WithKind:XMLTypeNetPort]];
    NSLog(@"%@",param);
    
    NSRange range0 = [url rangeOfString:@"https:/"];
    if (range0.length > 0) {
        url = [url stringByReplacingOccurrencesOfString:@"https:/" withString:@"https://"];
    }
    
    NSRange range1 = [url rangeOfString:@"https:///"];
    if (range1.length > 0) {
        url = [url stringByReplacingOccurrencesOfString:@"https:///" withString:@"https://"];
    }
    
    [HttpManager requestWithUrlString:url parms:param finished:^(AFHTTPRequestOperation *oper, id responseObj) {
        NSArray *ary = [NSArray mj_objectArrayWithKeyValuesArray:responseObj];
        if ([ary isKindOfClass:[NSArray class]]) {
            if (self.returnArray) {
                self.returnArray(ary);
            }
        }
    } failed:^(AFHTTPRequestOperation *oper, NSError *error) {
        self.returnArray(nil);
        NSLog(@"%@",error);
    }];

}

@end
