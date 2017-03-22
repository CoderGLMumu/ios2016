//
//  CEGeneralTool.m
//  JZBRelease
//
//  Created by zjapple on 16/8/23.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "GLGeneralTool.h"

@implementation GLGeneralTool

+ (void)animationOfTextField:(UITextField *)textField isUp:(BOOL)up withDistance:(NSInteger)distance inView:(UIView *)view {
    
    //  设置视图实际上移距离
    NSInteger moveDistance = (up ?  -distance : distance );
    
    [UIView beginAnimations:@"Animation" context:nil];
    
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    [UIView setAnimationDuration:0.20];
    
    view.frame = CGRectOffset(view.frame, 0, moveDistance);
    
    [UIView commitAnimations];
}

@end
