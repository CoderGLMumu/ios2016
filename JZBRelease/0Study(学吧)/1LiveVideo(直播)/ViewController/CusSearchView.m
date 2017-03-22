
//
//  CusSearchView.m
//  JZBRelease
//
//  Created by cl z on 16/9/26.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "CusSearchView.h"

@implementation CusSearchView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"f2f2f2"]];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, frame.size.width - 20, frame.size.height - 20)];
        [self addSubview:btn];
        [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundColor:[UIColor whiteColor]];
        btn.layer.cornerRadius = 5.0;
        btn.layer.borderColor = [UIColor hx_colorWithHexRGBAString:@"dfdfdf"].CGColor;
        btn.layer.borderWidth = 0.8;
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, (btn.frame.size.height - 20) / 2, 20, 20)];
        [imageView setImage:[UIImage imageNamed:@"XB_XX_SS"]];
        [btn addSubview:imageView];
        
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(45, 0, btn.frame.size.width - 45, btn.frame.size.height)];
        [self.label setText:@"请输入你要搜索的导师、课程内容"];
        [self.label setFont:[UIFont systemFontOfSize:14]];
        [self.label setTextColor:[UIColor hx_colorWithHexRGBAString:@"bdbdbd"]];
        [btn addSubview:self.label];
    }
    return self;
}

- (void) setLabelText:(NSString *)text{
    [self.label setText:text];
}

- (void) btnAction{
    if (self.returnAction) {
        self.returnAction();
    }
}

@end
