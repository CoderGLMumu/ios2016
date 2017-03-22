//
//  UIImage+Scale.m
//  HuiHaoLife
//
//  Created by 汉子科技 on 15/1/23.
//  Copyright (c) 2015年 汉子科技. All rights reserved.
//

#import "UIImage+Scale.h"

@implementation UIImage (Scale)
//压缩图片
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}
@end
