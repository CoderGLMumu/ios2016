//
//  RewardAlertView.h
//  JZBRelease
//
//  Created by zjapple on 16/6/12.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LWTextStorage.h"
#import "UIPlaceHolderTextView.h"
@interface RewardAlertView : UIView

@property (nonatomic, strong)IBOutlet UIView *innerView;
@property (nonatomic, weak)UIViewController *parentVC;

@property (nonatomic, copy) void (^sendAction)(Clink_Type clink_type,NSString *howmuch);

@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIButton *oneBtn;
@property (weak, nonatomic) IBOutlet UIButton *twoBtn;
@property (weak, nonatomic) IBOutlet UIButton *threeBtn;
@property (weak, nonatomic) IBOutlet UIButton *fourBtn;
@property (weak, nonatomic) IBOutlet UIButton *fiveBtn;
@property (weak, nonatomic) IBOutlet UIButton *sixBtn;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property (weak, nonatomic) IBOutlet UITextView *giveSaysTextView;
@property (strong, nonatomic) UIPlaceHolderTextView *reGiveSaysTextView;

+ (instancetype)defaultPopupView;


@property (nonatomic ,assign )BOOL isfromLiveToPrese;

@end
