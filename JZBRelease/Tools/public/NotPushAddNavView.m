//
//  NotPushAddNavView.m
//  JZBRelease
//
//  Created by Apple on 16/11/9.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "NotPushAddNavView.h"

@implementation NotPushAddNavView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSubView];
    }
    return self;
}

- (void)setupSubView
{
    UIView *view = [UIView new];
    view.frame = CGRectMake(0, 0, GLScreenW,64);
    view.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"222222"];
//    view.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"1976d2"];
    [self addSubview:view];
    
}

@end
