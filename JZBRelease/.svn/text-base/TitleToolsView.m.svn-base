//
//  TitleToolsView.m
//  JZBRelease
//
//  Created by cl z on 16/8/24.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "TitleToolsView.h"

@interface TitleToolsView(){
    UIFont *selectFont;
    UIFont *notSelectFont;
    UIView *baseLineView;
    int length;
    NSMutableArray *btnAry;
}

@end

@implementation TitleToolsView

-(instancetype)initWithTitleAry:(NSArray *)titleAry
                 DefaultSelectIndex:(NSInteger)selectIndex
                   SelectTitleColor:(UIColor *)selectTitleColor
                NotSelectTitleColor:(UIColor *)notSelectTitleColor
                    SelectTitleFont:(UIFont *)selectTitleFont
             NotSelectTitleFont:(UIFont *)notSelectTitleFont{
    selectFont = selectTitleFont;
    notSelectFont = notSelectTitleFont;
    btnAry = [[NSMutableArray alloc]init];
    self = [super initWithFrame:CGRectMake(0, 0, 60 * titleAry.count, 44)];
    if (self) {
        for (int i = 0; i < titleAry.count; i ++) {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i * 60, 0, 60, 44)];
            [btn setBackgroundColor:[UIColor clearColor]];
            [btn setTitle:[titleAry objectAtIndex:i] forState:UIControlStateNormal];
            [btn setTitleColor:selectTitleColor forState:UIControlStateSelected];
            [btn setTitleColor:notSelectTitleColor forState:UIControlStateNormal];
            if (i == selectIndex) {
                [btn setSelected:YES];
                [btn.titleLabel setFont:selectTitleFont];
                self.preBtn = btn;
            }else{
                [btn.titleLabel setFont:notSelectTitleFont];
            }
            btn.tag = i;
            [btn addTarget:self action:@selector(btnActionSender:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            [btnAry addObject:btn];
        }
        if (titleAry.count != 1) {
            NSDictionary *titleLengthAttrs = @{NSFontAttributeName:selectTitleFont};
            length = [[titleAry objectAtIndex:0] sizeWithAttributes:titleLengthAttrs].width + 10;
            baseLineView = [[UIView alloc]initWithFrame:CGRectMake((60 - length) / 2 + selectIndex * 60, 44 - 3, length, 3)];
            baseLineView.layer.cornerRadius = 1;
            [baseLineView setBackgroundColor:selectTitleColor];
            [self addSubview:baseLineView];
        }
    }
    return self;
}

-(void)btnActionSender:(UIButton *)btn{
    if (self.preBtn == btn) {
        return;
    }
    [self.preBtn setSelected:NO];
    [btn setSelected:YES];
    if (self.returnAction) {
        self.returnAction(btn.tag);
    }
    [UIView animateWithDuration:0.3 animations:^{
        [self.preBtn.titleLabel setFont:notSelectFont];
        [btn.titleLabel setFont:selectFont];
        [baseLineView setFrame:CGRectMake((60 - length) / 2 + btn.tag * 60, 44 - 3, length, 3)];
    } completion:^(BOOL finished) {
        
        self.preBtn = btn;
    }];
}

- (void)updateState:(NSInteger)index{
    [self.preBtn setSelected:NO];
    if (btnAry.count <= index) {
        return;
    }
    UIButton *btn = [btnAry objectAtIndex:index];
    [btn setSelected:YES];
    [UIView animateWithDuration:0.3 animations:^{
        [self.preBtn.titleLabel setFont:notSelectFont];
        [btn.titleLabel setFont:selectFont];
        [baseLineView setFrame:CGRectMake((60 - length) / 2 + btn.tag * 60, 44 - 3, length, 3)];
    } completion:^(BOOL finished) {
        self.preBtn = btn;
    }];

}

+ (TitleToolsView *)getInstanceWithTitleAry:(NSArray *)titleAry
                         DefaultSelectIndex:(NSInteger)selectIndex
                           SelectTitleColor:(UIColor *)selectTitleColor
                        NotSelectTitleColor:(UIColor *)notSelectTitleColor
                            SelectTitleFont:(UIFont *)selectTitleFont
                         NotSelectTitleFont:(UIFont *)notSelectTitleFont{
    
    TitleToolsView *view = [[TitleToolsView alloc]initWithTitleAry:titleAry DefaultSelectIndex:selectIndex SelectTitleColor:selectTitleColor NotSelectTitleColor:notSelectTitleColor SelectTitleFont:selectTitleFont NotSelectTitleFont:notSelectTitleFont];
    return view;
}

@end
