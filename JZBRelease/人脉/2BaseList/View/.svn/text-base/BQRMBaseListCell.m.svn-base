//
//  BQRMJSXCell.m
//  JZBRelease
//
//  Created by zjapple on 16/8/25.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "BQRMBaseListCell.h"
#import "BQRMDataItem.h"

@interface BQRMBaseListCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation BQRMBaseListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRMtitle:(NSString *)RMtitle
{
    _RMtitle = RMtitle;
    self.titleLabel.text = RMtitle;
    
    self.titleLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"757575"];
    
    self.titleLabel.font = [UIFont systemFontOfSize:14];
}

- (void)setModel:(id)model
{
    _model = model;
    
//    BQRMDataItem *newModel = (BQRMDataItem *)model;
    
}

@end
