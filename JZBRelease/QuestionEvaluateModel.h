//
//  QuestionEvaluateModel.h
//  JZBRelease
//
//  Created by cl z on 16/7/25.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "EvaluateModel.h"

@interface QuestionEvaluateModel : EvaluateModel


@property(nonatomic,strong) NSString *p_id;
@property(nonatomic,strong) NSString *top_id;
@property(nonatomic,strong) NSString *question_id;
@property(nonatomic,strong) NSString *status;

@property(nonatomic,strong) NSString *is_new;
@property(nonatomic,strong) NSString *is_like;
@property(nonatomic,strong) NSNumber *is_reward;
@property(nonatomic,strong) NSNumber *is_comment;
@property(nonatomic,strong) NSNumber *like_count;
@property(nonatomic,strong) NSNumber *comment_count;
@property(nonatomic,strong) NSNumber *reward_count;
@end
