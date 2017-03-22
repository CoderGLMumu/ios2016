//
//  GLSaleDataTool.m
//  JZBRelease
//
//  Created by Apple on 16/11/17.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "GLSaleDataTool.h"

@implementation GLSaleDataTool

+ (void)getGoods_JZBVip:(void(^)(NSArray *goods))result;
{
    
    Goods_JZBVip *good1 = [[Goods_JZBVip alloc] init];
    good1.name = @"建众帮会员";
    good1.goodID = @"com.jzb.release0";
    
    result(@[good1]);
    
    //    XMGGood *good2 = [[XMGGood alloc] init];
    //    good2.name = @"手榴弹";
    //    good2.goodID = @"com.520it.dashen.shoujidan";
    
    //    result(@[good1, good2]);
    
}

+ (void)getGoods_ShopBB:(void(^)(NSArray *goods))result;
{
    
    Goods_JZBVip *good1 = [[Goods_JZBVip alloc] init];
    good1.name = @"1帮币 = 1元";
    good1.goodID = @"com.jzb.releaseB1";
    
    Goods_JZBVip *good2 = [[Goods_JZBVip alloc] init];
    good2.name = @"5帮币 = 5元";
    good2.goodID = @"com.jzb.releaseB5";
    
    Goods_JZBVip *good3 = [[Goods_JZBVip alloc] init];
    good3.name = @"10帮币 = 10元";
    good3.goodID = @"com.jzb.releaseB10";
    
    Goods_JZBVip *good4 = [[Goods_JZBVip alloc] init];
    good4.name = @"100帮币 = 100元";
    good4.goodID = @"com.jzb.releaseB100";
    
    Goods_JZBVip *good5 = [[Goods_JZBVip alloc] init];
    good5.name = @"500帮币 = 500元";
    good5.goodID = @"com.jzb.releaseB500";
    
    Goods_JZBVip *good6 = [[Goods_JZBVip alloc] init];
    good6.name = @"1000帮币 = 1000元";
    good6.goodID = @"com.jzb.releaseB1000";
    
    result(@[good1,good2,good3,good4,good5,good6]);
    
    //    XMGGood *good2 = [[XMGGood alloc] init];
    //    good2.name = @"手榴弹";
    //    good2.goodID = @"com.520it.dashen.shoujidan";
    
    //    result(@[good1, good2]);
    
}

+ (void)uploadJZBVip
{

}

@end
