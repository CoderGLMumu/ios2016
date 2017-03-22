//
//  GLWhiteSearchView.m
//  JZBRelease
//
//  Created by zjapple on 16/8/17.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "GLWhiteSearchView.h"

@implementation GLWhiteSearchView

+ (instancetype)glWhiteSearchView
{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]firstObject];
}

@end
