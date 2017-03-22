//
//  payAlipayItem.h
//  JZBRelease
//
//  Created by Apple on 16/10/29.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "payAlipayItemResult.h"
@interface payAlipayItem : NSObject

/** memo */
@property (nonatomic, strong) NSString *memo;
/** resultStatus */
@property (nonatomic, strong) NSString *resultStatus;
/** result */
@property (nonatomic, strong) payAlipayItemResult *result;

@end
