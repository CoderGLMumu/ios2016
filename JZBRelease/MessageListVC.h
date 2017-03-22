//
//  MessageListVC.h
//  JZBRelease
//
//  Created by zjapple on 16/6/30.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MESSAGE_NAME @"MESSAGE_NAME"

@interface MessageListVC : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataAry;

@property(nonatomic, copy) void (^returnAction)();

@end
