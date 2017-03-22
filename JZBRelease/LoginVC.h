//
//  LoginVC.h
//  JZBRelease
//
//  Created by zjapple on 16/5/17.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginVC : UIViewController

- (void)loginBtnSender;

/** usernameTF */
@property (nonatomic, weak) UITextField *usernameTF;
/** passwordTF */
@property (nonatomic, weak) UITextField *passwordTF;

/** isClearPassword */
@property (nonatomic, assign) BOOL isClearPassword;
/** isAutoLogin */
@property (nonatomic, assign) BOOL isFirstLogin;

@end
