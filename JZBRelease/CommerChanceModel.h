//
//  CommerChanceModel.h
//  JZBRelease
//
//  Created by zcl on 2016/10/8.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "GetValueObject.h"

@interface CommerChanceModel : GetValueObject
@property(nonatomic,copy) NSString *access_token;
@property(nonatomic,copy) NSString *id;
@property(nonatomic,copy) NSString *page;
@property(nonatomic,copy) NSString *my;
@property(nonatomic,copy) NSString *industry_id;
@property(nonatomic,copy) NSString *activity_type;
@property(nonatomic,copy) NSString *keyword;
@property(nonatomic,copy) NSString *user_id;

@end
