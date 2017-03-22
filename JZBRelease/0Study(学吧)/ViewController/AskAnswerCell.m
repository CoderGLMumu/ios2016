//
//  AskAnswerCell.m
//  JZBRelease
//
//  Created by zjapple on 16/9/19.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "AskAnswerCell.h"
#import "InfoShowView.h"
#import "T_answerItem.h"
#import "Masonry.h"
#import "StringAddOrSub.h"

@interface AskAnswerCell ()

/** infoView */
@property (nonatomic, weak) InfoShowView *infoView;
@property (weak, nonatomic) IBOutlet UIButton *UpButton;

@property (weak, nonatomic) UILabel *contentLabel;

@property (weak, nonatomic) UILabel *timeLabel;
@property (weak, nonatomic) UILabel *answerLabel;

/** fengexian */
@property (nonatomic, weak) UIView *fengexian;

/** lastinfoView */
@property (nonatomic, weak) InfoShowView *lastinfoView;
/** lasttimeLabel */
@property (nonatomic, weak) UILabel *lasttimeLabel;
/** answerView */
@property (nonatomic, weak) UIView *answerView;

/** cell的点赞数量 */
@property (nonatomic, assign) NSInteger cellLike_count;

@end

@implementation AskAnswerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    InfoShowView *infoView = [InfoShowView getInfoShowViewWithData:nil WithFrame:CGRectMake(0, 0, self.glw_width, 64)];
    self.infoView = infoView;
    [self insertSubview:infoView aboveSubview:self.UpButton];
    [self addSubview:self.UpButton];
    
    UILabel *contentLabel = [UILabel new];
    contentLabel.numberOfLines = 0;
    [self addSubview:contentLabel];
    
    contentLabel.font = [UIFont systemFontOfSize:15];
    [contentLabel sizeToFit];
    contentLabel.frame = CGRectMake(68,infoView.glb_bottom , self.glw_width - 68 - 20, contentLabel.glh_height);
    contentLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"212112"];
    self.contentLabel = contentLabel;
    
    UILabel *timeLabel = [UILabel new];
    [self addSubview:timeLabel];
    
    timeLabel.font = [UIFont systemFontOfSize:11];
    timeLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"bdbdbd"];
    [timeLabel sizeToFit];
    timeLabel.frame = CGRectMake(68,contentLabel.glb_bottom , self.glw_width - 68 - 20, timeLabel.glh_height);
    self.timeLabel = timeLabel;
    
    UILabel *AnswerLabel = [UILabel new];
    [self addSubview:AnswerLabel];
    AnswerLabel.text = @"回答";
    AnswerLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"2198f2"];
    AnswerLabel.font = [UIFont systemFontOfSize:15];
    [AnswerLabel sizeToFit];
//    AnswerLabel.frame = CGRectMake(188,contentLabel.glb_bottom , self.glw_width - 68 - 20, timeLabel.glh_height);
    self.answerLabel = AnswerLabel;

}

- (void)setModel:(AskAnswerItem *)model
{
    _model = model;
    
    if (model.is_like.integerValue) {
        self.UpButton.selected = YES;
    }else {
        self.UpButton.selected = NO;
    }
    
    if (self.isTeacher) {
        self.answerLabel.hidden = NO;
    }else {
        self.answerLabel.hidden = YES;
    }
    
    [self.answerView removeFromSuperview];
    
    [self.infoView updateFrameWithData:model.user];
    
    self.infoView.botView.hidden = YES;
    
    self.cellLike_count = model.like_count.integerValue;
    
    [self.UpButton setTitle:[NSString stringWithFormat:@"(%ld)",(long)self.cellLike_count] forState:UIControlStateNormal];
    [self.UpButton setFont:[UIFont systemFontOfSize:11]];
    
    self.contentLabel.text = model.eval_content;
    [self.contentLabel sizeToFit];
    self.contentLabel.frame = CGRectMake(self.glw_width * 0.17,self.infoView.glb_bottom + 5 , self.glw_width - 68 - 20, self.contentLabel.glh_height);
    
    NSTimeInterval time= [model.create_time doubleValue];
    self.timeLabel.text = [[self dateFormatter] stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]];
    [self.timeLabel sizeToFit];
    self.timeLabel.frame = CGRectMake(self.glw_width * 0.17,self.contentLabel.glb_bottom + 20, self.glw_width - 68 - 20, self.timeLabel.glh_height);
    
    self.answerLabel.frame = CGRectMake(self.glw_width * 0.85,self.contentLabel.glb_bottom + 20, self.glw_width - 68 - 20, self.timeLabel.glh_height);

    [self.UpButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(25));
        make.right.equalTo(@(-20));
    }];
    
    if (model._answer.count) {
        
        UIView *answerView = [UIView new];
        [self addSubview:answerView];
        self.answerView = answerView;
        answerView.backgroundColor = [UIColor whiteColor];
        answerView.frame = CGRectMake(0, CGRectGetMaxY(self.timeLabel.frame) + 10, self.glw_width, 140.5 * model._answer.count);
        
        
        NSArray *T_answers = [T_answerItem mj_objectArrayWithKeyValuesArray:model._answer];
        
        for (int i = 0; i < model._answer.count; ++i) {
            
            /** 添加回复分割线 */
            
            UIView *fengexian = [UIView new];
            [answerView addSubview:fengexian];
            fengexian.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"bdbdbd"];
            if (self.fengexian) {
                fengexian.frame = CGRectMake(10, CGRectGetMaxY(self.lasttimeLabel.frame) + 10, self.glw_width - 10 * 2, 1);
            }else {
                fengexian.frame = CGRectMake(10, 0, self.glw_width - 10 * 2, 1);
            }
            
            self.fengexian = fengexian;
            
            /** 添加回复人信息 */
            InfoShowView *infoView = [InfoShowView getInfoShowViewWithData:nil WithFrame:CGRectMake(0, fengexian.gly_y + 10, self.glw_width, 64)];
            self.lastinfoView = infoView;
            T_answerItem *item = T_answers[i];
            
            [answerView addSubview:infoView];
            if (item.user) {
                [infoView updateFrameWithData:item.user];
            }
            
            infoView.botView.hidden = YES;
            
            /** 添加回复内容 */
            UILabel *contentLabel = [UILabel new];
            contentLabel.numberOfLines = 0;
            [answerView addSubview:contentLabel];
            
            contentLabel.text = item.eval_content;
            contentLabel.font = [UIFont systemFontOfSize:15];
            contentLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"212112"];
            [contentLabel sizeToFit];
            contentLabel.frame = CGRectMake(self.glw_width * 0.17,infoView.glb_bottom + 5 , self.glw_width - 68 - 20, contentLabel.glh_height);
            
//            if (i == 0) {
//                UILabel *contentLabel1 = [UILabel new];
//                contentLabel1.numberOfLines = 0;
//                [answerView addSubview:contentLabel1];
//                
//                contentLabel1.text = item.eval_content;
//                contentLabel1.font = [UIFont systemFontOfSize:20];
//                [contentLabel1 sizeToFit];
//                contentLabel1.frame = CGRectMake(0,0 , 130, 130);
//            }
            
            /** 添加回复时间 */
            
            UILabel *timeLabel = [UILabel new];
            [answerView addSubview:timeLabel];
            self.lasttimeLabel = timeLabel;
            
            NSTimeInterval time= [item.create_time doubleValue];
            timeLabel.text = [[self dateFormatter] stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]];

            timeLabel.font = [UIFont systemFontOfSize:11];
            timeLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"bdbdbd"];
            [timeLabel sizeToFit];
            timeLabel.frame = CGRectMake(self.glw_width * 0.17,contentLabel.glb_bottom + 20, self.glw_width - 68 - 20, self.timeLabel.glh_height);
//            self.timeLabel = timeLabel;
        }
    }
    
}

- (NSDateFormatter *)dateFormatter {
    static NSDateFormatter* dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YY年MM月dd日 hh:mm"];
    });
    return dateFormatter;
}

/** 点击了点赞的按钮 */
- (IBAction)ClickUpButton:(UIButton *)sender {
    
    NSDictionary *parameters = @{
                                 @"access_token":[LoginVM getInstance].readLocal.token,
                                 @"eval_id":self.model.eval_id
                                 };
    
    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/Study/answerLike"] parameters:parameters success:^(id json) {
    
    if ([json[@"state"] isEqual:@(0)]) {
        [SVProgressHUD showInfoWithStatus:json[@"info"]];
    }else {
        
//        if (self.clickUpButton) {
//            self.clickUpButton();
//        }
        
        if (self.model.is_like.integerValue) {
            self.model.is_like = @(0);
            sender.selected = NO;
        }else {
            self.model.is_like = @(1);
            sender.selected = YES;
        }

        if (self.model.is_like.integerValue) {
            self.model.like_count = [StringAddOrSub addStringWithNum:self.cellLike_count];
            [self.UpButton setTitle:[NSString stringWithFormat:@"(%@)",self.model.like_count] forState:UIControlStateNormal];
            
            self.cellLike_count++;
            
            [SVProgressHUD showSuccessWithStatus:@"成功点赞"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
        }else {
            self.model.like_count = [StringAddOrSub SubStringWithNum:self.cellLike_count];
            [self.UpButton setTitle:[NSString stringWithFormat:@"(%@)",self.model.like_count] forState:UIControlStateNormal];
            
            self.cellLike_count--;
            
            [SVProgressHUD showSuccessWithStatus:@"取消点赞"];
//            [SVProgressHUD showSuccessWithStatus:@"成功点赞"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
        }
        
    }
    
    } failure:^(NSError *error) {
        
    }];
    
}


- (void)setFrame:(CGRect)frame  //【后调用】
{
    //在返回cell高度的情况下给cell高度减一,tableView得到消息后高度减一
    frame.size.height -= 11;
    // 给cellframe赋值
    [super setFrame:frame];
}





@end
