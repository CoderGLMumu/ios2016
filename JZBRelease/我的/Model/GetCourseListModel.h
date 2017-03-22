//
//  GetCourseListModel.h
//  JZBRelease
//
//  Created by cl z on 16/9/14.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "GetValueObject.h"

@interface GetCourseListModel : GetValueObject

@property(nonatomic,copy)NSString *access_token;
@property(nonatomic,copy)NSString *id;
@property(nonatomic,copy)NSString *pid;
@property(nonatomic,copy)NSString *page;
@property(nonatomic,copy)NSString *type;
@property(nonatomic,copy)NSString *my,*t,*limit;
@property(nonatomic,copy)NSString *industry_id;
@property(nonatomic,copy)NSString *keyword;
@property(nonatomic,copy)NSString *user_id;
@property(nonatomic,copy)NSString *position;


@end
