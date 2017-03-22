//
//  HttpBaseRequestItem.h
//  JZBRelease
//
//  Created by Apple on 16/11/11.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpBaseRequestItem : NSObject
//  HttpBaseRequestItem *item = [HttpBaseRequestItem new];
@property (nonatomic, strong) NSString *access_token;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *repassword;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *industry_id;
@property (nonatomic, strong) NSString *company;
@property (nonatomic, strong) NSString *job;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *area;
@property (nonatomic, strong) NSString *avatar_id;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *newpassword;
@property (nonatomic, strong) NSString *renewpassword;
@property (nonatomic, strong) NSString *field;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) NSString *page;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *pid;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *question_id;
@property (nonatomic, strong) NSString *eval_id;
@property (nonatomic, strong) NSData *file;
@property (nonatomic, strong) NSString *audio_length;
@property (nonatomic, strong) NSString *keyword;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *class_id;
@property (nonatomic, strong) NSString *my;
@property (nonatomic, strong) NSString *version;


@property (nonatomic, strong) NSString *vip;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *message_type;

@end
