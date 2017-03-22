//
//  payAlipayItemResult.h
//  JZBRelease
//
//  Created by Apple on 16/10/29.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface payAlipayItemResult : NSObject

/** code */
@property (nonatomic, strong) NSString *code;
/** msg */
@property (nonatomic, strong) NSString *msg;
/** total_amount */
@property (nonatomic, strong) NSString *total_amount;
/** app_id */
@property (nonatomic, strong) NSString *app_id;
/** trade_no */
@property (nonatomic, strong) NSString *trade_no;
/** seller_id */
@property (nonatomic, strong) NSString *seller_id;
/** out_trade_no */
@property (nonatomic, strong) NSString *out_trade_no;

@end
