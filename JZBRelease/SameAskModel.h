//
//  SameAskModel.h
//  JZBRelease
//
//  Created by cl z on 16/8/4.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "GetValueObject.h"

@interface SameAskModel : GetValueObject

@property(nonatomic,copy) NSString *access_token;
@property(nonatomic,copy) NSString *question_id;

@end
