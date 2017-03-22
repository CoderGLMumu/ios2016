//
//  XBMoreSelectModel.h
//  JZBRelease
//
//  Created by cl z on 16/10/13.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "GetValueObject.h"

@interface XBMoreSelectModel : GetValueObject
@property(nonatomic, copy) NSString *access_token;
@property(nonatomic, copy) NSString *tag;
@property(nonatomic, copy) NSString *page;
@property(nonatomic, copy) NSString *code_id;
@end
