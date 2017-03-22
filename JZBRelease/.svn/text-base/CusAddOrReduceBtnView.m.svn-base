//
//  CusAddOrReduceBtnView.m
//  JZBRelease
//
//  Created by cl z on 16/9/5.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "CusAddOrReduceBtnView.h"
#import "Defaults.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define BTNWIDTH 60

@interface CusAddOrReduceBtnView(){
    NSInteger pre;
}


@property(nonatomic, strong) UIImageView *baseView;

@end

@implementation CusAddOrReduceBtnView

- (instancetype)initWithDataAry:(NSMutableArray *) ary{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.dataAry = ary;
        
    }
    return self;
}


+ (instancetype)cusAddOrReduceBtnView:(NSMutableArray *) dataAry{
    CusAddOrReduceBtnView *view = [[CusAddOrReduceBtnView alloc]initWithDataAry:dataAry];
    return view;
}

- (void)initAllViews{
    [self addSubview:self.addBtn];
    if (60 * self.dataAry.count > self.scrollView.frame.size.width) {
        self.scrollView.contentSize = CGSizeMake(60 * self.dataAry.count,0);
    }else{
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width,0);
    }
    
    [self addSubview:self.scrollView];
    pre = 0;
    for (int i = 0; i < self.dataAry.count; i ++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i * 60, 0, 60, self.frame.size.height)];
        [btn setTitle:[self.dataAry objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:[HXColor hx_colorWithHexRGBAString:@"#717171"] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        btn.tag = i;
        [self.scrollView addSubview:btn];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }

    UIView *intevalView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 0.8, self.frame.size.width, 0.8)];
    [intevalView setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"bdbdbd"]];
    [self addSubview:intevalView];
    
    self.baseView = [[UIImageView alloc]initWithFrame:CGRectMake((60 - 30) / 2, self.frame.size.height - 3, 30, 3)];
    [self.baseView setImage:[UIImage imageNamed:@"WD_choose_BULEline"]];
    [self.scrollView addSubview:self.baseView];
    
    
}


-(void) btnAction:(UIButton *)btn{
    if (btn.tag == pre) {
        return;
    }
    [UIView animateWithDuration:0.25 animations:^{
        [self.baseView setFrame:CGRectMake(btn.tag * 60 + (60 - 30) / 2,self.frame.size.height - 3, 30, 3)];
    }];
    if (self.returnBlock) {
        self.returnBlock(btn.tag);
    }
    pre = btn.tag;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame: CGRectMake(0, 0, self.frame.size.width - 30, self.frame.size.height)];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.pagingEnabled = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

- (void) addBtnAction{
    if (self.returnBlock) {
        self.returnBlock(-1);
    }
}

- (UIButton *)addBtn{
    if (!_addBtn) {
        _addBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width - 30, 0, 30, self.frame.size.height)];
        [_addBtn setImage:[UIImage imageNamed:@"NEWS_release-"] forState:UIControlStateNormal];
        [_addBtn setBackgroundColor:[UIColor whiteColor]];
        //[_addBtn addTarget:self action:@selector(addBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}

@end
