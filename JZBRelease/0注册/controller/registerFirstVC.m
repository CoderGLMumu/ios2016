//
//  registerFirstVC.m
//  JZBRelease
//
//  Created by zjapple on 16/8/26.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "registerFirstVC.h"
#import "registerSecVC.h"
#import "MitRegex.h"
#import "SendAndGetDataFromNet.h"

#import "JoinUsToxieYiView.h"

#import "RealReachability.h"
#import "NetWorkTipView.h"
#import "BCH_Alert.h"

@interface registerFirstVC ()<UITextFieldDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *checkTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *checkpasswordTF;

/** 短信验证码 */
@property (nonatomic, strong) NSString *phoneCheckNum;
@property (weak, nonatomic) IBOutlet UIButton *GetCheckNumButton;

/** 定时器-倒计时 */
@property (nonatomic, strong) NSTimer *timer;
/** timeNum */
@property (nonatomic, assign) NSInteger timeNum;
@property (strong, nonatomic) IBOutlet UIView *BastView;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

/** recordPhoneNum */
@property (nonatomic, strong) NSString *recordPhoneNum;

@end

@implementation registerFirstVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SVProgressHUD setMinimumDismissTimeInterval:1.75];
    
    self.phoneTF.delegate = self;
    self.checkTF.delegate = self;
    self.passwordTF.delegate = self;
    self.checkpasswordTF.delegate = self;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(NotPush)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismissSelfVC)];
    
}

- (void)NotPush
{

}

- (void)dismissSelfVC
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)setupTimer
{
    if (self.timer) {
        self.timer = nil;
        [self.timer invalidate];
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timing:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (IBAction)DownloadCheckNum:(UIButton *)sender {
    
    ReachabilityStatus status = [GLobalRealReachability currentReachabilityStatus];
    GLLog(@"Initial reachability status:%@",@(status));
    
    if (status == RealStatusNotReachable)
    {
        //          self.flagLabel.text = @"Network unreachable!";
        
        if ([[RealReachability sharedInstance] currentLocalConnectionStatus] == LC_UnReachable) {
            NetWorkTipView *view = [NetWorkTipView netWorkTipView];
            
            //          UIViewController *vc = [self currentViewController];
            //        AppDelegate *appD = (AppDelegate *)
            [[UIApplication sharedApplication].keyWindow addSubview:view];
            
            view.frame = CGRectMake(0, 20, GLScreenW, GLScreenH -20);
        }else{
            [NetWorkTipView tipSetButton];
        }
        
        
        return ;
    }
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",@"text/plain", nil];

    [manager POST:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/Sms/sendcode"] parameters:@{@"mobile":self.phoneTF.text} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        if ([responseObject[@"code"] isEqual:@(200)]) {
            self.phoneCheckNum = responseObject[@"obj"];
            [SVProgressHUD showInfoWithStatus:@"验证码已发送注意查收"];
            
            [self setupTimer];
            
            
            self.recordPhoneNum = self.phoneTF.text;
            self.timeNum = 120;
            
            [self.timer fire];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(120 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
            });
            
        }else if ([responseObject[@"code"] isEqual:@(416)]){
            
            [SVProgressHUD showInfoWithStatus:@"手机号申请验证码过多被限制,请联系我们进行申请"];
            
        }else {
//            [SVProgressHUD showInfoWithStatus:@"输入的手机号有误,请重新输入"];
            [SVProgressHUD showInfoWithStatus:@"请输入正确的手机号码"];
            self.phoneTF.text = @"";
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable responseObject, NSError * _Nonnull error) {
        
    }];
    
//    [HttpToolSDK postWithURL:@"http://192.168.10.154/bang/index.php/Web/Sms/sendcode" parameters:@{@"mobile":self.phoneTF.text} success:^(id json) {
//        
//        
//        
//    } failure:^(NSError *error) {
//        
//    }];
}

- (void)timing:(NSTimer *)timer
{
    [self.GetCheckNumButton setTitle:[NSString stringWithFormat:@"%ld秒可再获取",(long)self.timeNum] forState:UIControlStateNormal];
    if (self.timeNum > 0) {
        self.timeNum--;
        self.GetCheckNumButton.userInteractionEnabled = NO;
    }else{
        //销毁定时器
        [self.timer invalidate];
        [self.GetCheckNumButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.GetCheckNumButton.userInteractionEnabled = YES;
        
        
        
    }
}

#pragma mark - 点击下一步
- (IBAction)nextPage:(UIButton *)sender {
    
//    [SVProgressHUD showProgress:0.5 status:@"正在校验"];
    
    __block BOOL isPhone = NO;
    
    /** 完成所有校验:
     如果之前前面一个条件的校验未通过,将不会再进行下一个校验,返回的状态值也是未通过的校验值
     只有当校验条件全部通过的时候, isPassed 才为1.
     */
    [NSObject mit_makeMitRegexMaker:^(MitRegexMaker *maker) {
        maker.validatePhone(self.phoneTF.text).validatePsd(self.passwordTF.text);
    } MitValue:^(MitRegexStateType statusType, NSString * statusStr , BOOL isPassed) {
        
        isPhone = isPassed;
        
        if (!isPassed) {
//            [SVProgressHUD dismiss];
            [SVProgressHUD showInfoWithStatus:statusStr];
            
        }
        
//        NSLog(@"是否通过校验 = %d 状态码 = %ld, 状态详细 = %@",isPassed,statusType,statusStr);
        
    }];
    
    if (!isPhone) {
        return ;
    }
    
//    [self checkInputInfo];
    
    if (![self.recordPhoneNum isEqualToString:self.phoneTF.text]) {
        [SVProgressHUD showInfoWithStatus:@"输入的验证码和手机号不匹配"];
        return ;
    }
    
    if (![self.phoneCheckNum isEqualToString:self.checkTF.text]) {
        [SVProgressHUD showInfoWithStatus:@"输入的短信验证码过期或者错误,请重新输入"];
        return ;
    };
    
    if (self.passwordTF.text.length <= 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入密码"];
        return ;
    }
    
    if (self.checkpasswordTF.text.length <= 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入确认密码"];
        return ;
    }
    
    if (![self.passwordTF.text isEqualToString:self.checkpasswordTF.text]) {
        //        [SVProgressHUD dismiss];
        [SVProgressHUD showInfoWithStatus:@"两次输入密码不相同,请重新输入"];
        return ;
    }
    
    //    [self checkInputInfo];
    
    [self performSegueWithIdentifier:@"login2Contact" sender:nil];
    
}

- (void)checkInputInfo
{
    
    
    
}


//开始编辑时键盘上移 【当弹出的键盘挡住输入框时* 键盘挡住输入框】
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //文本框位置在屏幕底部-216键盘高度-50可能差值时
    CGFloat offset = self.view.frame.size.height -(textField.superview.frame.origin.y + textField.frame.size.height +216 + 150);
    //移动
    if (offset <= 0) {
        [UIView animateWithDuration:0.2 animations:^{
            CGRect frame = self.view.frame;
            frame.origin.y = offset;
            self.BastView.frame = frame;
        }];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    //文本框位置在屏幕底部-216键盘高度-50可能差值时
    CGFloat offset = self.view.frame.size.height -(textField.superview.frame.origin.y + textField.frame.size.height +216 + 150);
    //移动
    if (offset <= 0) {
        [UIView animateWithDuration:0.2 animations:^{
            CGRect frame = self.view.frame;
            frame.origin.y = offset;
            self.BastView.frame = frame;
        }];
    }
    
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 0.0;
        self.view.frame = frame;
    }];
    return YES;
}

//结束编辑时向键盘下移
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 0.0;
        self.view.frame = frame;
    }];
}


//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
//{
//    [UIView animateWithDuration:0.2 animations:^{
//        CGRect frame = self.view.frame;
//        frame.origin.y = 0.0;
//        self.view.frame = frame;
//    }];
//    return YES;
//}

#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    registerSecVC *contact =  (registerSecVC *)segue.destinationViewController;
    contact.mobile = self.phoneTF.text;
    contact.password = self.passwordTF.text;
    contact.repassword = self.checkpasswordTF.text;
    contact.loginVC = self.loginVC;
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
- (IBAction)clickCheckButton:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        self.nextButton.enabled = YES;
    }else {
        self.nextButton.enabled = NO;
    }
    
}

- (void)dealloc
{
    self.timer = nil;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - 点击遵守加入建众帮协议
- (IBAction)selectXieYiBtn:(UIButton *)btn{
    
    // 点击遵守加入建众帮协议
    JoinUsToxieYiView *popview = [JoinUsToxieYiView shareJoinUsToxieYiView];
    [self.view addSubview:popview];
    popview.frame = self.view.frame;
    
    [popview.contentView setDelegate:self];
    [popview.contentView setEditable:YES];
}

#pragma mark - textViewDelegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return NO;
}

//控制输入文字的长度和内容，可通调用以下代理方法实现
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (self.phoneTF == textField) {
        if (range.location>=11)
        {
            
            //控制输入文本的长度
            
            return  NO;
        }
    }
    
    if (self.checkTF == textField) {
        if (range.location>=4)
        {
            
            //控制输入文本的长度
            
            return  NO;
        }
    }
    
    return YES;
}

- (BOOL)shouldAutorotate
{
    //    UINavigationController *nav = (UINavigationController *)self.viewControllers[0];
    //    GLLog(@"旋转测试 NO %@=-=-=%@",nav,nav.topViewController)
    //    if ([nav.topViewController isKindOfClass:[XBVideoAndVoiceVC class]] || [nav.topViewController isKindOfClass:[LiveVideoViewController class]]) {
    //        GLLog(@"旋转测试 YES %@=-=-=%@",nav,nav.topViewController)
    //        return nav.topViewController.shouldAutorotate;
    //    }
    
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}


@end
