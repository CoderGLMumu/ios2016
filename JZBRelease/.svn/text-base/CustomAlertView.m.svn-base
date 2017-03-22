//
//  CustomAlertView.m
//  JZBRelease
//
//  Created by zjapple on 16/6/13.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "CustomAlertView.h"
#import "Defaults.h"
@implementation CustomAlertView

-(instancetype)initWithFrame:(CGRect)frame WithType:(NSString *)type{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 5.0;
        self.backgroundColor = [UIColor blackColor];
        UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activity.frame = CGRectMake(28, 18, 44, 44);
        [self addSubview:activity];
        [activity startAnimating];
        self.label = [UILabel createLabelWithFrame:CGRectMake(0, 18 + 44 + 6, 100, 20) Font:13 Text:type andLCR:1 andColor:[UIColor whiteColor]];
        self.label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.label];
        
    }
    return self;
}

+ (instancetype)defaultCustomAlertView:(NSString *) type{
    return [[CustomAlertView alloc]initWithFrame:CGRectMake(0, 0, 100, 100) WithType:type];
}

@end
