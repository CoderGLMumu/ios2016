//
//  GetQuestionsModel.h
//  JZBRelease
//
//  Created by zjapple on 16/7/13.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "GetValueObject.h"

@interface GetQuestionsModel : GetValueObject

@property(nonatomic,strong) NSString *access_token;
@property(nonatomic,strong) NSString *id;
@property(nonatomic,strong) NSString *page;
@property(nonatomic,strong) NSString *my;
@property(nonatomic,strong) NSString *tag;
@property(nonatomic,strong) NSString *industry_id;
@property(nonatomic,strong) NSString *keyword;
@property(nonatomic,strong) NSString *user_id;
@property(nonatomic,strong) NSString *position;
@end
