//
//  GetInfomationModel.h
//  JZBRelease
//
//  Created by cl z on 16/11/25.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "GetValueObject.h"

@interface GetInfomationModel : GetValueObject

@property(nonatomic,copy)NSString *access_token;

@property(nonatomic,copy)NSString *cate;

@property(nonatomic,copy)NSString *page;

@end
