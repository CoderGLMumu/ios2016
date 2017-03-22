//
//  CourseModel.h
//  JZBRelease
//
//  Created by cl z on 16/9/14.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "GetValueObject.h"

@interface CourseModel : GetValueObject

@property(nonatomic,strong)NSString *id;
@property(nonatomic,strong)NSString *uid;
@property(nonatomic,strong)NSString *type;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *thumb;
@property(nonatomic,strong)NSString *industry_id;
@property(nonatomic,strong)NSString *industry;
@property(nonatomic,strong)NSString *zan_count;
@property(nonatomic,strong)NSString *join_count;
@property(nonatomic,strong)NSString *share_count;
@property(nonatomic,strong)NSString *evaluation_count;
@property(nonatomic,strong)NSString *class_count;
@property(nonatomic,strong)NSString *show_count;
@property(nonatomic,strong)Users *user;

@end
