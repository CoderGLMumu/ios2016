//
//  EvaluateModel.h
//  JZBRelease
//
//  Created by zjapple on 16/6/1.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "GetValueObject.h"
#import "Users.h"

@interface EvaluateModel : GetValueObject

@property (nullable, nonatomic, retain) NSString *eval_id;
@property (nullable, nonatomic, retain) NSString *dynamic_id;
@property (nullable, nonatomic, retain) NSString *id;
@property (nullable, nonatomic, retain) NSString *eval_uid;
//audio
@property (nullable, nonatomic, retain) NSString *audio_id;
@property (nullable, nonatomic, retain) NSString *audio;
@property (nullable, nonatomic, retain) NSString *audio_length;
@property (nullable, nonatomic, retain) NSString *longOrShort;

@property (nullable, nonatomic, retain) NSString *eval_u_nickname;
@property (nullable, nonatomic, retain) NSString *eval_to_uid;
@property (nullable, nonatomic, retain) NSString *eval_to_u_nickname;
@property (nullable, nonatomic, retain) NSString *eval_content;
@property (nullable, nonatomic, retain) NSString *create_time;
@property (nullable, nonatomic, retain) NSNumber *zan_count;
@property (nullable, nonatomic, retain) NSString *is_like;
@property (nullable, nonatomic, retain) NSNumber *like_count;
@property (nullable, nonatomic, retain) Users *user;
@property (nullable, nonatomic, retain) NSArray *_child;

@property (nonatomic, assign) NSInteger height;
@end
