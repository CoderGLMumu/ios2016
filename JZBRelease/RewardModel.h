//
//  RewardModel.h
//  JZBRelease
//
//  Created by zjapple on 16/6/13.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "GetValueObject.h"

@interface RewardModel : GetValueObject

@property(nonatomic,strong) NSString *access_token;
@property(nonatomic,strong) NSString *dynamic_id;
@property(nonatomic,strong) NSString *id;
@property(nonatomic,strong) NSString *score;
@property(nonatomic,strong) NSString *eval_id;
@end
