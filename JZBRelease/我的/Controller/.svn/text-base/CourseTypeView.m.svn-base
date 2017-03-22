//
//  CourseTypeView.m
//  JZBRelease
//
//  Created by cl z on 16/9/13.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "CourseTypeView.h"

@implementation CourseTypeView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.serialsBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width / 6, 0, self.frame.size.width * 2 / 3, 44)];
        self.serialsBtn.layer.cornerRadius = 3.0;
        [self.serialsBtn setTitle:@"新建系列" forState:UIControlStateNormal];
        [self addSubview:self.serialsBtn];
        
        self.singleBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width / 6, 64, self.frame.size.width * 2 / 3, 44)];
        self.singleBtn.layer.cornerRadius = 3.0;
        [self.singleBtn setTitle:@"新建单课" forState:UIControlStateNormal];
        [self addSubview:self.singleBtn];
    }
    return self;
}

@end
