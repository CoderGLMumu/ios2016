//
//  ZanModel.h
//  JZBRelease
//
//  Created by zjapple on 16/6/28.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "GetValueObject.h"

@interface ZanModel : GetValueObject

@property(nonatomic,strong) NSString *access_token;
@property(nonatomic,strong) NSString *dynamic_id;

@end
