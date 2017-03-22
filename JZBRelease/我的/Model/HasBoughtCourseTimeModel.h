//
//  HasBoughtCourseTimeModel.h
//  JZBRelease
//
//  Created by cl z on 16/9/21.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "GetValueObject.h"

@interface HasBoughtCourseTimeModel : GetValueObject
@property(nonatomic,copy)NSString *access_token;
@property(nonatomic,copy)NSString *user_id;
@property(nonatomic,copy)NSString *page;
@end
