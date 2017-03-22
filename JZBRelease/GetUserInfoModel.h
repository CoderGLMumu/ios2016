//
//  GetUserInfoModel.h
//  JZBRelease
//
//  Created by zjapple on 16/7/13.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "GetValueObject.h"

@interface GetUserInfoModel : GetValueObject

@property(nonatomic,strong) NSString *access_token;
@property(nonatomic,strong) NSString *uid;

@end
