//
//  AddFansModel.h
//  JZBRelease
//
//  Created by cl z on 16/8/19.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "GetValueObject.h"

@interface AddFansModel : GetValueObject
@property(nonatomic,copy) NSString *access_token;
@property(nonatomic,copy) NSString *user_id;
@end
