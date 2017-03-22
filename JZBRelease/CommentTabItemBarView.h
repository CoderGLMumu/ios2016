//
//  CommentTabItemBarView.h
//  JZBRelease
//
//  Created by cl z on 16/9/8.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionEvaluateModel.h"
@interface CommentTabItemBarView : UIView

@property(nonatomic, assign) BOOL isQustionOwner,isBQDetail;
@property(nonatomic, strong) UIImageView *zanImageView;
@property(nonatomic, strong) UILabel *zanCountLabel;
@property(nonatomic, strong) UIButton *zanCountBtn;

@property(nonatomic, strong) UIImageView *rewardImageView;
@property(nonatomic, strong) UILabel *rewardCountLabel;
@property(nonatomic, strong) UIButton *rewardCountBtn;

@property(nonatomic, strong) UIImageView *commentImageView;
@property(nonatomic, strong) UILabel *commentCountLabel;
@property(nonatomic, strong) UIButton *commentCountBtn;

@property(nonatomic, strong) UIButton *cainaBtn;

@property(nonatomic, copy) void (^returnAction)(NSInteger tag);

+ (CommentTabItemBarView *) getCommentTabItemBarViewWithFrame:(CGRect) frame IsQuestionOwner:(BOOL) isQustionOwner;

- (void)updateViews:(QuestionEvaluateModel *) model;

@end
