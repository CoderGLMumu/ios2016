//
//  RankingCell.m
//  JZBRelease
//
//  Created by zjapple on 16/9/23.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "RankingCell.h"

#import "InfoShowView.h"

@interface RankingCell ()

/** infoView */
@property (nonatomic, weak) InfoShowView *infoView;
@property (weak, nonatomic) IBOutlet UIImageView *topNumImageView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelToptoIconConstraintH;

@end

@implementation RankingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    InfoShowView *infoView = [InfoShowView getInfoShowViewWithData:nil WithFrame:CGRectMake(0, 0, self.glw_width, self.glh_height)];
    self.infoView = infoView;
    
    [self addSubview:infoView];
    
    self.infoView.glcy_centerY = 44;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
}

- (void)setModel:(rankItem *)model
{
    _model = model;
    self.infoView.botView.hidden = YES;
    self.labelToptoIconConstraintH.constant = 4;
    if ([self.topNum isEqualToString:@"0"]) {
        self.topNumImageView.hidden = NO;
        self.topNumImageView.image = [UIImage imageNamed:@"PHB_No1"];
    }else if([self.topNum isEqualToString:@"1"]) {
        self.topNumImageView.hidden = NO;
        self.topNumImageView.image = [UIImage imageNamed:@"PHB_No2"];
    }else if([self.topNum isEqualToString:@"2"]) {
        self.topNumImageView.hidden = NO;
        self.topNumImageView.image = [UIImage imageNamed:@"PHB_No3"];
    }else {
        self.topNumImageView.hidden = YES;
        self.labelToptoIconConstraintH.constant = -15;
    }
    
    self.scoreLabel.text = [NSString stringWithFormat:@"帮币：%@",model.score];
    
//    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[AddHostToLoadPIC AddHostToLoadPICWithString:model.avatar]] placeholderImage:[UIImage imageNamed:@"ZCCG_TX"]];
//    
//    self.nickNameLabel.text = model.nickname;
//    self.company_jobLabel.text = [NSString stringWithFormat:@"%@%@",model.company,model.job];
//    self.industry_idLabel.text = model.type_name;
//    [self.vipRangeView setImage:[[DealNormalUtil getInstance]getImageBasedOnName:model.level]];
    
    [self.infoView updateFrameWithData:model.user];
}

- (void)setFrame:(CGRect)frame  //【后调用】
{
    frame.size.height -= 9;
    // 给cellframe赋值
    [super setFrame:frame];
}

@end
