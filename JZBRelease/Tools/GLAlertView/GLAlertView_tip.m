//
//  GLAlertView_tip.m
//  JZBRelease
//
//  Created by Apple on 16/11/30.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "GLAlertView_tip.h"

@interface GLAlertView_tip ()

@end

@implementation GLAlertView_tip

+ (instancetype)glAlertView_tip
{
    
    
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]firstObject];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.layer.cornerRadius = 8;
    self.clipsToBounds = YES;
    
    
    
}

-(void)setTtitleView:(UILabel *)TtitleView
{
    _TtitleView = TtitleView;
    
    
    
}


- (IBAction)cancelButton:(UIButton *)sender {
    
    [self removeFromSuperview];
    
    
}

- (IBAction)EnterButton:(UIButton *)sender {
    
    if (self.enterButtonClick) {
        self.enterButtonClick();
    }
    
}




@end
