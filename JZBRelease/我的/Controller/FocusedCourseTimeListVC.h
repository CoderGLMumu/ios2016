//
//  FocusedCourseTimeListVC.h
//  JZBRelease
//
//  Created by cl z on 16/9/23.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FocusedCourseTimeListVC : UIViewController
@property (strong, nonatomic) UITableView *tableView;

@property (nonatomic ,assign )BOOL isOther;
/** user */
@property (nonatomic, strong) Users *user;

@end
