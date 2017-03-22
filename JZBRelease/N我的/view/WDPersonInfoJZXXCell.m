//
//  WDPersonInfoJZXXCell.m
//  JZBRelease
//
//  Created by zjapple on 16/9/5.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "WDPersonInfoJZXXCell.h"

@interface WDPersonInfoJZXXCell ()

@property (weak, nonatomic) IBOutlet UILabel *PtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@end

@implementation WDPersonInfoJZXXCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(JZXXItem *)model
{
    _model = model;
    self.PtitleLabel.text = model.title;
    self.valueLabel.text = model.value;
}

@end
