//
//  SignUpPopView.m
//  JZBRelease
//
//  Created by zjapple on 16/9/17.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "SignUpPopView.h"

@interface SignUpPopView ()

@property (weak, nonatomic) IBOutlet UILabel *payScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *stillScoreLabel;


@end

@implementation SignUpPopView

+ (instancetype)signUpPopView
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setMinimumDismissTimeInterval:1.5];
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]firstObject];
}

- (void)updateData
{
    self.payScoreLabel.text = [NSString stringWithFormat:@"使用 %@ 帮币",self.payScore];
    self.stillScoreLabel.text = self.stillScore;
}

/** 关闭窗口 */
- (IBAction)closeWindow:(UIButton *)sender {
    
    if (self.clickCloseWindow) {
        self.clickCloseWindow();
    }
    [self removeFromSuperview];
}

/** 报名 */
- (IBAction)SignUp:(UIButton *)sender {
    
    NSDictionary *parameters = @{
                                 @"access_token":[[LoginVM getInstance]readLocal].token,
                                 @"class_id":self.class_id
                                 };
    
    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/Study/pay"] parameters:parameters success:^(id json) {
    
    if ([json[@"state"] isEqual:@(0)]) {
        [SVProgressHUD showInfoWithStatus:json[@"info"]];
    }else {
        
        if (self.passToLive) {
            self.passToLive();
        }
    }
        [self closeWindow:nil];
        
        [SVProgressHUD showInfoWithStatus:json[@"info"]];
    
//        NSLog(@"TTT--json%@",json);
    } failure:^(NSError *error) {
        
    }];
    
}

/** 积分充值 */
- (IBAction)AddScore:(UIButton *)sender {
    
    if (self.clickPayUp) {
        self.clickPayUp();
    }
    
}

@end
