//
//  registerJobsVC.h
//  JZBRelease
//
//  Created by zjapple on 16/9/28.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface registerJobsVC : UITableViewController

/** 数据源 */
@property (nonatomic, strong) NSArray *dataSource;

/** cell被点击的消息 */
@property (nonatomic, strong) void(^cellClick)(NSString *str);

@end
