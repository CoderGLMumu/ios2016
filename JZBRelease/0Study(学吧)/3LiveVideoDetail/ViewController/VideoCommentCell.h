//
//  VideoCommentCell.h
//  JZBRelease
//
//  Created by cl z on 16/12/1.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseTimeEvaluateModel.h"
@interface VideoCommentCell : UITableViewCell
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *contentLabel;

@property(nonatomic, strong) UILabel *companyPositionLabel;
@property(nonatomic, strong) UILabel *jobPositionLabel;
@property(nonatomic, strong) UIImageView *vipRangeView;

@property(nonatomic, strong) UILabel *dateLabel;

@property(nonatomic, strong) UIButton *zanBtn;
@property(nonatomic, strong) UIImageView *zanImageView;
@property(nonatomic, strong) UILabel *zanCountLabel;

@property (nonatomic, strong) CourseTimeEvaluateModel *model;
@end
