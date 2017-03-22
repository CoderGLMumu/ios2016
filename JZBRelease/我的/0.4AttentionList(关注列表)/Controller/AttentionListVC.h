//
//  AttentionListVC.h
//  JZBRelease
//
//  Created by zjapple on 16/10/17.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttentionListVC : UIViewController
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) Users *user;

/** isSecVCPush */
@property (nonatomic, assign) BOOL isSecVCPush;

@end
