//
//  GetActivityListModel.h
//  JZBRelease
//
//  Created by zjapple on 16/6/21.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "GetValueObject.h"

@interface GetActivityListModel : GetValueObject

@property(nonatomic,strong) NSString *access_token;
@property(nonatomic,strong) NSString *id;
@property(nonatomic,strong) NSString *pid;
@property(nonatomic,strong) NSString *my;
@property(nonatomic,strong) NSString *industry_id;
@property(nonatomic,strong) NSString *keyword;
@property(nonatomic,strong) NSString *user_id;

@end
