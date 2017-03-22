//
//  JoinUsToxieYiView.m
//  JZBRelease
//
//  Created by Apple on 16/11/8.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "JoinUsToxieYiView.h"

@implementation JoinUsToxieYiView

+ (instancetype)shareJoinUsToxieYiView
{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]firstObject];
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.contentView.layer.cornerRadius = 10;
    self.contentView.clipsToBounds = YES;
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:self.contentView.text];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:8];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [self.contentView.text length])];
    [self.contentView setAttributedText:attributedString1];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.contentView setContentOffset:CGPointMake(0, 0) animated:YES];
    });
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}
- (IBAction)close:(UIButton *)sender {
    
    [self removeFromSuperview];
    
}

@end
