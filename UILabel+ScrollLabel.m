//
//  UILabel+ScrollLabel.m
//  test
//
//  Created by 汉子科技 on 15/4/28.
//  Copyright (c) 2015年 汉子科技. All rights reserved.
//

#import "UILabel+ScrollLabel.h"

@implementation UILabel (ScrollLabel)
+(UILabel *)scrollLabelWithFrame:(CGRect)LabelFrame andColor:(UIColor *)color andTitle:(NSString *)title
{
    UILabel * bgLabel = [[UILabel alloc] initWithFrame:LabelFrame];
    bgLabel.clipsToBounds = YES;
    UILabel * labelShow = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, LabelFrame.size.width, LabelFrame.size.height)];
    labelShow.font = [UIFont systemFontOfSize:15];
    labelShow.text= title;
    labelShow.textColor = color;
    //[labelShow sizeToFit];
    CGRect frame = labelShow.frame;
    frame.origin.x = labelShow.frame.size.width;
    labelShow.frame = frame;
    [UIView beginAnimations:@"testAnimation" context:NULL];
    [UIView setAnimationDuration:15.8f];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationRepeatAutoreverses:NO];
    [UIView setAnimationRepeatCount:999999];
    frame = labelShow.frame;
    frame.origin.x = -frame.size.width;
    labelShow.frame = frame;
    [UIView commitAnimations];
    [bgLabel addSubview:labelShow];
    return bgLabel;
}
@end
