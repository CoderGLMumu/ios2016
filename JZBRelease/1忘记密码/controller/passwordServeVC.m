//
//  passwordServeVC.m
//  JZBRelease
//
//  Created by zjapple on 16/9/2.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "passwordServeVC.h"
#import "MitRegex.h"
#import "SendAndGetDataFromNet.h"

#import "RealReachability.h"
#import "NetWorkTipView.h"

@interface passwordServeVC ()<UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *checkTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *checkpasswordTF;

@property (strong, nonatomic) IBOutlet UIView *BastView;

/** 短信验证码 */
@property (nonatomic, assign) NSString *phoneCheckNum;
@property (weak, nonatomic) IBOutlet UIButton *GetCheckNumButton;

/** 定时器-倒计时 */
@property (nonatomic, strong) NSTimer *timer;
/** timeNum */
@property (nonatomic, assign) NSInteger timeNum;

/** recordPhoneNum */
@property (nonatomic, strong) NSString *recordPhoneNum;

@end

@implementation passwordServeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.phoneTF.delegate = self;
    self.checkTF.delegate = self;
    self.passwordTF.delegate = self;
    self.checkpasswordTF.delegate = self;
    
    [SVProgressHUD setMinimumDismissTimeInterval:1.75];
    
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
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timing:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (IBAction)DownloadCheckNum:(UIButton *)sender {
    
    ReachabilityStatus status = [GLobalRealReachability currentReachabilityStatus];
    ReachabilityStatus status2 = [GLobalRealReachability previousReachabilityStatus];
    LocalConnectionStatus status3 = [GLobalRealReachability currentLocalConnectionStatus];
    GLLog(@"Initial reachability status:%@",@(status));
    GLLog(@"Initial reachability status2:%@",@(status2));
    GLLog(@"Initial reachability status3:%@",@(status3));
    
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
            
            self.GetCheckNumButton.userInteractionEnabled = NO;
            self.recordPhoneNum = self.phoneTF.text;
            self.timeNum = 120;
            
            [self.timer fire];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(120 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.GetCheckNumButton.userInteractionEnabled = YES;
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
    [self.GetCheckNumButton setTitle:[NSString stringWithFormat:@"%ld秒后获取",(long)self.timeNum] forState:UIControlStateNormal];
    
    if (self.timeNum > 0) {
        self.timeNum--;
    }else{
        //销毁定时器
        [self.timer invalidate];
        [self.GetCheckNumButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        
    }
}

#pragma mark - 点击确认按钮
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
    
//    NSDictionary *parameters = @{
//                                 @"mobile":self.phoneTF.text,
//                                 @"newpassword":self.passwordTF.text,
//                                 @"renewpassword":self.checkpasswordTF.text
//                                 };
    
    HttpBaseRequestItem *item = [HttpBaseRequestItem new];
    item.mobile = self.phoneTF.text;
    item.newpassword = self.passwordTF.text;
    item.renewpassword = self.checkpasswordTF.text;
    NSDictionary *parameters = item.mj_keyValues;
    
    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/user/reset_password"] parameters:parameters success:^(id json) {
        
        if ([json[@"state"] isEqual:@(1)]) {
            [SVProgressHUD showSuccessWithStatus:@"修改密码成功"];
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }else {
            [SVProgressHUD showInfoWithStatus:json[@"info"]];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}


//开始编辑时键盘上移 【当弹出的键盘挡住输入框时* 键盘挡住输入框】
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //文本框位置在屏幕底部-216键盘高度-50可能差值时
    CGFloat offset = self.view.frame.size.height -(textField.superview.frame.origin.y + textField.frame.size.height +216 + 180);
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
    CGFloat offset = self.view.frame.size.height -(textField.superview.frame.origin.y + textField.frame.size.height +216 + 180);
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


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
    return UIInterfaceOrientationMaskPortrait;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
