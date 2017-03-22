//
//  IndustryModel.h
//  JZBRelease
//
//  Created by cl z on 16/8/1.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "GetValueObject.h"

@interface IndustryModel : GetValueObject
@property(nonatomic,copy) NSString *id;
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *pid;
@property(nonatomic,copy) NSString *sort;
@property(nonatomic,copy) NSString *title;
//@property(nonatomic,copy) NSString *description;
@property(nonatomic,copy) NSString *icon;
@property(nonatomic,copy) NSString *status;
@end
