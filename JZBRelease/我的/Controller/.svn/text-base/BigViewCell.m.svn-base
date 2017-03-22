//
//  BigViewCell.m
//  JZBRelease
//
//  Created by cl z on 16/12/8.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "BigViewCell.h"

@implementation BigViewCell{
    UIView *intevalView;
}


- (void)setModel:(CourseTimeModel *)model{
    if (!self.bigView) {
        self.bigView = [XBBigView initWithModel:model WithFrame:CGRectMake(0, 5, GLScreenW, 159 + 39)];
        self.bigView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.bigView];
    }
    if (!intevalView) {
        intevalView = [[UIView alloc]initWithFrame:CGRectMake(0, 159 + 39 + 5, GLScreenW, 10)];
        [intevalView setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"f2f2f2"]];
        [self.contentView addSubview:intevalView];
    }
    [self.bigView updateWithModel:model];
}


@end
