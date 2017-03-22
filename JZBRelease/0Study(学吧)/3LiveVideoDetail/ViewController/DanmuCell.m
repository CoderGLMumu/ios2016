//
//  DanmuCell.m
//  JZBRelease
//
//  Created by Apple on 16/12/2.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "DanmuCell.h"
#import "DanmuLabel.h"

@interface DanmuCell ()
@property (weak, nonatomic) IBOutlet UILabel *NameLabel;
@property (weak, nonatomic) IBOutlet DanmuLabel *contentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLLeftConst;

@end

@implementation DanmuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


}

- (void)setModel:(DanmuItem *)model
{
    _model = model;
    if (model.isfisrtLabel) {
        self.NameLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"53ffb9"];
        self.NameLabel.text = model.fisrtName;
        self.contentLabel.text = @"";
        
        self.contentLLeftConst.constant = 10;
        
    }else {
        self.NameLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"ff9800"];
        self.NameLabel.text = [NSString stringWithFormat:@"%@：",model.userName];
        self.contentLabel.text = [NSString stringWithFormat:@"%@",model.content_black];
        [self.NameLabel sizeToFit];
        self.contentLLeftConst.constant = 10 + self.NameLabel.glw_width;
//        GLLog(@"%f==%@",self.NameLabel.glw_width,self.NameLabel)
    }
    
    [self layoutIfNeeded];
    
}


@end
