//
//  Toast.m
//  沟通宝
//
//  Created by zcl on 14-8-5.
//  Copyright (c) 2014年 zcl. All rights reserved.
//

#import "Toast.h"
int TOAST_HEIGHT = 31;
int fontSize = 16;
@implementation Toast

+(void)makeShowCommen : (NSString *) commenContent ShowHighlight : (NSString *) hightContent HowLong : (float) howLong{
    if (!commenContent || !hightContent) {
        return;
    }
    int width = [UIScreen mainScreen].bounds.size.width;
    int heigh = [UIScreen mainScreen].bounds.size.height;
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    NSDictionary *sizeAttrs = @{NSFontAttributeName:font};
    
    CGSize labelSize1 = [commenContent sizeWithAttributes:sizeAttrs];
    CGSize labelSize2 = [hightContent sizeWithAttributes:sizeAttrs];
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, labelSize1.width, 20)];
    [label1 setFont:font];
    [label1 setText:commenContent];
    [label1 setTextColor:[UIColor darkGrayColor]];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(10 + labelSize1.width, 5, labelSize2.width, 20)];
    [label2 setFont:font];
    [label2 setText:hightContent];
    [label2 setTextColor:[UIColor redColor]];
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake((width - (20 + labelSize1.width + labelSize2.width)) / 2, heigh * 3 / 5, 20 + labelSize1.width + labelSize2.width, 30)];
    [view1 setBackgroundColor:[UIColor whiteColor]];
    view1.layer.cornerRadius = 3.0;
    view1.layer.shadowOffset = CGSizeMake(5, 5);
    view1.layer.shadowColor = [UIColor blackColor].CGColor;
    view1.layer.shadowOpacity = 0.5;
    view1.layer.shadowRadius = 3.0;
    [view1 addSubview:label1];
    [view1 addSubview:label2];
    [[UIApplication sharedApplication].keyWindow addSubview: view1];
    [UIView animateWithDuration:howLong animations:^{
        view1.center = [UIApplication sharedApplication].keyWindow.center;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 animations:^{
            view1.alpha = 0;
        } completion:^(BOOL finished) {
            [view1 removeFromSuperview];
        }];
    }];
}


@end
