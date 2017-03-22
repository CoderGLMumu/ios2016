//
//  PushToVideoPopView.m
//  JZBRelease
//
//  Created by zjapple on 16/9/21.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "PushToVideoPopView.h"

@interface PushToVideoPopView ()

//@property (weak, nonatomic) IBOutlet UILabel *payScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *stillScoreLabel;
@property (weak, nonatomic) IBOutlet UITextField *playScoreTF;


@end

@implementation PushToVideoPopView

+ (instancetype)pushToVideoPopView
{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]firstObject];
}

- (void)updateData
{
    self.playScoreTF.text = [NSString stringWithFormat:@"%@",self.payScore];
    self.stillScoreLabel.text = self.stillScore;
}

/** 关闭窗口 */
- (IBAction)closeWindow:(UIButton *)sender {
    
    if (self.clickCloseWindow) {
        self.clickCloseWindow();
    }
    [self removeFromSuperview];
}

/** 推送至点播 */
- (IBAction)SignUp:(UIButton *)sender {
    if (self.playScoreTF.text.length <=0) {
        [SVProgressHUD showInfoWithStatus:@"请输入课程价格"];
        return;
    }
    [SVProgressHUD showWithStatus:@"正在进行处理请稍后"];
    NSString *type;
    if ([self.type isEqualToString:@"3"]) {
        type = @"1";
    }else if ([self.type isEqualToString:@"4"]){
        type = @"2";
    }
    
    NSDictionary *parameters = @{
                                 @"access_token":[[LoginVM getInstance]readLocal].token,
                                 @"id":self.class_id,
                                 @"type":type,
                                 @"score":self.playScoreTF.text
                                 };
    
    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/Study/editClass"] parameters:parameters success:^(id json) {
        
        if ([json[@"state"] isEqual:@(0)]) {
            [SVProgressHUD showInfoWithStatus:json[@"info"]];
        }else {
            [SVProgressHUD showSuccessWithStatus:@"设置成功"];
            if (self.passToLive) {
                self.passToLive();
            }
        }
        [self closeWindow:nil];
        
        

    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"设置失败,请联系我们"];
    }];
    
}

/** 取消 */
- (IBAction)AddScore:(UIButton *)sender {
    
    [self closeWindow:nil];
    
}

@end
