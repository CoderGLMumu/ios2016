//
//  LoginView.m
//  JZBRelease
//
//  Created by zjapple on 16/6/17.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "LoginView.h"
#import "Defaults.h"

@implementation LoginView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 5, self.frame.size.width, 100)];
        [view1 setBackgroundColor:[UIColor whiteColor]];
        view1.layer.cornerRadius = 5;
        view1.alpha = 0.3;
        [self addSubview:view1];
        
        UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 5, self.frame.size.width, 100)];
        [view2 setBackgroundColor:[UIColor clearColor]];
        [self addSubview:view2];
        int width = frame.size.width;
        UIImageView *accountImageView = [UIImageView createImageViewWithFrame:CGRectMake(20, 12.5, 24, 24) ImageName:@"login_user"];
        [view2 addSubview:accountImageView];
        self.accountTF = [[UITextField alloc]initWithFrame:CGRectMake(20 + 10 + 24, 10, width - (2 * 20 + 15 + 24), 30)];
        self.accountTF.placeholder = @"请输入用户名";
        self.accountTF.font = [UIFont systemFontOfSize:15];
        [self.accountTF setTextColor:[UIColor whiteColor]];
        [self.accountTF setBorderStyle:UITextBorderStyleNone];
        self.accountTF.delegate = self;
        [self.accountTF setClearButtonMode:UITextFieldViewModeWhileEditing];
        [view2 addSubview:self.accountTF];
        UILabel *inteval = [[UILabel alloc]initWithFrame:CGRectMake(20, 50, width - 2 * 20, 0.5)];
        [inteval setBackgroundColor: [UIColor whiteColor]];
        inteval.alpha = .5;
        [view2 addSubview:inteval];
        UIImageView *passwordImageView = [UIImageView createImageViewWithFrame:CGRectMake(20, 50 + 12.5, 24, 24) ImageName:@"login_password"];
        [view2 addSubview:passwordImageView];
        self.passwordTF = [[UITextField alloc]initWithFrame:CGRectMake(20 + 10 + 24, 50 + 10, width - (2 * 20 + 15 + 24), 30)];
        self.passwordTF.placeholder = @"请输入密码";
        [self.passwordTF setBorderStyle:UITextBorderStyleNone];
        self.passwordTF.font = [UIFont systemFontOfSize:15];
        self.passwordTF.secureTextEntry = YES;
        [self.passwordTF setClearButtonMode:UITextFieldViewModeWhileEditing];
        [self.passwordTF setTextColor:[UIColor whiteColor]];
        self.passwordTF.delegate = self;
        [view2 addSubview:self.passwordTF];
        
//        UIButton *loginBtn = [UIButton createButtonWithFrame:CGRectMake(0, 130, width, 50) Image:nil Target:self Action:@selector(loginBtnSender) Title:@"登录" cornerRadius:3 borderColor:nil borderWidth:0];
//        [loginBtn setBackgroundImage:[UIImage imageNamed:@"navigationBG.png"] forState:UIControlStateNormal];
//        [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [self addSubview:loginBtn];
      //  loginBtn.acceptEventTime = 5;
        
        self.button1 = [JMAnimationButton buttonWithFrame:CGRectMake(0, 130, width, 40)];
        [self.button1 setTitle:@"登录" forState:UIControlStateNormal];
        [self.button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.button1 setBackgroundColor:[ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Navigation_Color" WithKind:XMLTypeColors]]];
        
        [self addSubview:self.button1];

        UIButton *forgetBtn = [[UIButton alloc]initWithFrame:CGRectMake(width - 60, 180 + 5, 60, 30)];
        [forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
        [forgetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [forgetBtn addTarget:self action:@selector(forgetBtnSender) forControlEvents:UIControlEventTouchUpInside];
        forgetBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:forgetBtn];
    }
    return self;
}

- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    
    //当用户使用自动更正功能，把输入的文字修改为推荐的文字时，就会调用这个方法。
    
    //这对于想要加入撤销选项的应用程序特别有用
    
    //可以跟踪字段内所做的最后一次修改，也可以对所有编辑做日志记录,用作审计用途。
    
    //要防止文字被改变可以返回NO
    
    //这个方法的参数中有一个NSRange对象，指明了被改变文字的位置，建议修改的文本也在其中
    
    
    
    return YES;  
    
}


-(void)loginBtnSender{
    if (self.passwordTF.text.length <=0 || self.accountTF.text.length <= 0) {
        [Toast makeShowCommen:@"" ShowHighlight:@"请输入用户名或密码" HowLong:1.2];
        return;
    }
    NSLog(@"%@",self.accountTF.text);
    NSLog(@"%@",self.passwordTF.text);
    if (self.returnAction) {
        self.returnAction(Clink_Type_One);
    }
}

-(void)forgetBtnSender{
    if (self.returnAction) {
        self.returnAction(Clink_Type_Two);
    }
}

@end
