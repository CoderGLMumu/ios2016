//
//  LoginVC.m
//  JZBRelease
//
//  Created by zjapple on 16/5/17.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "LoginVC.h"
#import "LoginVM.h"
#import "HomeTabBarVC.h"
//#import "LoginView.h"
#import "Defaults.h"
#import "HXFriendList.h"
#import "AddHostToLoadPIC.h"
#import "DataBaseHelperSecond.h"
#import "HXFriendDataSource.h"

#import "HttpToolSDK.h"
#import "GLFMDBToolSDK.h"

#import "INTULocationManager.h"
#import <CoreLocation/CoreLocation.h>

#import "HXDataHelper.h"
#import "JMAnimationButton.h"
#import "Masonry.h"

#import "registerFirstVC.h"
#import "registerNavVC.h"
#import "passwordServeVC.h"
#import "MYRootVC.h"

#import "SendAndGetDataFromNet.h"
#import "AppDelegate.h"
#import "SixWdRootVC.h"

//#import "JZBcheckVersion.h"

#import "InstructionsVC.h"
#import "GLNAVC.h"
#import "NetWorkTipView.h"
#import "RealReachability.h"

@interface LoginVC()<JMAnimationButtonDelegate>{
    int success;
    BOOL ishitFreeBtn;
}

//@property(nonatomic, strong) LoginView *loginView;

/** INTULocationManager */
@property (nonatomic, strong) INTULocationManager *INTULlocationM;
/** status_test */
@property (nonatomic, assign) INTULocationStatus status_test;

/** geo */
@property (nonatomic, strong) CLGeocoder *geoC;

@property (strong, nonatomic)  UILabel *numAddressL;

@property (strong, nonatomic)  UILabel *addressL;

@property (strong, nonatomic)  UILabel *addressL_first;

/** FMDBTool */
@property (nonatomic, strong) GLFMDBToolSDK *FMDBTool;

/** top标题view */
@property (nonatomic, weak) UIView *titleView;
/** mid中间inputView */
@property (nonatomic, weak) UIView *inputView;

/** isLoginblock */
@property (nonatomic, assign) BOOL isLoginblock;

/** isLoginblock */
@property (nonatomic, strong) UIButton *freeLoginBtn;

@end

@implementation LoginVC{
    LoginVM *loginVM;
    UserInfo *userInfo;

}

- (BOOL)shouldAutorotate
{
    
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (GLFMDBToolSDK *)FMDBTool
{
    if (_FMDBTool == nil) {
        _FMDBTool = [GLFMDBToolSDK shareToolsWithCreateDDL:nil];
    }
    return _FMDBTool;
}

- (void)tipButton1Active:(UIButton *)btn
{
    InstructionsVC * vc= [InstructionsVC new];
    GLNAVC *navvc = [[GLNAVC alloc]initWithRootViewController:vc];
    
    [self presentViewController:navvc animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.isClearPassword) {
        self.passwordTF.text = @"";
    }
    
    self.navigationItem.leftBarButtonItems = nil;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(NotPush)];
    
    self.title = @"登录";
    
//    if (self.navigationController) {
//        UIButton *tipButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
//        
//        [tipButton1 setTitle:@"使用说明" forState:UIControlStateNormal];
//        
//        [tipButton1 setFont:[UIFont systemFontOfSize:15]];
//        
//        [tipButton1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        
//        tipButton1.frame = CGRectMake(0, 0, 100, 25);
//        [tipButton1 sizeToFit];
//        
//        [tipButton1 addTarget:self action:@selector(tipButton1Active:) forControlEvents:UIControlEventTouchUpInside];
//        
//        self.navigationItem.rightBarButtonItems = nil;
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:tipButton1];
//    }else {
    
//    }

}

-(void)viewDidLoad{
    
    UIApplication *ap = [UIApplication sharedApplication];
    
    ap.statusBarStyle = UIStatusBarStyleLightContent;
    
//    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//    int width = SCREEN_WIDTH * 4 / 5;
//    int heigh = 230;
    /** 登录页面背景颜色 */
    self.view.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"F8F8F8"];
    
//    UIImageView *bg = [[UIImageView alloc]initWithFrame:self.view.bounds];
//    [bg setImage:[UIImage imageNamed:@"login_bg"]];
//    [self.view addSubview:bg];
    
//    self.loginView = [[LoginView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - width) / 2, (SCREEN_HEIGHT - heigh) / 2, width, heigh)];
//    self.loginView.button1.delegate = self;
//    [self.loginView.button1 addTarget:self action:@selector(loginBtnSender) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:self.loginView];
//    loginVM = [[LoginVM alloc]init];
//    userInfo = [loginVM readLocal];
//    if (userInfo) {
//        [self.loginView.accountTF setText:userInfo.account];
//        [self.loginView.passwordTF setText:userInfo.password];
//    }
    
    UIButton *tipButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [tipButton1 setTitle:@"使用说明" forState:UIControlStateNormal];
    
    [tipButton1 setFont:[UIFont systemFontOfSize:15]];
    
    [tipButton1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    tipButton1.frame = CGRectMake(GLScreenW - 70, 26, 70, 38);
    [tipButton1 sizeToFit];
    
    [tipButton1 addTarget:self action:@selector(tipButton1Active:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItems = nil;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:tipButton1];
//    [self.titleView addSubview:tipButton1];
    
    /** 初始化 头部 */
    [self setUpTitle];
    
    /** 初始化 TF */
    [self setUpTFInput];
    
    /** 初始化 Login相关 */
    [self setUpLoginButton];
    
    /** 开始定位 */
    [self setupLocation];
}


- (void)NotPush
{
    
}

#pragma mark - 初始化 头部
- (void)setUpTitle
{
    UIView *titleView = [UIView new];
    [self.view addSubview:titleView];
    self.titleView = titleView;
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@(0));
        make.height.equalTo(@(64));
        make.width.equalTo(self.view.mas_width);
    }];
//    titleView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"1976d2"];
    titleView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"222222"];
    
    UIButton *tipButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [tipButton1 setTitle:@"使用说明" forState:UIControlStateNormal];
    
    [tipButton1 setFont:[UIFont systemFontOfSize:15]];
    
    [tipButton1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    tipButton1.frame = CGRectMake(GLScreenW - 70, 26, 70, 38);
    [tipButton1 sizeToFit];
    
    [tipButton1 addTarget:self action:@selector(tipButton1Active:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleView addSubview:tipButton1];
    
    UILabel *titleLabel = [UILabel new];
    [titleView addSubview:titleLabel];
    titleLabel.text = @"登录";
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel sizeToFit];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(titleLabel.superview.mas_centerX);
        make.bottom.equalTo(@(-12));
    }];
}
#pragma mark - 初始化 TF
- (void)setUpTFInput
{
    UIView *inputView = [UIView new];
    [self.view addSubview:inputView];
    self.inputView = inputView;
    [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView.mas_bottom);
        make.left.right.equalTo(self.titleView);
        make.height.equalTo(@(139));
    }];
    
    UIView *mobileView = [UIView new];
    [inputView addSubview:mobileView];
    [mobileView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(28));
        make.right.equalTo(@(-28));
        make.top.equalTo(@(18));
        make.height.equalTo(@(44));
    }];
    
    UIImageView *mobileBG = [UIImageView new];
    [mobileView addSubview:mobileBG];
    [mobileBG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(mobileBG.superview);
    }];
    mobileBG.image = [UIImage imageNamed:@"DL_NUMBER"];
    
    UIImageView *mobileIcon = [UIImageView new];
    [mobileView addSubview:mobileIcon];
    [mobileIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@(mobileBG.glh_height * 0.5));
        make.left.equalTo(@(15));
        make.height.width.equalTo(@(20));
    }];
    mobileIcon.image = [UIImage imageNamed:@"DL_MINE"];
    
    UITextField *mobileTF = [[UITextField alloc]init];
    [inputView addSubview:mobileTF];
    self.usernameTF = mobileTF;
    [mobileTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mobileIcon.mas_right).offset(15);
        make.centerY.equalTo(mobileBG.mas_centerY);
        make.right.equalTo(mobileTF.superview.mas_right).offset(-28);
    }];
    mobileTF.font = [UIFont systemFontOfSize:15];
    mobileTF.placeholder = @"请输入您的手机号码";
    mobileTF.textColor = [UIColor hx_colorWithHexRGBAString:@"212121"];
    mobileTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    
    
    UIView *passWordView = [UIView new];
    [inputView addSubview:passWordView];
    [passWordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(28));
        make.right.equalTo(@(-28));
        make.top.equalTo(mobileView.mas_bottom).offset(15);
        make.height.equalTo(@(44));
    }];
    
    UIImageView *passWordBG = [UIImageView new];
    [passWordView addSubview:passWordBG];
    [passWordBG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(passWordBG.superview);
    }];
    passWordBG.image = [UIImage imageNamed:@"DL_PASSWORD"];
    
    UIImageView *passWordIcon = [UIImageView new];
    [passWordView addSubview:passWordIcon];
    [passWordIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@(passWordBG.glh_height * 0.5));
        make.left.equalTo(@(15));
        make.height.width.equalTo(@(20));
    }];
    passWordIcon.image = [UIImage imageNamed:@"DL_LOCK"];
    
    
    UITextField *passWordTF = [[UITextField alloc]init];
    [inputView addSubview:passWordTF];
    self.passwordTF = passWordTF;
    [passWordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mobileIcon.mas_right).offset(15);
        make.centerY.equalTo(passWordBG.mas_centerY);
        make.right.equalTo(mobileTF.superview.mas_right).offset(-28);
    }];
    passWordTF.placeholder = @"请输入密码";
    passWordTF.font = [UIFont systemFontOfSize:15];
    passWordTF.textColor = [UIColor hx_colorWithHexRGBAString:@"212121"];
    passWordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    passWordTF.secureTextEntry = YES;
    
    loginVM = [LoginVM getInstance];
    userInfo = [loginVM readLocal];
    if (userInfo) {
        [mobileTF setText:userInfo.account];
        [passWordTF setText:userInfo.password];
    }
    if ([mobileTF.text isEqualToString:@"13322223333"]) {
        [mobileTF setText:@""];
    }
    
}
#pragma mark - Login相关
- (void)setUpLoginButton
{
    UIView *loginView = [UIView new];
    [self.view addSubview:loginView];
    [loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inputView.mas_bottom);
        make.left.right.equalTo(self.inputView);
        make.height.equalTo(@(1000));
    }];
    
//    UIButton *loginButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [loginView addSubview:loginButton2];
//    loginButton2.frame = CGRectMake(120,150, 150, 150);
//    loginButton2.backgroundColor = [UIColor redColor];
//    /** 点击了 登录 */
//    [loginButton2 addTarget:self action:@selector(loginBtnSender2:) forControlEvents:UIControlEventTouchDown];
    
    /** 登录 按钮 */
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginView addSubview:loginButton];
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginButton.superview);
        make.left.equalTo(@(28));
        make.right.equalTo(@(-28));
        make.height.equalTo(@(49));
        make.height.equalTo(@(44));
    }];
    
//    loginButton.acceptEventTime = 1;
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSForegroundColorAttributeName] = [UIColor whiteColor];
    attributes[NSFontAttributeName] = [UIFont systemFontOfSize:18];
    
    NSAttributedString *attributedString = [[NSAttributedString alloc]initWithString:@"立即登录" attributes:attributes];
    
    [loginButton setAttributedTitle:attributedString forState:UIControlStateNormal];
    
//    [loginButton setBackgroundImage:[UIImage imageNamed:@"DL_IN"] forState:UIControlStateNormal];
    [loginButton setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"2196f3"]];
//    [loginButton setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"FB514D"]];
    loginButton.layer.cornerRadius = 25;
    loginButton.clipsToBounds = YES;
    
    /** 忘记密码 按钮 */
    UIButton *forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginView addSubview:forgetButton];
    [forgetButton setFont:[UIFont systemFontOfSize:12]];
    [forgetButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forgetButton setTitleColor:[UIColor hx_colorWithHexRGBAString:@"757575"] forState:UIControlStateNormal];
    [forgetButton sizeToFit];
    [forgetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginButton.mas_bottom).offset(21);
        make.left.equalTo(@(31));
    }];
    
    /** 注册账号 按钮 */
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginView addSubview:registerButton];
    [registerButton setFont:[UIFont systemFontOfSize:12]];
    [registerButton setTitle:@"注册账号" forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor hx_colorWithHexRGBAString:@"757575"] forState:UIControlStateNormal];
    [registerButton sizeToFit];
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginButton.mas_bottom).offset(21);
        make.right.equalTo(@(-31));
    }];
    

    /** 点击了 注册 */
    [registerButton addTarget:self action:@selector(pushRegisterVC:) forControlEvents:UIControlEventTouchDown];
    
    /** 点击了 忘记密码 */
    [forgetButton addTarget:self action:@selector(pushpasswordServeVC:) forControlEvents:UIControlEventTouchDown];
    
    /** 点击了 登录 */
    [loginButton addTarget:self action:@selector(loginBtnSender:) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - 跳转注册界面
- (void)pushRegisterVC:(UIButton *)btn
{
    registerNavVC *NAVvc = [[UIStoryboard storyboardWithName:@"registerVC" bundle:nil]instantiateInitialViewController];
    
    registerFirstVC *vc = NAVvc.childViewControllers[0];
    
    vc.loginVC = self;
    
    [self presentViewController:NAVvc animated:YES completion:^{
        
    }];
}

#pragma mark - 跳转注册界面
- (void)pushpasswordServeVC:(UIButton *)btn
{
    passwordServeVC *NAVvc = [[UIStoryboard storyboardWithName:@"passwordServeVC" bundle:nil]instantiateInitialViewController];
    
    passwordServeVC *vc = NAVvc.childViewControllers[0];
    
    vc.loginVC = self;
    
    [self presentViewController:NAVvc animated:YES completion:^{
        
    }];
}

#pragma mark - 点击了游客登录
- (void)freeBtnLogin:(UIButton *)btn{
    [[HttpManager shareManager] netStatus:^(AFNetworkReachabilityStatus status) {
        if(status == AFNetworkReachabilityStatusReachableViaWWAN || status ==AFNetworkReachabilityStatusReachableViaWiFi){
            NSString *account = [NSString stringWithString:self.usernameTF.text];
            NSString *password = [NSString stringWithString:self.passwordTF.text];
            
            account = @"13322223333";
            password = @"123456";
            
            if (account.length > 0 && password.length > 0) {
                userInfo = [[UserInfo alloc]init];
                userInfo.account = account;
                userInfo.password = password;
                
                [self JMAnimationButtonDidStartAnimation:nil];
            }
            
            
        }else{
            [Toast makeShowCommen:@"您的网络  " ShowHighlight:@"出现问题" HowLong:0.8];
            return ;
        }
    }];

}

//- (void)loginBtnSender2:(UIButton *)btn{
//    [self loginBtnSender:nil];
//}

#pragma mark - 点击了登录按钮
- (void)loginBtnSender:(UIButton *)btn{
    
    [self.view endEditing:YES];
    
    [[HttpManager shareManager] netStatus:^(AFNetworkReachabilityStatus status) {
        if(status == AFNetworkReachabilityStatusReachableViaWWAN || status ==AFNetworkReachabilityStatusReachableViaWiFi){
            NSString *account = [NSString stringWithString:self.usernameTF.text];
            NSString *password = [NSString stringWithString:self.passwordTF.text];
            
            if (account.length > 0 && password.length > 0) {
                userInfo = [[UserInfo alloc]init];
                userInfo.account = account;
                userInfo.password = password;
                
                AppDelegate *appD = (AppDelegate*)[UIApplication sharedApplication].delegate;

                
                userInfo.imei = appD.UDID;
                
                [self JMAnimationButtonDidStartAnimation:nil];
            }
            
            if (account.length == 0) {
//                [Toast makeShowCommen:@"请输入账号" ShowHighlight:@"" HowLong:0.8];
                [SVProgressHUD showInfoWithStatus:@"请输入账号"];
                return ;
            }
            
            if (password.length == 0) {
                [SVProgressHUD showInfoWithStatus:@"请输入密码"];
//                [Toast makeShowCommen:@"请输入密码" ShowHighlight:@"" HowLong:0.8];
                return ;
            }
            
        }else{
//            [Toast makeShowCommen:@"您的网络  " ShowHighlight:@"出现问题" HowLong:0.8];
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

            return ;
        }
    }];
}


#pragma mark JMAnimationButtonDelegate
-(void)JMAnimationButtonDidStartAnimation:(JMAnimationButton *)JMAnimationButton{
    NSLog(@"start");
    
    if (ishitFreeBtn) {
        [SVProgressHUD showWithStatus:@"正在加载数据"];
    }else{
        [SVProgressHUD showWithStatus:@"正在登录..."];
    }
    
    
    self.isLoginblock = YES;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (self.isLoginblock) {
            [SVProgressHUD showInfoWithStatus:@"请重试"];
        }
    });
    
    /** 登录环信 */
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"password"] = userInfo.account;
    parameters[@"username"] = userInfo.password;
    [loginVM loginWithUserInfo:userInfo];
    __weak LoginVC *wself = self;
    __block typeof (userInfo) wuserInfo = userInfo;
    loginVM.jumpToTab = ^(int state,NSString *info){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (state == 1) {
                NSString *username = [NSString stringWithFormat:@"member_%@",wuserInfo._id];
                EMError *error = [[EMClient sharedClient] loginWithUsername:username password:@"123456"];
                if (!error) {
                    GLLog(@"登录成功");
                }
                
                // 登录成功上传版本/** 禁用提示版本更新 */
//                [JZBcheckVersion upVersion];
                
                NSUserDefaults *defautls = [NSUserDefaults standardUserDefaults];
                [defautls setBool:NO forKey:@"notAutoLogin"];

                
                ishitFreeBtn = NO;
                /** 开始定位 */
                //[wself setupLocation];

                /** 登录成功 获取环信好友数据 */
                [[HXDataHelper new]loadHXDataWithComplete:nil];
                success = 1;
//                [wself.loginView.button1 stopAnimation];
                [SVProgressHUD dismiss];
                wself.isLoginblock = NO;
                [wself JMAnimationButtonWillFinishAnimation:nil];
            }else if(state == 0){
//                [wself.loginView.button1 stopAnimation];
//                [SVProgressHUD showInfoWithStatus:@"请重试"];
                wself.isLoginblock = NO;
                
                [SVProgressHUD dismiss];
                
                [UIView bch_showWithTitle:@"登录失败" message:info buttonTitles:@[@"确定"] callback:^(id sender, NSUInteger buttonIndex) {
                    
                }];
                
                /** 用户名长度必须是16个字符 */
                
//                [Toast makeShowCommen:info ShowHighlight:@"" HowLong:1.5];
            }else{
//                [wself.loginView.button1 stopAnimation];
                [SVProgressHUD showInfoWithStatus:@"请重试"];
//                wself.isLoginblock = NO;
//                [Toast makeShowCommen:@"您的网络  " ShowHighlight:@"出现问题" HowLong:1.5];
            }
        });
    };
}

-(void)JMAnimationButtonDidFinishAnimation:(JMAnimationButton *)JMAnimationButton{
    NSLog(@"stop");
}

-(void)JMAnimationButtonWillFinishAnimation:(JMAnimationButton *)JMAnimationButton{
//    if (JMAnimationButton == self.loginView.button1) {
//        if (success) {
    
    self.navigationController.navigationBar.hidden = YES;
    
    HomeTabBarVC *tabVC;
    if ([ZJBHelp getInstance].homeTabBarVC) {
        MYRootVC *vc = self.navigationController.viewControllers[0];
        if (vc) {
            if ([vc isKindOfClass:[LoginVC class]]) {
                tabVC = [[HomeTabBarVC alloc]init];
                
                if (self.isFirstLogin) {
                    tabVC.selectedIndex = 3;
                }else {
                    tabVC.selectedIndex = 0;
                }
                
                [self.navigationController pushViewController:tabVC animated:YES];
            }else{
                [self.navigationController popToViewController:vc animated:YES];
            }
        }else{
            tabVC = [[HomeTabBarVC alloc]init];
            tabVC.selectedIndex = 3;
            [self.navigationController pushViewController:tabVC animated:YES];
        }
        
    }else{
        tabVC = [[HomeTabBarVC alloc]init];
        tabVC.selectedIndex = 3;
        [self.navigationController pushViewController:tabVC animated:YES];
    }
    
    [SVProgressHUD dismiss];
    self.isLoginblock = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [SVProgressHUD showSuccessWithStatus:@"登陆成功，增加帮币 +2"];
        AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        
        if (appDelegate.checkpay) {
            [Toast makeShowCommen:@"欢迎," ShowHighlight:@"登陆成功" HowLong:0.8];
        }
        
    });
    
//        }
//    }
}

-(void)dealloc{
    
    loginVM = nil;
    userInfo = nil;
}

- (void)putUserLocation:(CLPlacemark *)pl1
{
    
    if (!userInfo.token) return;
    
    if (!pl1) {
        return ;
    }else if (!pl1.administrativeArea) {
        return ;
    }else if (!pl1.locality) {
        return ;
    }
    
    loginVM.users.address = pl1.locality;
    
    NSUserDefaults *udefaults = [NSUserDefaults standardUserDefaults];
    
    [udefaults setObject:pl1.administrativeArea forKey:@"MyNowProvince"];
    [udefaults setObject:pl1.locality forKey:@"MyNowCity"];
    
    NSString *district = pl1.subLocality ? pl1.subLocality : @"未定位";
    NSString *community = pl1.thoroughfare ? pl1.thoroughfare : @"未定位";
    NSString *address = pl1.name ? pl1.name : @"未定位";

    
    NSDictionary *parameters = @{
                                 @"access_token":userInfo.token,
                                     @"lng":[NSString stringWithFormat:@"%f",pl1.location.coordinate.longitude],
                                     @"lat":[NSString stringWithFormat:@"%f",pl1.location.coordinate.latitude],
                                     @"province":pl1.administrativeArea,
                                     @"city":pl1.locality,
                                     @"district":district,
                                     @"community":community,
                                     @"address":address
                                 
                                     };
    
    /** 上传位置 */
    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/User/update_address"] parameters:parameters success:^(id json) {
        if ([json[@"state"] isEqual:@(1)]) {
//            [SVProgressHUD showSuccessWithStatus:@"定位成功啦"];
            NSUserDefaults *udefaults = [NSUserDefaults standardUserDefaults];
            
            [udefaults setObject:pl1.administrativeArea forKey:@"MyNowProvince"];
            [udefaults setObject:pl1.locality forKey:@"MyNowCity"];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 开始定位
- (void)setupLocation
{
    [self.INTULlocationM requestLocationWithDesiredAccuracy:INTULocationAccuracyCity timeout:8 delayUntilAuthorized:YES block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
        if (status == INTULocationStatusSuccess) {
            
            self.status_test = status;
            
            //                NSLog(@"%ld",(long)status);
            
            [self.geoC reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                
                CLPlacemark *pl1 = [placemarks lastObject];
                CLPlacemark *pl2 = [placemarks firstObject];
                
                self.addressL.text = pl1.name;
                
                self.addressL_first.text = pl2.name;
                
                /** 存储的值 */
                //                self.addressLabel.text = [NSString stringWithFormat:@"%@%@",pl1.addressDictionary[@"State"],pl1.addressDictionary[@"City"]];
                
                NSString *location_str = [NSString stringWithFormat:@"%@%@",pl1.addressDictionary[@"State"],pl1.addressDictionary[@"City"]];
                if (!pl1) {
//                    location_str = @"尚未定位";
                    location_str = @"";
                    
                    __weak __typeof__(self) weakSelf = self;
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [weakSelf setupLocation];
                    });
                    
//                    [SVProgressHUD showInfoWithStatus:location_str];
                }else {
//                    [SVProgressHUD showSuccessWithStatus:location_str];
                    
                }
                
                /** 上传用户位置 */
                [self putUserLocation:pl1];
                
                // 全局 定位 变量值
                AppDelegate *appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
                appD.userCurrentLocal = pl1.locality;
                
//                SixWdRootVC *vc = [SixWdRootVC shareSixWdRootVC];
//                [vc.addressButton setTitle:pl1.locality forState:UIControlStateNormal];
                
                /** 给位置cell的label赋值 */
//                                self.users.add = self.addressL.text;
//                                if (self.users.address) {
//                                    self.updateAddress(self.addressLabel.text);
//                                }
                
                //                    self.numAddressL.text = [NSString stringWithFormat:@"你可能在的位置有%zd个--%zd",placemarks.count,self.status_test];
            }];
        }else {
            
//            [SVProgressHUD showErrorWithStatus:@"请检查定位权限,或者网络"];
        }
    }];
}

- (INTULocationManager *)INTULlocationM
{
    if (_INTULlocationM == nil) {
        _INTULlocationM = [INTULocationManager sharedInstance];
    }
    return _INTULlocationM;
}

- (CLGeocoder *)geoC
{
    if (_geoC == nil) {
        _geoC = [[CLGeocoder alloc] init];
    }
    return _geoC;
    
}




@end
