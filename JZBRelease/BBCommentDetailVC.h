//
//  BBCommentDetailVC.h
//  JZBRelease
//
//  Created by cl z on 16/7/26.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionEvaluateModel.h"
#import "Defaults.h"
#import "QuestionsModel.h"
@interface BBCommentDetailVC : UIViewController<UITableViewDelegate,UITableViewDataSource,TableViewCellDelegate>

@property (nonatomic, strong) NSIndexPath *indexPath,*indexPath2;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, assign) NSInteger row;
@property(nonatomic, strong) QuestionsModel *questionModel;
@property(nonatomic, strong) QuestionEvaluateModel *evaluateModel;
@property(nonatomic, copy) void (^ updateData)(QuestionsModel *questionsModel,BOOL isDelete);

/** IsFromGLNavPush */
@property (nonatomic, assign) BOOL IsFromGLNavPush;

@end
