//
//  BQRMButton.m
//  JZBRelease
//
//  Created by zjapple on 16/8/24.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "BQRMButton.h"

@implementation BQRMButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        [self setTitleColor:[UIColor hx_colorWithHexRGBAString:@"212121"] forState:UIControlStateNormal];
    }
    return self;
}

/** 人脉模块头部的按钮  上图 下字 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.gly_y = 0;
    
    self.imageView.glw_width = 55;
    self.imageView.glh_height = 55;
    
    self.titleLabel.glw_width = self.imageView.glw_width;
    self.titleLabel.gly_y = CGRectGetMaxY(self.imageView.frame) + 14;
    
    self.titleLabel.glh_height = self.glh_height - self.titleLabel.gly_y;
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    if (self.direction == 4) {
        self.imageView.glr_right = self.glw_width;
        
    }else if (self.direction == 3) {
        self.imageView.glcx_centerX = self.glw_width * 0.55;
        
    }else if (self.direction == 2) {
         self.imageView.glcx_centerX = self.glw_width * 0.45;
        
    }else if (self.direction == 1) {
        self.imageView.glx_x = 0;
        
    }
    
    self.titleLabel.glcx_centerX = self.imageView.glcx_centerX;
}

@end
