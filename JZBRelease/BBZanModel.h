//
//  BBZanModel.h
//  JZBRelease
//
//  Created by cl z on 16/7/26.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "GetValueObject.h"

@interface BBZanModel : GetValueObject
@property(nonatomic,copy) NSString *access_token;
@property(nonatomic,copy) NSString *eval_id;
@end
