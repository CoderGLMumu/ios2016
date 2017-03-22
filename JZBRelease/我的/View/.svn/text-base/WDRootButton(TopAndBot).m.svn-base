//
//  WDRootButton(TopAndBot).m
//  JZBRelease
//
//  Created by cl z on 16/10/7.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "WDRootButton(TopAndBot).h"

@implementation WDRootButton_TopAndBot_

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        [self setTitleColor:[UIColor hx_colorWithHexRGBAString:@"212121"] forState:UIControlStateNormal];
    }
    
    return self;
}

/** 图上字下 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    self.imageView.contentMode = UIViewContentModeCenter;
    
//    self.imageView.gly_y = 13;
    self.imageView.gly_y = self.glh_height * 0.19;
    self.imageView.glcx_centerX = self.glw_width * 0.5;
    self.imageView.glw_width = self.glw_width * 0.36;
    self.imageView.glh_height = self.glw_width * 0.36;

//    self.imageView.glw_width = self.glw_width * 0.3;
//    self.imageView.glh_height = self.glw_width * 0.3;
    
    self.titleLabel.glw_width = self.glw_width;
    self.titleLabel.gly_y = CGRectGetMaxY(self.imageView.frame) + 12;
    self.titleLabel.glx_x = 0;
//    self.titleLabel.glh_height = self.glh_height - self.titleLabel.gly_y;
    
    self.imageView.glcx_centerX = self.glw_width * 0.5;
    self.titleLabel.glcx_centerX = self.glw_width * 0.5;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
//    self.imageView.image = [self reSizeImage:self.imageView.image toSize:CGSizeMake(20, 20)];
}

- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize

{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reSizeImage;
    
}


@end
