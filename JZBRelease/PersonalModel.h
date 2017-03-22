//
//  PersonalModel.h
//  JZBRelease
//
//  Created by zjapple on 16/7/15.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "GetValueObject.h"
#import "StatusModel.h"

@interface PersonalModel : GetValueObject

@property(nonatomic, strong) NSString *nickname,*sex,
*userid,
*avatar,*mobile,
*birthday,
*signature,
*address,
*company,
*score,
*frozen_score,*level,
*email,
*job,
*industry,
*fans_count,
*show_count,*topic_count,*gang;
@property(nonatomic, strong) NSArray *dynamic_list;


@end
