//
//  ZBYGModel.h
//  JZBRelease
//
//  Created by cl z on 16/10/12.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "GetValueObject.h"

@interface ZBYGModel : GetValueObject
@property(nonatomic,copy)NSString *title;

@property(nonatomic,strong)NSArray *zbyg_list;

@property(nonatomic,copy)NSString *tag;
@end
