//
//  UIImage+Scale.h
//  HuiHaoLife
//
//  Created by 汉子科技 on 15/1/23.
//  Copyright (c) 2015年 汉子科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Scale)
//压缩图片
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;
@end
