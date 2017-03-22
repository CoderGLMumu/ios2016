//
//  GetCourseTimeListModel.h
//  JZBRelease
//
//  Created by cl z on 16/9/14.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "GetValueObject.h"

@interface GetCourseTimeListModel : GetValueObject
@property(nonatomic,copy)NSString *access_token;
@property(nonatomic,copy)NSString *course_id;
@property(nonatomic,copy)NSString *type;
@property(nonatomic,copy)NSString *id;
@property(nonatomic,copy)NSString *page;
@property(nonatomic,copy)NSString *tag;
@property(nonatomic,copy)NSString *my;
@property(nonatomic,copy)NSString *keyword;
@property(nonatomic,copy)NSString *user_id;
@property(nonatomic,copy)NSString *limit;
@property(nonatomic,copy)NSString *t;
@property(nonatomic,copy)NSString *position;
@end
