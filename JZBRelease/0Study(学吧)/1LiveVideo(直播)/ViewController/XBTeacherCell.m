//
//  XBTeacherCell.m
//  JZBRelease
//
//  Created by cl z on 16/10/14.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "XBTeacherCell.h"

@implementation XBTeacherCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUser:(Users *)user{
    if (!_infoShowView) {
        _infoShowView = [InfoShowView getInfoShowViewWithData:user WithFrame:CGRectMake(0, 20, GLScreenW, 64)];
        _infoShowView.intevalViewHidden = YES;
        [self.contentView addSubview:_infoShowView];
        UIView *inteval = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GLScreenW, 12)];
        inteval.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"f2f2f2"];
        UIView *top = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GLScreenW, 0.8)];
        [top setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"e2e2e2"]];
        [inteval addSubview:top];
        UIView *bottom = [[UIView alloc]initWithFrame:CGRectMake(0, 11.2, GLScreenW, 0.8)];
        [bottom setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"e2e2e2"]];
        [inteval addSubview:bottom];
        [self.contentView addSubview:inteval];

    }
    [_infoShowView updateFrameWithData:user];
}


@end
