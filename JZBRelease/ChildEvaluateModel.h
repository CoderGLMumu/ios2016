//
//  ChildEvaluateModel.h
//  JZBRelease
//
//  Created by zjapple on 16/6/2.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "GetValueObject.h"

@interface ChildEvaluateModel : GetValueObject

@property (nullable, nonatomic, retain) NSString *eval_id;
@property (nullable, nonatomic, retain) NSString *dynamic_id;
@property (nullable, nonatomic, retain) NSString *eval_uid;
@property (nullable, nonatomic, retain) NSString *eval_u_nickname;
@property (nullable, nonatomic, retain) NSString *eval_to_uid;
@property (nullable, nonatomic, retain) NSString *eval_to_u_nickname;
@property (nullable, nonatomic, retain) NSString *eval_content;
@property (nullable, nonatomic, retain) NSString *create_time;
@property (nullable, nonatomic, retain) Users *user;
@end
