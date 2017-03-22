//
//  registerBaseListCell.m
//  JZBRelease
//
//  Created by zjapple on 16/8/26.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "registerBaseListCell.h"

@interface registerBaseListCell ()

@property (weak, nonatomic) IBOutlet UILabel *registerTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *checkImageView;

@end

@implementation registerBaseListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setItem:(NSString *)item
{
    _item = item;
    self.registerTitleLabel.text = item;
}

- (void)setModel:(registerBaseListModel *)model
{
    _model = model;
    
    self.registerTitleLabel.text = model.titleName;
    
    // 根据模型的checked属性决定打钩显示还是隐藏
    if (model.isChecked) {
        self.checkImageView.hidden = NO;
    } else {
        self.checkImageView.hidden = YES;
    }
    
}

@end
