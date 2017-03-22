//
//  MechanismModel.h
//  JZBRelease
//
//  Created by cl z on 16/10/15.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "GetValueObject.h"

@interface MechanismModel : GetValueObject
@property(nonatomic,copy)NSString *id;

@property(nonatomic,copy)NSString *uid;

@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *thumb;

@property(nonatomic,copy)NSString *content;
@end
