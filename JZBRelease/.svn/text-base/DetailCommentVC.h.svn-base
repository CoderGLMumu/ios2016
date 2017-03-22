//
//  DetailCommentVC.h
//  JZBRelease
//
//  Created by zjapple on 16/5/14.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewCellDelegate.h"
#import "EvaluateModel.h"
@interface DetailCommentVC : UIViewController<UITableViewDelegate,UITableViewDataSource,TableViewCellDelegate>

@property (nonatomic, strong) NSIndexPath *indexPath,*indexPath2;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) EvaluateModel *evaluateModel;
@property(nonatomic, copy) void (^ updateData)(NSInteger row);

@end
