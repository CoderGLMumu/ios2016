//
//  CourseTimeModel.h
//  JZBRelease
//
//  Created by cl z on 16/9/14.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "GetValueObject.h"
#import "ThemeListModel.h"
#import "ObjectTypeModel.h"
#import "MechanismModel.h"

@interface CourseTimeModel : GetValueObject

@property(nonatomic,strong)NSString *id;
@property(nonatomic,strong)NSString *course_id;
@property(nonatomic,strong)NSString *type;
@property(nonatomic,strong)NSString *tag;
@property(nonatomic,strong)NSString *ground;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSString *score;
@property(nonatomic,strong)NSString *join_count;
@property(nonatomic,strong)NSString *share_count;
@property(nonatomic,strong)NSString *evaluation_count;
@property(nonatomic,strong)NSString *online_count;
@property(nonatomic,strong)NSString *zan_count;
@property(nonatomic,strong)NSString *reward_count;
@property(nonatomic,strong)NSString *show_count;
@property(nonatomic,strong)NSString *status;
@property(nonatomic,strong)NSString *thumb;
@property(nonatomic,strong)NSString *thumb2;
@property(nonatomic,strong)NSString *push_path;
@property(nonatomic,strong)NSString *play_path;
@property(nonatomic,strong)NSString *start_time;
@property(nonatomic,strong)NSString *end_time;
@property(nonatomic,strong)NSString *label;
@property(nonatomic,strong)NSArray *join_list;
@property(nonatomic,strong)NSString *is_pay;
@property(nonatomic,strong)NSString *is_zan;
@property(nonatomic,strong)NSString *is_mechanism;
@property(nonatomic,strong)Users *teacher;
@property(nonatomic,strong)ThemeListModel *theme;
@property(nonatomic,strong)ObjectTypeModel *objects;
@property(nonatomic,strong)MechanismModel *mechanism;


@property(nonatomic,strong)NSString *province;
@property(nonatomic,strong)NSString *city;
@property(nonatomic,strong)NSString *district;
@property(nonatomic,strong)NSString *address;
@property(nonatomic,strong)NSString *community;

/** zan_count */


//"province":"海南省",
//"city":"三亚市",
//"district":"河西区",
//"community":"",
//"address":"解放路与新风街的十字交叉路口"

/** question */
@property (nonatomic, strong) NSArray *question;

@end
