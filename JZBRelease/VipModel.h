//
//  VipModel.h
//  JZBRelease
//
//  Created by cl z on 16/10/14.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "GetValueObject.h"

@interface VipModel : GetValueObject
@property (nonatomic, strong)NSString *id,*uid,*create_time,*end_time,*status;
@end
