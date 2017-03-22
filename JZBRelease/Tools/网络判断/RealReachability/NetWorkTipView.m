//
//  NetWorkTipView.m
//  JZBRelease
//
//  Created by Apple on 17/1/13.
//  Copyright © 2017年 zjapple. All rights reserved.
//

#import "NetWorkTipView.h"
#import "Masonry.h"
#import "BCH_Alert.h"
#import "GLSaveTool.h"

@interface NetWorkTipView ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidth;

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;


@end

@implementation NetWorkTipView

- (void)awakeFromNib//(初始化完毕后调用) 建议在这个方法中进行xib后的初始化
{
    [super awakeFromNib];
    
    [UIView bch_showWithTitle:@"网络连接断开,建众帮的使用需要网络" message:@"是否进入网络设置" buttonTitles:@[@"设置",@"稍后"] callback:^(id sender, NSUInteger buttonIndex) {
        if (buttonIndex == 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root"]];
        }
    }];
    
    self.confirmButton.layer.cornerRadius = 12;
    self.confirmButton.clipsToBounds = YES;
    
    //建议在layoutSubviews里初始化frame
    [self setup]; //在awake之前还会调用initWithCoder这里xib转代码
}

+ (void)tipSetButton
{
    [SVProgressHUD showInfoWithStatus:@"你的网络可能不流畅,请检查后再试"];
//    [UIView bch_showWithTitle:@"你的网络可能不流畅" message:@"请检查后再试" buttonTitles:@[@"好的"] callback:^(id sender, NSUInteger buttonIndex) {
////        if (buttonIndex == 0) {
////            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root"]];
////        }
//    }];
}

- (void)setup
{
//    self.test.constant = 1000;
    
    self.contentViewWidth.constant = GLScreenW * 2.1;
    
    self.contentView.gls_size = CGSizeMake(GLScreenW * 2.1, GLScreenH);
    
    
    if ([[GLSaveTool objectForKey:@"NetWorkTipViewNum"] isEqualToString:@"1"]) {
        return;
    }

}

-(void)layoutSubviews
{
    
    [super layoutSubviews];
    
    self.confirmButton.glw_width = GLScreenW / 3;
    
    if ([[GLSaveTool objectForKey:@"NetWorkTipViewNum"] isEqualToString:@"1"]) {
        [self removeFromSuperview];
    }
    
}

- (IBAction)ActiveConButton:(UIButton *)sender {
    
    [GLSaveTool setObject:@"1" forKey:@"NetWorkTipViewNum"];
    
    [self removeFromSuperview];
    
}

//-(void)layoutSubviews
//{
//    [super layoutSubviews];
//    
//    self.contentView.gls_size = CGSizeMake(self.glw_width * 2.3, GLScreenH);
//    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(self);
//       make.top.equalTo(self);
//        make.bottom.equalTo(self);
//        make.trailing.equalTo(@(GLScreenW * 2.3));
//    }];
//    
//    self.scrollView.contentSize = CGSizeMake(1000, 0);
//}

+ (instancetype)netWorkTipView
{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]firstObject];
}
- (IBAction)CloseViewActive:(UIButton *)sender {
    
    [self removeFromSuperview];
}

@end
