//
//  CommentTabItemBarView.m
//  JZBRelease
//
//  Created by cl z on 16/9/8.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "CommentTabItemBarView.h"
#import "StatusModel.h"
#import "EvaluateModel.h"

@implementation CommentTabItemBarView{
    UIView *intevalView;
    int height;
}

+ (CommentTabItemBarView *) getCommentTabItemBarViewWithFrame:(CGRect) frame IsQuestionOwner:(BOOL) isQustionOwner{
    CommentTabItemBarView *view = [[CommentTabItemBarView alloc]initWithFrame:frame];
    view.isQustionOwner = isQustionOwner;
    return view;
}

- (void)updateViews:(QuestionEvaluateModel *) model{
    if (0 == height) {
        height = model.inteval * 7.333;
    }
    if (!self.isBQDetail) {
        if (self.isQustionOwner) {
            int width = self.frame.size.width / 4;
            if (!self.zanImageView) {
                self.zanCountBtn  = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, width, height)];
                self.zanImageView = [[UIImageView alloc]initWithFrame:CGRectMake(width / 2 - 15 - 5, (height - 15) / 2, 15, 15)];
                [self.zanImageView setImage:[UIImage imageNamed:@"WDXQ_Thumb_up"]];
                [self.zanCountBtn addSubview:self.zanImageView];
                
                self.zanCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(width / 2 + 5, (height - 21) / 2, width / 2 - 5, 21)];
                [self.zanCountLabel setFont:[UIFont systemFontOfSize:12]];
                [self.zanCountLabel setTextColor:[UIColor hx_colorWithHexRGBAString:@"757575"]];
                [self.zanCountBtn addSubview:self.zanCountLabel];
                [self addSubview:self.zanCountBtn];
                UIImageView *intevalImageView = [[UIImageView alloc]initWithFrame:CGRectMake(width - 1, (height - 13) / 2, 1, 13)];
                [intevalImageView setImage:[UIImage imageNamed:@"WDXQ_vertical_bar"]];
                [self.zanCountBtn addSubview:intevalImageView];
            }
            if (!model.like_count || [model.like_count integerValue] <0) {
                model.like_count = [NSNumber numberWithInteger:0];
            }
            [self.zanCountLabel setText:[NSString stringWithFormat:@"%@",model.like_count]];
            
            if ([((EvaluateModel *)model).is_like integerValue] == 1) {
                [self.zanImageView setImage:[UIImage imageNamed:@"WDXQ_YDZ"]];
            }else{
                [self.zanImageView setImage:[UIImage imageNamed:@"WDXQ_DZ"]];
                
            }
            
            if (!self.rewardImageView) {
                self.rewardCountBtn  = [[UIButton alloc]initWithFrame:CGRectMake(width, 0, width, height)];
                self.rewardImageView = [[UIImageView alloc]initWithFrame:CGRectMake(width / 2 - 18 - 5, (height - 18) / 2, 18, 18)];
                AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                
               // if (appDelegate.checkpay) {
                    [self.rewardImageView setImage:[UIImage imageNamed:@"WD_DS"]];
                    
              //  }else{
               //     [self.rewardImageView setImage:[UIImage imageNamed:@"BB_eye"]];
               // }
                
                [self.rewardCountBtn addSubview:self.rewardImageView];
                
                self.rewardCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(width / 2 + 5, (height - 21) / 2, width / 2 - 5, 21)];
                [self.rewardCountLabel setFont:[UIFont systemFontOfSize:12]];
                [self.rewardCountLabel setTextColor:[UIColor hx_colorWithHexRGBAString:@"757575"]];
                [self.rewardCountBtn addSubview:self.rewardCountLabel];
                [self addSubview:self.rewardCountBtn];
                UIImageView *intevalImageView = [[UIImageView alloc]initWithFrame:CGRectMake(width - 1, (height - 13) / 2, 1, 13)];
                [intevalImageView setImage:[UIImage imageNamed:@"WDXQ_vertical_bar"]];
                [self.rewardCountBtn addSubview:intevalImageView];
            }
            if (!model.reward_count || [model.reward_count integerValue] <0) {
                model.reward_count = [NSNumber numberWithInteger:0];
            }
            [self.rewardCountLabel setText:[NSString stringWithFormat:@"%@",model.reward_count]];
            
            if (!self.commentImageView) {
                self.commentCountBtn  = [[UIButton alloc]initWithFrame:CGRectMake(width * 2, 0, width, height)];
                self.commentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(width / 2 - 15 - 5, (height - 15) / 2, 15, 15)];
                [self.commentImageView setImage:[UIImage imageNamed:@"WDXQ_comments"]];
                [self.commentCountBtn addSubview:self.commentImageView];
                
                self.commentCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(width / 2 + 5, (height - 21) / 2, width / 2 - 5, 21)];
                [self.commentCountLabel setFont:[UIFont systemFontOfSize:12]];
                [self.commentCountLabel setTextColor:[UIColor hx_colorWithHexRGBAString:@"757575"]];
                [self.commentCountBtn addSubview:self.commentCountLabel];
                [self addSubview:self.commentCountBtn];
                UIImageView *intevalImageView = [[UIImageView alloc]initWithFrame:CGRectMake(width - 1, (height - 13) / 2, 1, 13)];
                [intevalImageView setImage:[UIImage imageNamed:@"WDXQ_vertical_bar"]];
                [self.commentCountBtn addSubview:intevalImageView];
            }
            NSInteger count;
            if (!model._child || model._child.count  <= 0) {
                count = 0;
            }else{
                count = model._child.count;
            }
            [self.commentCountLabel setText:[NSString stringWithFormat:@"%ld",count]];
            
            if (!self.cainaBtn) {
                self.cainaBtn = [[UIButton alloc]initWithFrame:CGRectMake(3 * width, 0, width, height)];
                [self addSubview:self.cainaBtn];
                UIImageView *caiImageView = [[UIImageView alloc]initWithFrame:CGRectMake(width / 2 - 15 - 5, (height - 15) / 2, 15, 15)];
                [caiImageView setImage:[UIImage imageNamed:@"WDXQ_CN"]];
                [self.cainaBtn addSubview:caiImageView];
                
                UILabel *caiLabel = [[UILabel alloc]initWithFrame:CGRectMake(width / 2 + 5, (height - 21) / 2, width / 2 - 5, 21)];
                [caiLabel setFont:[UIFont systemFontOfSize:12]];
                [caiLabel setText:@"采纳"];
                [caiLabel setTextColor:[UIColor hx_colorWithHexRGBAString:@"757575"]];
                [self.cainaBtn addSubview:caiLabel];
            }
        }else{
            int width = self.frame.size.width / 3;
            if (!self.zanImageView) {
                self.zanCountBtn  = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, width, height)];
                self.zanImageView = [[UIImageView alloc]initWithFrame:CGRectMake(width / 2 - 15 - 5, (height - 15) / 2, 15, 15)];
                [self.zanImageView setImage:[UIImage imageNamed:@"WDXQ_Thumb_up"]];
                [self.zanCountBtn addSubview:self.zanImageView];
                
                self.zanCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(width / 2 + 5, (height - 21) / 2, width / 2 - 5, 21)];
                [self.zanCountLabel setFont:[UIFont systemFontOfSize:12]];
                [self.zanCountLabel setTextColor:[UIColor hx_colorWithHexRGBAString:@"757575"]];
                [self.zanCountBtn addSubview:self.zanCountLabel];
                [self addSubview:self.zanCountBtn];
                UIImageView *intevalImageView = [[UIImageView alloc]initWithFrame:CGRectMake(width - 1, (height - 13) / 2, 1, 13)];
                [intevalImageView setImage:[UIImage imageNamed:@"WDXQ_vertical_bar"]];
                [self.zanCountBtn addSubview:intevalImageView];
            }
            
            if ([model isKindOfClass:[QuestionEvaluateModel class]]) {
                if (!model.like_count || [model.like_count integerValue] <0) {
                    model.like_count = [NSNumber numberWithInteger:0];
                }
                [self.zanCountLabel setText:[NSString stringWithFormat:@"%@",model.like_count]];
            }else if ([model isKindOfClass:[StatusModel class]]){
                if (!((StatusModel *)model).zan_count || [((StatusModel *)model).zan_count integerValue] < 0) {
                    ((StatusModel *)model).zan_count = [NSNumber numberWithInteger:0];
                }
                [self.zanCountLabel setText:[NSString stringWithFormat:@"%@",((StatusModel *)model).zan_count]];
            }
            
            if ([((EvaluateModel *)model).is_like integerValue] == 1) {
                [self.zanImageView setImage:[UIImage imageNamed:@"WDXQ_YDZ"]];
            }else{
                [self.zanImageView setImage:[UIImage imageNamed:@"WDXQ_DZ"]];
                
            }
            
            if (!self.rewardImageView) {
                self.rewardCountBtn  = [[UIButton alloc]initWithFrame:CGRectMake(width, 0, width, height)];
                self.rewardImageView = [[UIImageView alloc]initWithFrame:CGRectMake(width / 2 - 18 - 5, (height - 18) / 2, 18, 18)];
                AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                
               // if (appDelegate.checkpay) {
                    [self.rewardImageView setImage:[UIImage imageNamed:@"WD_DS"]];
                    
                //}else{
               //     [self.rewardImageView setImage:[UIImage imageNamed:@"BB_eye"]];
                //}
                [self.rewardCountBtn addSubview:self.rewardImageView];
                
                self.rewardCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(width / 2 + 5, (height - 21) / 2, width / 2 - 5, 21)];
                [self.rewardCountLabel setFont:[UIFont systemFontOfSize:12]];
                [self.rewardCountLabel setTextColor:[UIColor hx_colorWithHexRGBAString:@"757575"]];
                [self.rewardCountBtn addSubview:self.rewardCountLabel];
                [self addSubview:self.rewardCountBtn];
                UIImageView *intevalImageView = [[UIImageView alloc]initWithFrame:CGRectMake(width - 1, (height - 13) / 2, 1, 13)];
                [intevalImageView setImage:[UIImage imageNamed:@"WDXQ_vertical_bar"]];
                [self.rewardCountBtn addSubview:intevalImageView];
            }
            if (!model.reward_count || [model.reward_count integerValue] <0) {
                model.reward_count = [NSNumber numberWithInteger:0];
            }
            [self.rewardCountLabel setText:[NSString stringWithFormat:@"%@",model.reward_count]];
            
            if (!self.commentImageView) {
                self.commentCountBtn  = [[UIButton alloc]initWithFrame:CGRectMake(width * 2, 0, width, height)];
                self.commentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(width / 2 - 15 - 5, (height - 15) / 2, 15, 15)];
                [self.commentImageView setImage:[UIImage imageNamed:@"WDXQ_comments"]];
                [self.commentCountBtn addSubview:self.commentImageView];
                
                self.commentCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(width / 2 + 5, (height - 21) / 2, width / 2 - 5, 21)];
                [self.commentCountLabel setFont:[UIFont systemFontOfSize:12]];
                [self.commentCountLabel setTextColor:[UIColor hx_colorWithHexRGBAString:@"757575"]];
                [self.commentCountBtn addSubview:self.commentCountLabel];
                [self addSubview:self.commentCountBtn];
                //            UIImageView *intevalImageView = [[UIImageView alloc]initWithFrame:CGRectMake(width - 1, (height - 13) / 2, 1, 13)];
                //            [intevalImageView setImage:[UIImage imageNamed:@"WDXQ_vertical_bar"]];
                //            [self.commentCountBtn addSubview:intevalImageView];
            }
            if ([model isKindOfClass:[QuestionEvaluateModel class]]) {
                NSInteger count;
                if (!model._child || model._child.count  <= 0) {
                    count = 0;
                }else{
                    count = model._child.count;
                }
                [self.commentCountLabel setText:[NSString stringWithFormat:@"%ld",count]];
            }else if ([model isKindOfClass:[StatusModel class]]){
                if (!((StatusModel *)model).evaluation_count || [((StatusModel *)model).evaluation_count integerValue] < 0) {
                    ((StatusModel *)model).evaluation_count = [NSNumber numberWithInteger:0];
                }
                [self.commentCountLabel setText:[NSString stringWithFormat:@"%@",((StatusModel *)model).evaluation_count]];
            }
            
        }
    }else{
        int width = self.frame.size.width / 2;
        if (!self.zanImageView) {
            self.zanCountBtn  = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, width, height)];
            self.zanImageView = [[UIImageView alloc]initWithFrame:CGRectMake(width / 2 - 15 - 5, (height - 15) / 2, 15, 15)];
            [self.zanImageView setImage:[UIImage imageNamed:@"WDXQ_YDZ"]];
            [self.zanCountBtn addSubview:self.zanImageView];
            
            self.zanCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(width / 2 + 5, (height - 21) / 2, width / 2 - 5, 21)];
            [self.zanCountLabel setFont:[UIFont systemFontOfSize:12]];
            [self.zanCountLabel setTextColor:[UIColor hx_colorWithHexRGBAString:@"757575"]];
            [self.zanCountBtn addSubview:self.zanCountLabel];
            [self addSubview:self.zanCountBtn];
            UIImageView *intevalImageView = [[UIImageView alloc]initWithFrame:CGRectMake(width - 1, (height - 13) / 2, 1, 13)];
            [intevalImageView setImage:[UIImage imageNamed:@"WDXQ_vertical_bar"]];
            [self.zanCountBtn addSubview:intevalImageView];
        }
        
        
        if (!((EvaluateModel *)model).zan_count || [((EvaluateModel *)model).zan_count integerValue] < 0) {
            if (!((EvaluateModel *)model).like_count || [((EvaluateModel *)model).like_count integerValue] < 0) {
                ((EvaluateModel *)model).zan_count = [NSNumber numberWithInteger:0];
                
                [self.zanCountLabel setText:[NSString stringWithFormat:@"%@",((EvaluateModel *)model).zan_count]];
            }else{
                [self.zanCountLabel setText:[NSString stringWithFormat:@"%@",((EvaluateModel *)model).like_count]];
            }
            
        }else{
            [self.zanCountLabel setText:[NSString stringWithFormat:@"%@",((EvaluateModel *)model).zan_count]];
        }
        if ([((EvaluateModel *)model).is_like integerValue] == 1) {
            [self.zanImageView setImage:[UIImage imageNamed:@"WDXQ_YDZ"]];
        }else{
            [self.zanImageView setImage:[UIImage imageNamed:@"WDXQ_DZ"]];
            
        }
 

        
        if (!self.commentImageView) {
            self.commentCountBtn  = [[UIButton alloc]initWithFrame:CGRectMake(width, 0, width, height)];
            self.commentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(width / 2 - 15 - 5, (height - 15) / 2, 15, 15)];
            [self.commentImageView setImage:[UIImage imageNamed:@"WDXQ_comments"]];
            [self.commentCountBtn addSubview:self.commentImageView];
            
            self.commentCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(width / 2 + 5, (height - 21) / 2, width / 2 - 5, 21)];
            [self.commentCountLabel setFont:[UIFont systemFontOfSize:12]];
            [self.commentCountLabel setTextColor:[UIColor hx_colorWithHexRGBAString:@"757575"]];
            [self.commentCountBtn addSubview:self.commentCountLabel];
            [self addSubview:self.commentCountBtn];
        }
        
        NSInteger count;
        if (!model._child || model._child.count  <= 0) {
            count = 0;
        }else{
            count = model._child.count;
        }
        [self.commentCountLabel setText:[NSString stringWithFormat:@"%ld",count]];
       
    }
    
    if (!intevalView) {
        intevalView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GLScreenW, 0.8)];
        [intevalView setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"f2f2f2"]];
        [self addSubview:intevalView];
    }
    
    [self.zanCountBtn addTarget:self action:@selector(zanBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.rewardCountBtn addTarget:self action:@selector(rewardBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.commentCountBtn addTarget:self action:@selector(commentBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.cainaBtn addTarget:self action:@selector(cainaBtnAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)zanBtnAction{
    NSLog(@"hit");
    if (self.returnAction) {
        self.returnAction(0);
    }

}

- (void)rewardBtnAction{
    if (self.returnAction) {
        self.returnAction(1);
    }
}

- (void)commentBtnAction{
    if (self.returnAction) {
        self.returnAction(2);
    }
}

- (void)cainaBtnAction{
    if (self.returnAction) {
        self.returnAction(3);
    }

}


@end
