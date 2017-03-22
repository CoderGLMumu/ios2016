//
//  CommerChanceCellModel.h
//  JZBRelease
//
//  Created by zcl on 2016/10/8.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "GetValueObject.h"

@interface CommerChanceCellModel : GetValueObject

@property(nonatomic,copy) NSString *activity_id;
@property(nonatomic,copy) NSString *activity_title;
@property(nonatomic,copy) NSString *activity_type;
@property(nonatomic,copy) NSString *_type;
@property(nonatomic,copy) NSString *activity_desc;
@property(nonatomic,copy) NSString *activity_start_date;

@property(nonatomic,copy) NSString *activity_end_date;
@property(nonatomic,copy) NSString *max_count;
@property(nonatomic,copy) NSString *count;
@property(nonatomic,copy) NSString *activity_state;
@property(nonatomic,copy) NSString *evaluation_count;
@property(nonatomic,copy) NSString *zan_count;

@property(nonatomic,copy) NSString *reward_count;
@property(nonatomic,copy) NSString *share_count;
@property(nonatomic,copy) NSString *show_count;
@property(nonatomic,copy) NSString *c_id;
@property(nonatomic,copy) NSString *activity_score;
@property(nonatomic,copy) NSString *lng;

@property(nonatomic,copy) NSString *lat;
@property(nonatomic,copy) NSString *province;
@property(nonatomic,copy) NSString *city;
@property(nonatomic,copy) NSString *district;
@property(nonatomic,copy) NSString *community;
@property(nonatomic,copy) NSString *activity_address;

@property(nonatomic,copy) NSString *interests;
@property(nonatomic,copy) NSString *people;
@property(nonatomic,copy) NSString *reference;
@property(nonatomic,copy) NSString *activity_banner;
@property(nonatomic,strong) NSArray *images;
@property(nonatomic,strong) Users *user;

@end
