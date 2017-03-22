//
//  GLActionPaopaoView.m
//  JZBRelease
//
//  Created by zjapple on 16/8/17.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "GLActionPaopaoView.h"

@interface GLActionPaopaoView ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userNameLabelConstraintWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chenWeiLabelConstraintWidth;


@end

@implementation GLActionPaopaoView

+ (instancetype)glActionPaopaoView
{
    GLActionPaopaoView *test = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]firstObject];
    
//    test.glw_width = 100;
    
    return test;
}

+ (instancetype)glActionPaopaoViewActivity
{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.glw_width * 0.5;
    self.avatarImageView.clipsToBounds = YES;
    
    
}

- (void)setUid:(NSString *)uid
{
    _uid = uid;
    if (self.paopaoViewWidth) {
        [self.nickNameLabel sizeToFit];
        self.userNameLabelConstraintWidth.constant = self.nickNameLabel.glw_width + 5;
        [self.chenHuLabel sizeToFit];
        self.chenWeiLabelConstraintWidth.constant = self.chenHuLabel.glw_width;
        if (self.chenHuLabel.frame.size.width < self.industryLabel.glw_width) {
            self.chenWeiLabelConstraintWidth.constant = self.chenHuLabel.glw_width ;
        }
        self.glw_width = self.nickNameLabel.glw_width + self.chenHuLabel.glw_width + 155;
        
        self.paopaoViewWidth(self.glw_width);
        
    }
}

- (void)pushDetailInfo:(GLActionPaopaoView *)cont
{
    self.paopaoViewClick(cont);
//    OtherPersonCentralVC *vc = [[OtherPersonCentralVC alloc]init];
//    Users *user = [[Users alloc]init];
//    user.uid = cont.uid;
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.nickNameLabel sizeToFit];
    self.userNameLabelConstraintWidth.constant = self.nickNameLabel.glw_width + 5;
    [self.chenHuLabel sizeToFit];
    self.chenWeiLabelConstraintWidth.constant = self.chenHuLabel.glw_width;
    if (self.chenHuLabel.frame.size.width < self.industryLabel.glw_width) {
        self.chenWeiLabelConstraintWidth.constant = self.chenHuLabel.glw_width ;
    }
    self.glw_width = self.nickNameLabel.glw_width + self.chenHuLabel.glw_width + 155;
    
}

- (IBAction)paopaoViewClick:(UIButton *)sender {
    self.paopaoViewClick(self);
}


@end
