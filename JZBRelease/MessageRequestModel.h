//
//  MessageRequestModel.h
//  JZBRelease
//
//  Created by zjapple on 16/7/1.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "GetValueObject.h"

@interface MessageRequestModel : GetValueObject

@property(nonatomic, strong) NSString *access_token,*type;

@end
