//
//  registerSecVC.h
//  JZBRelease
//
//  Created by zjapple on 16/8/26.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LoginVC;

@interface registerSecVC : UIViewController

/** 登录控制器 */
@property (nonatomic, weak) LoginVC *loginVC;

/** 手机号 */
@property (nonatomic, strong) NSString *mobile;
/** 密码 */
@property (nonatomic, strong) NSString *password;
/** 验证密码 */
@property (nonatomic, strong) NSString *repassword;


@end
