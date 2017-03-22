//
//  PersonalPresentVC.h
//  JZBRelease
//
//  Created by zjapple on 16/5/24.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Users.h"
@interface PersonalPresentVC : UIViewController
@property (nonatomic, strong) Users *user;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL fromDynamicDetailVC;

@end
