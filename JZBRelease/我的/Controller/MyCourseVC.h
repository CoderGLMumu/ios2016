//
//  MyCourseVC.h
//  JZBRelease
//
//  Created by cl z on 16/9/12.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCourseVC : UIViewController<UITableViewDelegate,UITableViewDataSource>

/** isOther */
@property (nonatomic, assign) BOOL isOther;

@property (strong, nonatomic) Users *user;

@property (assign, nonatomic) BOOL fromXBAndIsTeacher;

@property (strong, nonatomic) UITableView *tableView;

@end
