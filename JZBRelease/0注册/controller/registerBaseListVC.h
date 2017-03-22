//
//  registerBaseListVC.h
//  JZBRelease
//
//  Created by zjapple on 16/8/26.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, VCType) {
    VCTypeJXS = 1 << 0, //1
    VCTypeZLT = 1 << 1,
    VCTypePPCS = 1 << 2,
};

@interface registerBaseListVC : UITableViewController

/** 数据源 */
@property (nonatomic, strong) NSArray *dataSource;

/** type */
@property (nonatomic, assign) NSUInteger VCtype;

/** cell被点击的消息 */
@property (nonatomic, strong) void(^cellClick)(NSDictionary *uid_title);

@end
