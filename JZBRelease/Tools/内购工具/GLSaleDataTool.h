//
//  GLSaleDataTool.h
//  JZBRelease
//
//  Created by Apple on 16/11/17.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Goods_JZBVip.h"

@interface GLSaleDataTool : NSObject

// 获取商品列表
+ (void)getGoods_JZBVip:(void(^)(NSArray *goods))result;

// 成功购买建众会员
+ (void)uploadJZBVip;

// 获取购买帮币列表
+ (void)getGoods_ShopBB:(void(^)(NSArray *goods))result;

@end
