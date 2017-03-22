//
//  RMRootCell2.m
//  JZBRelease
//
//  Created by zjapple on 16/8/24.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "RMRootCell2.h"
#import "DealNormalUtil.h"

@interface RMRootCell2 ()
@property (weak, nonatomic) IBOutlet UIImageView *RMimageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *chenWeiLabel;
@property (weak, nonatomic) IBOutlet UIImageView *vipImageView;
@property (weak, nonatomic) IBOutlet UILabel *painLabel;

@property (weak, nonatomic) IBOutlet UILabel *painNameLabel;

@property (strong, nonatomic) UILabel *painLeftLabel;

/** isZLT */
@property (nonatomic, assign) BOOL isZLT;

@end

@implementation RMRootCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(BQRMDataItem *)model
{
    _model = model;
    
    self.userNameLabel.text = model.nickname;
    
//    self.titleLabel.text = model.company;
    self.titleLabel.text = [NSString stringWithFormat:@"%@ %@",model.company,model.job];
    
//    [self.RMimageView sd_setImageWithURL:[NSURL URLWithString:[AddHostToLoadPIC AddHostToLoadPICWithString:model.avatar]] placeholderImage:[UIImage imageNamed:@"ZCCG_TX"]];
    
    [LocalDataRW getImageWithDirectory:Directory_RM RetalivePath:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:model.avatar] WithContainerImageView:self.RMimageView];
    
    
    self.chenWeiLabel.text = model.type_name;
    
//    self.painLabel.text = model.pain;
    
//    /** 设置行距 */
//    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:model.pain];
//    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle1 setLineSpacing:6];
//    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [model.pain length])];
//    [self.painLabel setAttributedText:attributedString1];
//    
//    /** ********* */
    
    [self.vipImageView setImage:[[DealNormalUtil getInstance]getImageBasedOnName:model.level]];
    
    if ([model.type isEqualToString:@"2"]) {
        self.isZLT = YES;
    }
    
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
    
//    self.userNameLabel.text = model.username;
//    
//    self.titleLabel.text = model.title;
//    
//    self.RMimageView.image = [UIImage imageNamed:model.testImage];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.RMimageView.layer.cornerRadius = GLScreenW *70/375 * 0.5;

    self.RMimageView.clipsToBounds = YES;
}


@end
