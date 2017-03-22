//
//  RMRootCell.m
//  JZBRelease
//
//  Created by zjapple on 16/8/24.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "RMRootCell.h"
#import "DealNormalUtil.h"

@interface RMRootCell ()
@property (weak, nonatomic) IBOutlet UIImageView *RMimageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *chenWeiLabel;
@property (weak, nonatomic) IBOutlet UIImageView *vipImageView;
@property (weak, nonatomic) IBOutlet UILabel *painLabel;
@property (strong, nonatomic) UILabel *painLeftLabel;

@property (weak, nonatomic) IBOutlet UILabel *painNameLabel;

/** isZLT */
@property (nonatomic, assign) BOOL isZLT;

@end

@implementation RMRootCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

- (void)setModel:(BQRMDataItem *)model
{
    _model = model;
    
    self.userNameLabel.text = model.nickname;
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@ %@",model.company,model.job];
    
//    [self.RMimageView sd_setImageWithURL:[NSURL URLWithString:[AddHostToLoadPIC AddHostToLoadPICWithString:model.avatar]] placeholderImage:[UIImage imageNamed:@"ZCCG_TX"]];
    
    [LocalDataRW getImageWithDirectory:Directory_WD RetalivePath:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:model.avatar] WithContainerImageView:self.RMimageView];
    
    self.chenWeiLabel.text = model.type_name;
//    self.painLabel.text = model.pain;
    
    [self.vipImageView setImage:[[DealNormalUtil getInstance]getImageBasedOnName:model.level]];
    
//    self.RMimageView.image = [UIImage imageNamed:model.testImage];
    
    if ([model.type isEqualToString:@"2"]) {
        self.isZLT = YES;
    }
    
    GLLog(@"%d",self.isZLT)
    
    self.painLeftLabel = [UILabel new];
    
    if (self.isZLT) {
        self.painLeftLabel.text = @"擅长领域：";
    }else{
        self.painLeftLabel.text = @"经营痛点：";
    }
    
    /** 设置行距 */
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",self.painLeftLabel.text,model.pain]];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:6];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [model.pain length] + [self.painLeftLabel.text length])];
    [self.painNameLabel setAttributedText:attributedString1];
    
    /** ********* */

    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    [self layoutIfNeeded];
//    [self.RMimageView sizeToFit];
    
    self.RMimageView.layer.cornerRadius = GLScreenW *70/375 * 0.5;
    self.RMimageView.clipsToBounds = YES;
}

@end
