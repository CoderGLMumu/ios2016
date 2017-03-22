//
//  popContactUsView.m
//  JZBRelease
//
//  Created by Apple on 16/11/8.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "popContactUsView.h"

@implementation popContactUsView

+ (instancetype)sharePopContactUsView
{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]firstObject];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.contentView.layer.cornerRadius = 10;
    self.contentView.clipsToBounds = YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    
}

@end
