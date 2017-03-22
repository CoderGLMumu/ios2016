//
//  BBActivityVC.h
//  JZBRelease
//
//  Created by zjapple on 16/7/8.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBActivityVC : UIViewController

@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, assign) BOOL fromPersonal;

@property (nonatomic,strong) Users *user;

@end
