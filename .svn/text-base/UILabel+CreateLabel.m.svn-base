//
//  UILabel+CreateLabel.m
//  HuiHaoLife
//
//  Created by 汉子科技 on 15/1/8.
//  Copyright (c) 2015年 汉子科技. All rights reserved.
//

#import "UILabel+CreateLabel.h"

@implementation UILabel (CreateLabel)
+(UILabel*)createLabelWithFrame:(CGRect)frame Font:(int)font Text:(NSString*)text andLCR:(int)i;
{
    UILabel*label=[[UILabel alloc]initWithFrame:frame];
    //限制行数
    label.numberOfLines=0;
    //对齐方式
    if (i == 0) {
        label.textAlignment=NSTextAlignmentLeft;
    }else if (i == 1){
       label.textAlignment=NSTextAlignmentCenter;
    }else if (i == 2){
       label.textAlignment=NSTextAlignmentRight;
    }
    label.backgroundColor=[UIColor clearColor];
    label.font=[UIFont systemFontOfSize:font];
    //单词折行
    label.lineBreakMode=NSLineBreakByWordWrapping;
    //默认字体颜色是黑色
    label.textColor=[UIColor blackColor];
    //自适应（行数~字体大小按照设置大小进行设置）
    label.adjustsFontSizeToFitWidth=YES;
    label.text=text;
    return label;
}

+ (UILabel*)createLabelWithFrame:(CGRect)frame Font:(int)font Text:(NSString*)text andLCR:(int)i andColor:(UIColor *)color;
{
    UILabel*label=[[UILabel alloc]initWithFrame:frame];
    
//    if ([text isEqualToString:HomeTitle]) { // 首页测试标题
//        NSMutableAttributedString *muStr = [[NSMutableAttributedString alloc] initWithString:text];
//        [muStr addAttribute:NSForegroundColorAttributeName value:KWhiteColor range:NSMakeRange(0,muStr.length - 4)];
//        [muStr addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(muStr.length - 4,4)];
//        [muStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:20] range:NSMakeRange(0, muStr.length)];
//        label.attributedText = muStr;
//    } else {
        //限制行数
        label.numberOfLines=0;
        //对齐方式
        if (i == 0) {
            label.textAlignment=NSTextAlignmentLeft;
        }else if (i == 1){
            label.textAlignment=NSTextAlignmentCenter;
        }else if (i == 2){
            label.textAlignment=NSTextAlignmentRight;
        }
        label.backgroundColor=[UIColor clearColor];
        label.font=[UIFont systemFontOfSize:font];
        //单词折行
        label.lineBreakMode=NSLineBreakByWordWrapping;
        //默认字体颜色是白色
        label.textColor=color;
        //自适应（行数~字体大小按照设置大小进行设置）
        label.adjustsFontSizeToFitWidth=YES;
        label.text=text;
//    }

    return label;
}

+(MyUILabel*)createMyLabelWithFrame:(CGRect)frame Font:(int)font Text:(NSString*)text andLCR:(int)i andColor:(UIColor *)color
{

    MyUILabel*label=[[MyUILabel alloc]initWithFrame:frame];
    //限制行数
    label.numberOfLines=0;
    //对齐方式
    if (i == 0) {
        label.textAlignment=NSTextAlignmentLeft;
    }else if (i == 1){
        label.textAlignment=NSTextAlignmentCenter;
    }else if (i == 2){
        label.textAlignment=NSTextAlignmentRight;
    }
    label.backgroundColor=[UIColor clearColor];
    label.font=[UIFont systemFontOfSize:font];
    //单词折行
    label.lineBreakMode=NSLineBreakByWordWrapping;
    //默认字体颜色是白色
    label.textColor=color;
    //自适应（行数~字体大小按照设置大小进行设置）
    label.adjustsFontSizeToFitWidth=YES;
    label.text=text;
    return label;
}

@end
