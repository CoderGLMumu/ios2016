//
//  VideoAndVoiceBottomView.m
//  JZBRelease
//
//  Created by cl z on 16/10/31.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "VideoAndVoiceBottomView.h"

@implementation VideoAndVoiceBottomView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *inteval = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 1)];
        [inteval setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"f2f2f2"]];
        [self addSubview:inteval];
        if (!_askListBtn) {
            _askListBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
            //_askListBtn setImage:[UIImage imageNamed:@""] forState:in
            [_askListBtn setTitle:@"问答" forState:UIControlStateNormal];
            [self addSubview:_askListBtn];
        }
        if (!_shareBtn) {
            _shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width - 50, 0, 50, 50)];
            //_askListBtn setImage:[UIImage imageNamed:@""] forState:<#(UIControlState)#>
            [_shareBtn setTitle:@"分享" forState:UIControlStateNormal];
            [self addSubview:_shareBtn];
        }
        if (!_commentTextField) {
            _commentTextField = [[UITextField alloc]initWithFrame:CGRectMake(50, 8, frame.size.width - 100, 50 - 16)];
            [_commentTextField setPlaceholder:@"   想说点什么"];
            _commentTextField.layer.cornerRadius = 3.0;
            [_commentTextField setFont:[UIFont systemFontOfSize:14]];
            [_commentTextField setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"f2f2f2"]];
            [self addSubview:_commentTextField];
        }
    }
    return self;
}

@end
