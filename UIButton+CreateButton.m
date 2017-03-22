//
//  UIButton+CreateButton.m
//  HuiHaoLife
//
//  Created by 汉子科技 on 15/1/8.
//  Copyright (c) 2015年 汉子科技. All rights reserved.
//

#import "UIButton+CreateButton.h"

@implementation UIButton (CreateButton)
+(UIButton*)createButtonWithFrame:(CGRect)frame ImageName:(NSString*)imageName Target:(id)target Action:(SEL)action Title:(NSString*)title
{
    UIButton*button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=frame;
    [button setTitle:title forState:UIControlStateNormal];
    //设置背景图片，可以使文字与图片共存
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    //图片与文字如果需要同时存在，就需要图片足够小 详见人人项目按钮设置
    // [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}
+(UIButton*)createButtonWithFrame:(CGRect)frame ImageName:(NSString*)imageName Target:(id)target Action:(SEL)action Title:(NSString*)title cornerRadius:(CGFloat)radius borderColor:(UIColor *)color borderWidth:(CGFloat)width
{
    UIButton * button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    //设置背景图片，可以使文字与图片共存
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    //图片与文字如果需要同时存在，就需要图片足够小 详见人人项目按钮设置
    // [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius =radius;
    button.layer.borderColor = color.CGColor;
    button.layer.borderWidth = width;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+(UIButton*)createButtonWithFrame:(CGRect)frame Image:(UIImage*)image Target:(id)target Action:(SEL)action Title:(NSString*)title cornerRadius:(CGFloat)radius borderColor:(UIColor *)color borderWidth:(CGFloat)width
{
    UIButton * button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    //设置背景图片，可以使文字与图片共存
    [button setBackgroundImage:image forState:UIControlStateNormal];
    //图片与文字如果需要同时存在，就需要图片足够小 详见人人项目按钮设置
    // [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius =radius;
    button.layer.borderColor = color.CGColor;
    button.layer.borderWidth = width;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}


+(UIButton*)createButtonWithFrame:(CGRect)frame ImageName:(NSString*)imageName selectImage:(NSString *)selectImageName Target:(id)target Action:(SEL)action Title:(NSString*)title cornerRadius:(CGFloat)radius borderColor:(UIColor *)color borderWidth:(CGFloat)width
{
    UIButton*button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=frame;
    [button setTitle:title forState:UIControlStateNormal];
    //设置背景图片，可以使文字与图片共存
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:selectImageName] forState:UIControlStateSelected];
    //图片与文字如果需要同时存在，就需要图片足够小 详见人人项目按钮设置
    // [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius =radius;
    button.layer.borderColor = color.CGColor;
    button.layer.borderWidth = width;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+(UIButton*)createButtonWithFrame:(CGRect)frame FImageName:(NSString*)imageName Target:(id)target Action:(SEL)action Title:(NSString*)title
{
    UIButton*button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=frame;
    [button setTitle:title forState:UIControlStateNormal];
    //设置背景图片，可以使文字与图片共存
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    //图片与文字如果需要同时存在，就需要图片足够小 详见人人项目按钮设置
    // [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

@end
