//
//  SendAndGetDataFromNet.h
//  JZBRelease
//
//  Created by zjapple on 16/6/6.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "GetValueObject.h"

static NSString *abPath = @"Sever_Absolute_Address";

@interface SendAndGetDataFromNet : GetValueObject

-(void) commenDataFromNet : (GetValueObject *) model WithRelativePath : (NSString *) relPath;

-(void) dictDataFromNet : (GetValueObject *) model WithRelativePath : (NSString *) relPath;

-(void) dictFromNet : (GetValueObject *) model WithRelativePath : (NSString *) relPath;

-(void) commenDictFromNet : (NSDictionary *) param WithRelativePath:(NSString *)relPath;

-(void) arrayDataFromNet : (GetValueObject *) model WithRelativePath : (NSString *) relPath;

@property (nonatomic,strong) void (^ returnModel)(GetValueObject *respons, int state);
@property (nonatomic,strong) void (^ returnArray)(NSArray *ary);
@property (nonatomic,strong) void (^ returnDict)(NSDictionary *dict);
@end
