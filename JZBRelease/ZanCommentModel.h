//
//  ZanCommentModel.h
//  JZBRelease
//
//  Created by cl z on 16/9/17.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "GetValueObject.h"

@interface ZanCommentModel : GetValueObject

@property(nonatomic,strong) NSString *access_token;
@property(nonatomic,strong) NSString *eval_id;

@end
