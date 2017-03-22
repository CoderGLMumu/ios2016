//
//  ApplyTeacherVC.m
//  JZBRelease
//
//  Created by cl z on 16/9/18.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "ApplyTeacherVC.h"
#import "Defaults.h"
#import "UIPlaceHolderTextView.h"
#import "SendApplyTeacherModel.h"
@interface ApplyTeacherVC ()<UITextViewDelegate>

@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIPlaceHolderTextView *mineIntroduceTextView;
@property(nonatomic, strong) UIPlaceHolderTextView *applyReasonTextView;
@property(nonatomic, assign) NSInteger requestCount;
@end

@implementation ApplyTeacherVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.requestCount = 0;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"申请导师";
    [self configNav];
    [self.view addSubview:self.scrollView];
    [self initIntroduceViews];
    [self initApplyReasonViews];
}


-(void)configNav
{
    UIButton *sendBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 35, 28)];
    [sendBtn setTitle:@"申请" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendApplication) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
    UIBarButtonItem *sendBarBtn = [[UIBarButtonItem alloc]initWithCustomView:sendBtn];
    self.navigationItem.rightBarButtonItem = sendBarBtn;
    
}

- (void)sendApplication{
    if (self.mineIntroduceTextView.text.length <= 0) {
        [Toast makeShowCommen:@"您未填写 " ShowHighlight:@"自我介绍" HowLong:0.8];
        return;
    }
    if (self.applyReasonTextView.text.length <= 0) {
        [Toast makeShowCommen:@"您未填写 " ShowHighlight:@"申请原因" HowLong:0.8];
        return;
    }
    CustomAlertView *alertView = [CustomAlertView defaultCustomAlertView:@"申请中..."];
    [self lew_presentPopupView:alertView animation:[LewPopupViewAnimationSpring new]];
    //
    SendApplyTeacherModel *sendApplyTeacherModel = [[SendApplyTeacherModel alloc]init];
    sendApplyTeacherModel.access_token = [[LoginVM getInstance]readLocal].token;
    sendApplyTeacherModel.reason = self.applyReasonTextView.text;
    sendApplyTeacherModel.teacher_desc = self.mineIntroduceTextView.text;
    SendAndGetDataFromNet *send = [[SendAndGetDataFromNet alloc]init];
    __block typeof (send) wsend = send;
    __weak typeof (self) wself = self;
    send.returnModel = ^(GetValueObject *obj,int state){
        if (!obj) {
            [alertView.label setText:@"申请失败"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [wself lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
                [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
            });
        }else{
            if (1 == state) {
                wself.requestCount = 0;
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:@"1" forKey:@"TeacherState"];
                if (self.returnAction) {
                    self.returnAction(obj.info);
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [alertView setTitle:@"申请成功"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [wself lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
                        [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [wself.navigationController popViewControllerAnimated:YES];
                            
                        });
                    });
                });
            }else{
                if (wself.requestCount > 0) {
                    [alertView.label setText:obj.info];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [wself lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
                        [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
                        wself.requestCount = 0;
                        if (self.returnAction) {
                            self.returnAction(obj.info);
                        }
                    });
                     return ;
                }
                [LoginVM getInstance].isGetToken = ^(){
                    sendApplyTeacherModel.access_token = [[LoginVM getInstance] readLocal].token;
                    wself.requestCount ++;
                    [wsend commenDataFromNet:sendApplyTeacherModel WithRelativePath:@"Apply_Teacher_URL"];
                    
                };
                [[LoginVM getInstance] loginWithUserInfoForGetNewToken:[[LoginVM getInstance] readLocal]];
            }
        }
    };
    [send commenDataFromNet:sendApplyTeacherModel WithRelativePath:@"Apply_Teacher_URL"];
    
}

- (void)textViewDidChange:(UITextView *)textView{
    if (textView == self.mineIntroduceTextView) {
        if (textView.text.length > 200) {
            [Toast makeShowCommen:@"您自我介绍字数已超 " ShowHighlight:@"255" HowLong:0.8];
            [textView setText:[textView.text substringToIndex:200]];
        }
    }else{
        if (textView.text.length > 100) {
            [Toast makeShowCommen:@"您申请原因字数已超 " ShowHighlight:@"50" HowLong:0.8];
            [textView setText:[textView.text substringToIndex:100]];
        }
    }
}

-(UIScrollView *)scrollView{
    if (_scrollView) {
        return _scrollView;
    }
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _scrollView.directionalLockEnabled = YES; //只能一个方向滑动
    _scrollView.pagingEnabled = NO; //是否翻页
    _scrollView.backgroundColor = [ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Inteval_Color" WithKind:XMLTypeColors]];
    _scrollView.showsVerticalScrollIndicator =YES; //垂直方向的滚动指示
    _scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;//滚动指示的风格
    _scrollView.showsHorizontalScrollIndicator = NO;//水平方向的滚动指示
    return _scrollView;
}

- (UIView *) returnTitleView:(NSString *) title WithFrame:(CGRect) frame{
    UIView *titleView = [[UIView alloc]initWithFrame:frame];
    [titleView setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"f8f8f8"]];
    UILabel *label = [UILabel createLabelWithFrame:CGRectMake(15, 0, 120, frame.size.height) Font:13 Text:title andLCR:NSTextAlignmentLeft andColor:[UIColor hx_colorWithHexRGBAString:@"757575"]];
    [titleView addSubview:label];
    return titleView;
}

- (void)initIntroduceViews{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    [view setBackgroundColor:[UIColor whiteColor]];
    [self.scrollView addSubview:view];
    
    [view addSubview:[self returnTitleView:@"自我介绍" WithFrame:CGRectMake(0, 0,SCREEN_WIDTH, 35)]];

    self.mineIntroduceTextView = [[UIPlaceHolderTextView alloc]initWithFrame:CGRectMake(15, 50, SCREEN_WIDTH - 30, 135)];
    self.mineIntroduceTextView.placeholder = @"请输入200字内的自我介绍";
    self.mineIntroduceTextView.font = [UIFont systemFontOfSize:14];
    self.mineIntroduceTextView.placeholderColor = [UIColor hx_colorWithHexRGBAString:@"d0d0d0"];
    self.mineIntroduceTextView.textColor = [UIColor hx_colorWithHexRGBAString:@"757575"];
    self.mineIntroduceTextView.layer.cornerRadius = 3.0;
    self.mineIntroduceTextView.delegate = self;
    self.mineIntroduceTextView.layer.borderColor = [ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Inteval_Color" WithKind:XMLTypeColors]].CGColor;
    self.mineIntroduceTextView.layer.borderWidth = 0.8;
    [view addSubview:self.mineIntroduceTextView];
}

- (void)initApplyReasonViews{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 200, SCREEN_WIDTH, 150)];
    [view setBackgroundColor:[UIColor whiteColor]];
    [self.scrollView addSubview:view];
    
    [view addSubview:[self returnTitleView:@"申请原因" WithFrame:CGRectMake(0, 0,SCREEN_WIDTH, 35)]];
    
    self.applyReasonTextView = [[UIPlaceHolderTextView alloc]initWithFrame:CGRectMake(15, 50, SCREEN_WIDTH - 30, 85)];
    self.applyReasonTextView.placeholder = @"请输入申请原因，字数100字内";
    self.applyReasonTextView.font = [UIFont systemFontOfSize:14];
    self.applyReasonTextView.placeholderColor = [UIColor hx_colorWithHexRGBAString:@"d0d0d0"];
    self.applyReasonTextView.delegate = self;
    self.applyReasonTextView.textColor = [UIColor hx_colorWithHexRGBAString:@"757575"];
    self.applyReasonTextView.layer.cornerRadius = 3.0;
    self.applyReasonTextView.layer.borderColor = [ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Inteval_Color" WithKind:XMLTypeColors]].CGColor;
    self.applyReasonTextView.layer.borderWidth = 0.8;
    [view addSubview:self.applyReasonTextView];
    
    [self.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, view.frame.origin.y + view.frame.size.height + 150)];
}

@end
