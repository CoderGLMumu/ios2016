//
//  GLButton.m
//  test
//
//  Created by zjapple on 16/8/18.
//  Copyright © 2016年 12345. All rights reserved.
//

#import "GLRMButton.h"
#import "UIView+GLExtension.h"

@implementation GLRMButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:14];
//        [self setTitleColor:[UIColor hx_colorWithHexRGBAString:@"ffffff"] forState:UIControlStateNormal];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    if (self.titleLabel.glx_x > self.imageView.glx_x) {
        
        self.titleLabel.glx_x = self.imageView.glx_x;
        self.imageView.glx_x = CGRectGetMaxX(self.titleLabel.frame) + 5;
    }
}

-(void)setTitle:(NSString *)title forState:(UIControlState)state{
    
    [super setTitle:title forState:state];
    
    [self sizeToFit];
}

@end
