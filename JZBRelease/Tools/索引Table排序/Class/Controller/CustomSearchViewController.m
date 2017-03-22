//
//  CustomSearchViewController.m
//  剧能玩2.1
//
//  Created by 大兵布莱恩特  on 15/11/11.
//  Copyright © 2015年 大兵布莱恩特 . All rights reserved.
//

#import "CustomSearchViewController.h"

@interface CustomSearchViewController ()
@property (nonatomic,strong) UIView *navBar;

@end

@implementation CustomSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.navBar];
    
}
-  (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (UIView*)navBar
{
    if (!_navBar) {
        _navBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, GLScreenW, 64)];
        _navBar.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"222222"];//GLColor(51, 51, 51)
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GLScreenW, 64)];
        view.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"222222"];
        view.alpha = 0.85;
        [_navBar addSubview:view];
        
        // 标题
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(80, 28, GLScreenW-160, 25)];
        label.textColor = [UIColor whiteColor];
        label.font      = [UIFont systemFontOfSize:17];
        label.textAlignment = NSTextAlignmentCenter;
        label.text      = @"推荐人搜索";
        [_navBar addSubview:label];
        // 返回按钮
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [backBtn setTitle:@"返回" forState:UIControlStateNormal];
        
        [backBtn setImage:[UIImage imageNamed:@"DL_light_ARROW"] forState:UIControlStateNormal];
        
        [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [backBtn setFrame:CGRectMake(5, 26, 40, 30)];
        [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [_navBar addSubview:backBtn];
    }
    
    return _navBar;
}
- (void)back
{
    __weak typeof(self)weakSelf = self;
        [self dismissViewControllerAnimated:YES completion:nil];
        self.searchBar.text = @"";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([weakSelf.delegateCustom respondsToSelector:@selector(searchControllerBackButtonClick:)]) {
                [weakSelf.delegateCustom searchControllerBackButtonClick:weakSelf];
            }
        });
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


@end
