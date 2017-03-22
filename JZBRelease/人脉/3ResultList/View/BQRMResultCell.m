//
//  BQRMResultCell.m
//  JZBRelease
//
//  Created by zjapple on 16/8/30.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "BQRMResultCell.h"
#import "DealNormalUtil.h"
#import "InfoShowView.h"

@interface BQRMResultCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *company_jobLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nickNameLabelWidthConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *company_jobLabelWidthConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vipLeadToChenWeiLabelTrailConstraints;

@property (weak, nonatomic) IBOutlet UILabel *ZLTInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *industry_idLabel;
@property (weak, nonatomic) IBOutlet UIImageView *vipRangeView;

/** infoView */
@property (nonatomic, weak) InfoShowView *infoView;

@end

@implementation BQRMResultCell

+ (instancetype)BQRMResultCell
{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]firstObject];
}

- (void)setModel:(BQRMDataItem *)model
{
    _model = model;

//    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:model.avatar]] placeholderImage:[UIImage imageNamed:@"ZCCG_TX"]];
    
    [LocalDataRW getImageWithDirectory:Directory_RM RetalivePath:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:model.avatar] WithContainerImageView:self.avatarImageView];
    
    self.nickNameLabel.text = model.nickname;
    self.company_jobLabel.text = [NSString stringWithFormat:@"%@%@",model.company,model.job];
    self.industry_idLabel.text = model.type_name;
    [self.vipRangeView setImage:[[DealNormalUtil getInstance]getImageBasedOnName:model.level]];
    
    if (model.company.length >=8) {
        model.company = [NSString stringWithFormat:@"%@...",[model.company substringToIndex:8]];
    }
    
    [self.infoView updateFrameWithData:model];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self setupSubView];
    
    [self hiddenALLXIB];
}

- (void)hiddenALLXIB
{
    self.avatarImageView.hidden = YES;
    self.nickNameLabel.hidden = YES;
    self.company_jobLabel.hidden = YES;
    self.ZLTInfoLabel.hidden = YES;
    self.industry_idLabel.hidden = YES;
    self.vipRangeView.hidden = YES;
    
    InfoShowView *infoView = [InfoShowView getInfoShowViewWithData:nil WithFrame:CGRectMake(0, 0, self.glw_width, self.glh_height)];
    self.infoView = infoView;
    [self addSubview:infoView];
    
}

- (void)setupSubView
{
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.glw_width * 0.5;
    self.avatarImageView.clipsToBounds = YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.nickNameLabel sizeToFit];
    [self.company_jobLabel sizeToFit];
    
    self.nickNameLabelWidthConstraints.constant = self.nickNameLabel.glw_width;
    if (self.nickNameLabel.glw_width + self.company_jobLabel.glw_width < 188) {
        self.company_jobLabelWidthConstraints.constant = self.company_jobLabel.glw_width;
    }else {
        self.company_jobLabelWidthConstraints.constant = 142;
        self.vipLeadToChenWeiLabelTrailConstraints.constant = -7;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
