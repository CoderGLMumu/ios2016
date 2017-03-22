//
//  SendSerialsModel.h
//  JZBRelease
//
//  Created by cl z on 16/9/13.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "GetValueObject.h"

@interface SendSerialsModel : GetValueObject

@property(nonatomic,copy)NSString *access_token;
@property(nonatomic,copy)NSString *type;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *thumb;
@property(nonatomic,copy)NSString *industry_id;
@property(nonatomic,copy)NSString *tag;
@property(nonatomic,copy)NSString *content;

@end
