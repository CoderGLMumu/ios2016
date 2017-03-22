//
//  UIButton+CustomBtn.m
//  HuiHaoLife
//
//  Created by 汉子科技 on 14/12/28.
//  Copyright (c) 2014年 汉子科技. All rights reserved.
//

#import "UIButton+CustomBtn.h"

@implementation UIButton (CustomBtn)
-(id)initWithFrame:(CGRect)frame andImageName:(NSString *)imageName andTitle:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 49)];
        imageView.center = self.center;
        }
    return self;
}

@end
