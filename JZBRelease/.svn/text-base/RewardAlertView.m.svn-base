//
//  RewardAlertView.m
//  JZBRelease
//
//  Created by zjapple on 16/6/12.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "RewardAlertView.h"
#import "LewPopupViewAnimationSpring.h"

#import "IntegralDetailVC.h"

#import "AppDelegate.h"

#import "NotPushAddNavView.h"

@interface RewardAlertView ()
@property (weak, nonatomic) IBOutlet UIButton *addMoneyButton;

@end

@implementation RewardAlertView{
    NSString *howMuch;
    int preSelect;
    UIButton *preBtn;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self = [[[NSBundle mainBundle] loadNibNamed:@"RewardAlertView" owner:nil options:nil] lastObject];
        preBtn = self.oneBtn;
        preSelect = 1;
        self.titleView.layer.cornerRadius = 3.0;
        self.reGiveSaysTextView = [[UIPlaceHolderTextView alloc]init];
        self.reGiveSaysTextView.frame = self.giveSaysTextView.frame;
        self.reGiveSaysTextView.placeholder = @"知识是有价值的，感恩别人的智慧分享，让我们一起成长，打赏是一种态度！";
        self.giveSaysTextView.hidden = YES;
        self.reGiveSaysTextView.font = [UIFont systemFontOfSize:14];
        self.reGiveSaysTextView.layer.cornerRadius = 3.0;
        self.reGiveSaysTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.reGiveSaysTextView.layer.borderWidth = 0.5;
        [self addSubview:self.reGiveSaysTextView];
        
        self.oneBtn.layer.cornerRadius = 3.0;
        self.twoBtn.layer.cornerRadius = 3.0;
        self.threeBtn.layer.cornerRadius = 3.0;
        self.fourBtn.layer.cornerRadius = 3.0;
        self.fiveBtn.layer.cornerRadius = 3.0;
        self.sixBtn.layer.cornerRadius = 3.0;
        //_innerView.frame = frame;
        howMuch = @"1";
        self.layer.cornerRadius = 5.0;
        self.okBtn.layer.cornerRadius = 3.0;
        //[self addSubview:_innerView];
        
      //  AppDelegate *delegate = ((AppDelegate *)[[UIApplication sharedApplication] delegate]);
        
        //if (delegate.checkpay) {
            
            self.addMoneyButton.hidden = NO;
            
//        }else{
//            self.addMoneyButton.hidden = YES;
//        }
        
    }
    return self;
}


+ (instancetype)defaultPopupView{
    return [[RewardAlertView alloc]initWithFrame:CGRectMake(0, 0, 280, 250)];
}

- (IBAction)oneBtnSender:(id)sender {
    howMuch = ((UIButton *)sender).titleLabel.text;
    if (1 == preSelect) {
        return;
    }else{
        [((UIButton *)sender) setBackgroundImage:[UIImage imageNamed:@"bq_shangtk_bg"] forState:UIControlStateNormal];
        [preBtn setBackgroundImage:nil forState:UIControlStateNormal];
        preBtn = ((UIButton *)sender);
        preSelect = 1;
    }
}

- (IBAction)twoBtnSender:(id)sender {
    howMuch = ((UIButton *)sender).titleLabel.text;
    if (2 == preSelect) {
        return;
    }else{
        [((UIButton *)sender) setBackgroundImage:[UIImage imageNamed:@"bq_shangtk_bg"] forState:UIControlStateNormal];
        [preBtn setBackgroundImage:nil forState:UIControlStateNormal];
        preBtn = ((UIButton *)sender);
        preSelect = 2;
    }
}

- (IBAction)threeBtnSender:(id)sender {
    howMuch = ((UIButton *)sender).titleLabel.text;
    if (3 == preSelect) {
        return;
    }else{
        [((UIButton *)sender) setBackgroundImage:[UIImage imageNamed:@"bq_shangtk_bg"] forState:UIControlStateNormal];
        [preBtn setBackgroundImage:nil forState:UIControlStateNormal];
        preBtn = ((UIButton *)sender);
        preSelect = 3;
    }
}

- (IBAction)fourBtnSender:(id)sender {
    howMuch = ((UIButton *)sender).titleLabel.text;
    if (4 == preSelect) {
        return;
    }else{
        [((UIButton *)sender) setBackgroundImage:[UIImage imageNamed:@"bq_shangtk_bg"] forState:UIControlStateNormal];
        [preBtn setBackgroundImage:nil forState:UIControlStateNormal];
        preBtn = ((UIButton *)sender);
        preSelect = 4;
    }
}

- (IBAction)fiveBtnSender:(id)sender {
    howMuch = ((UIButton *)sender).titleLabel.text;
    if (5 == preSelect) {
        return;
    }else{
        [((UIButton *)sender) setBackgroundImage:[UIImage imageNamed:@"bq_shangtk_bg"] forState:UIControlStateNormal];
        [preBtn setBackgroundImage:nil forState:UIControlStateNormal];
        preBtn = ((UIButton *)sender);
        preSelect = 5;
    }
}

- (IBAction)sixBtnSender:(id)sender {
    howMuch = ((UIButton *)sender).titleLabel.text;
    if (6 == preSelect) {
        return;
    }else{
        [((UIButton *)sender) setBackgroundImage:[UIImage imageNamed:@"bq_shangtk_bg"] forState:UIControlStateNormal];
        [preBtn setBackgroundImage:nil forState:UIControlStateNormal];
        preBtn = ((UIButton *)sender);
        preSelect = 6;
    }
}

- (IBAction)cancleBtnSender:(id)sender {
    
}
- (IBAction)closeBtnSender:(id)sender {
    [_parentVC lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
}

- (IBAction)queryBtnSender:(id)sender {
    if (self.sendAction) {
        self.sendAction(Clink_Type_Two,nil);
    }
}

- (IBAction)rechargeBtnSender:(id)sender {
    [self.parentVC lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
    IntegralDetailVC *vc = [[UIStoryboard storyboardWithName:@"IntegralDetailVC" bundle:nil] instantiateInitialViewController];
    vc.bangbiCount = [LoginVM getInstance].users.money;
    
    [self.parentVC.navigationController pushViewController:vc animated:YES];
    
    
    if (self.isfromLiveToPrese) {
        IntegralDetailVC *vc = [[UIStoryboard storyboardWithName:@"IntegralDetailVC" bundle:nil] instantiateInitialViewController];
        vc.bangbiCount = [LoginVM getInstance].users.money;
        vc.isFromPreseVC = YES;
//        NotPushAddNavView *navView = [NotPushAddNavView new];
//        [vc.view addSubview:navView];
//        navView.frame = CGRectMake(0, 0, GLScreenW, 64);
        
        [self.parentVC presentViewController:vc animated:YES completion:^{
            
        }];
    }
    
}


- (IBAction)okBtnSender:(id)sender {

    //if ([self.balanceLabel.text integerValue] > [howMuch integerValue]) {

//    if ([self.balanceLabel.text integerValue] >= [howMuch integerValue]) {

        [_parentVC lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
        if (self.sendAction) {
            self.sendAction(Clink_Type_One,howMuch);
        }

   // }

//    }

    
}



@end
