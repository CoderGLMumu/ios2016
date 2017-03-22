//
//  DynamicDetailVC.h
//  JZBRelease
//
//  Created by zjapple on 16/5/9.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defaults.h"
#import "CellLayout.h"
#import "StatusModel.h"
#import "DetailCommentVC.h"
#import "EvaluateModel.h"
@interface DynamicDetailVC : UIViewController<UITableViewDelegate,UITableViewDataSource,TableViewCellDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *keyboardContainerView;

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) NSInteger which;
@property (nonatomic, assign) BOOL pushFromMessageListVC,updateDetailComment,pushFromPersonalVC;
@property (nonatomic, strong) StatusModel *statusModel;

@property(nonatomic, copy) void (^returnAction)();
@end
