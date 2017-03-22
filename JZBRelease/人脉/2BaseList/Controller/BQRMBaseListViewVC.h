//
//  BQRMJXSVC.h
//  JZBRelease
//
//  Created by zjapple on 16/8/25.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BQRMBaseListViewVC : UIViewController

/** title数据源 */
@property (nonatomic, strong) NSArray *titles;

/** 列表类型 */
@property (nonatomic, strong) NSString *tid;
/** 二级列表类型 */
@property (nonatomic, strong) NSString *aid;
/** tag */
@property (nonatomic, strong) NSString *tag;

/** json */
@property (nonatomic, strong) NSArray *dataSource;
///** 行业列表数据源 */
//@property (nonatomic, strong) NSMutableArray *titleDataSource;

/** JXSarea数据源 */
@property (nonatomic, strong) NSArray *JXSareaDataSource;
/** JXSindustry数据源 */
@property (nonatomic, strong) NSArray *JXSindustryDataSource;
/** JXSbrand数据源 */
@property (nonatomic, strong) NSArray *JXSbrandDataSource;
/** PPCSarea数据源 */
@property (nonatomic, strong) NSArray *PPCSareaSource;
/** PPCSindustry数据源 */
@property (nonatomic, strong) NSArray *PPCSindustryDataSource;
/** ZLT数据源 */
@property (nonatomic, strong) NSArray *ZLTDataSource;
/** ZLTjz_expertDataSource数据源 */
@property (nonatomic, strong) NSArray *ZLTjz_expertDataSource;
/** ZLTother_expertDataSource数据源 */
@property (nonatomic, strong) NSArray *ZLTother_expertDataSource;

/** 经销商帮NextDict */
@property (nonatomic, strong) NSDictionary *JXSDict;
/** 智囊团NextDict */
@property (nonatomic, strong) NSDictionary *ZLTDict;
/** 品牌帮NextDict */
@property (nonatomic, strong) NSDictionary *PPCSDict;


@end
