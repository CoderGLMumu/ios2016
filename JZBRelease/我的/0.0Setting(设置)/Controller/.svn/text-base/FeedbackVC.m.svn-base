//
//  FeedbackVC.m
//  JZBRelease
//
//  Created by cl z on 16/10/26.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "FeedbackVC.h"
#import "UIPlaceHolderTextView.h"
#import "Defaults.h"
@interface FeedbackVC ()<UITextViewDelegate>{
    UIView *view;
}

@property(nonatomic, strong) UIPlaceHolderTextView *textView;

@property(nonatomic, strong) UIButton *sendBtn;

@end

@implementation FeedbackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见";
    [self.view setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"f2f2f2"]];
    view = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 224)];
    [view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:view];
    [view addSubview:[self returnTitleView:@"反馈意见" WithFrame:CGRectMake(0, 0,view.frame.size.width, 44)]];
    [view addSubview:self.textView];
    
    [self.view addSubview:self.sendBtn];
}

- (UIView *) returnTitleView:(NSString *) title WithFrame:(CGRect) frame{
    UIView *titleView = [[UIView alloc]initWithFrame:frame];
    [titleView setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"f8f8f8"]];
    UILabel *label = [UILabel createLabelWithFrame:CGRectMake(15, 0, 120, frame.size.height) Font:15 Text:title andLCR:NSTextAlignmentLeft andColor:[UIColor hx_colorWithHexRGBAString:@"757575"]];
    [titleView addSubview:label];
    return titleView;
}

- (UIPlaceHolderTextView *)textView{
    if (!_textView) {
        _textView = [[UIPlaceHolderTextView alloc]initWithFrame:CGRectMake(15, 59, GLScreenW - 30, 150)];
        _textView.placeholder = @"请输入200字内的找反馈意见";
        _textView.font = [UIFont systemFontOfSize:14];
        _textView.placeholderColor = [UIColor hx_colorWithHexRGBAString:@"d0d0d0"];
        _textView.textColor = [UIColor hx_colorWithHexRGBAString:@"757575"];
        _textView.layer.cornerRadius = 3.0;
        _textView.delegate = self;
        _textView.layer.borderColor = [ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Inteval_Color" WithKind:XMLTypeColors]].CGColor;
        _textView.layer.borderWidth = 0.8;
    }
    return _textView;
}

- (UIButton *)sendBtn{
    if (!_sendBtn) {
        _sendBtn = [[UIButton alloc]initWithFrame:CGRectMake(44, view.frame.origin.y + view.frame.size.height + 60, self.view.frame.size.width - 88, 44)];
        [_sendBtn setTitle:@"提交" forState:UIControlStateNormal];
        [_sendBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [_sendBtn addTarget:self action:@selector(sendBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendBtn setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"2196f3"]];
//        [_sendBtn setBackgroundColor:[ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Navigation_Color_new" WithKind:XMLTypeColors]]];
//        _sendBtn.layer.borderColor = [UIColor hx_colorWithHexRGBAString:@"ff9800"].CGColor;
//        _sendBtn.layer.borderWidth = 1.0;
        _sendBtn.layer.cornerRadius = 22.0;
    }
    return _sendBtn;
}

- (void)sendBtnAction:(UIButton *)btn{
    if (self.textView.text.length == 0) {
//        [Toast makeShowCommen:@"" ShowHighlight:@"提交失败，请输入意见" HowLong:0.8];
        [SVProgressHUD showInfoWithStatus:@"提交失败，请输入意见"];
        return;
    }
    NSDictionary *parameters = @{
                                 @"access_token":[[LoginVM getInstance]readLocal].token,
                                 @"content":self.textView.text
                                 };
    
    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"/Web/Report/add_feedback"] parameters:parameters success:^(id json) {
        if ([json[@"state"] integerValue] == 1) {
            self.textView.text = @"";
//            [Toast makeShowCommen:@"" ShowHighlight:@"非常感谢您提供的意见，我们将会在最短的时间解决" HowLong:1];
            [SVProgressHUD showInfoWithStatus:@"非常感谢您提供的意见，我们将会在最短的时间解决"];
            
            //[self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        
    }];
}

@end
