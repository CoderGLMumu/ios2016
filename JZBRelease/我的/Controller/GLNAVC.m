//
//  GLNAVC.m
//  JZBRelease
//
//  Created by zjapple on 16/8/10.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "GLNAVC.h"
#import "Defaults.h"
#import "Masonry.h"
#import "XBVideoAndVoiceVC.h"
#import "LiveVideoViewController.h"
#import "NewWisdomListVC.h"
#import "InfomationDetailVC.h"

@interface GLNAVC ()

@end



@implementation GLNAVC

+ (void)load
{
    /** 设置UINavigationBar */
    UINavigationBar *bar = [UINavigationBar appearance];
    // 设置背景
    //[bar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
//    [bar setBackgroundImage:[[ZJBHelp getInstance]buttonImageFromColor:[ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Navigation_Color_new" WithKind:XMLTypeColors]] WithFrame:CGRectMake(0, 0, 20, 20)] forBarMetrics:UIBarMetricsDefault];
    
    bar.barStyle = UIBarStyleBlackOpaque;
    
//    bar.barTintColor = [UIColor hx_colorWithHexRGBAString:@"1976d2"];
    bar.barTintColor = [UIColor hx_colorWithHexRGBAString:@"222222"];
    
//    [bar setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"1976d2"]];
    //[bar setBackgroundColor:[ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Navigation_Color_new" WithKind:XMLTypeColors]]];
    // 设置标题文字属性
    NSMutableDictionary *barAttrs = [NSMutableDictionary dictionary];
    barAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:17];
    barAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [bar setTitleTextAttributes:barAttrs];
    
    /** 设置UIBarButtonItem */
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    
    // UIControlStateNormal
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor hx_colorWithHexRGBAString:@"ffffff"];
    normalAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:17];
    [item setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];

    // UIControlStateDisabled
    NSMutableDictionary *disabledAttrs = [NSMutableDictionary dictionary];
    disabledAttrs[NSForegroundColorAttributeName] = [UIColor hx_colorWithHexRGBAString:@"ffffff"];
    [item setTitleTextAttributes:disabledAttrs forState:UIControlStateDisabled];
    
//    UIBarButtonItem *barItem = [UIBarButtonItem appearance];
//    /** 使用Item设置返回按钮文字为主偏移量 */
//    [barItem setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -64) forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

/**
 * 拦截所有push进来的子控制器
 * @param viewController 每一次push进来的子控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //    if (不是第一个push进来的子控制器) {
    if (self.childViewControllers.count >= 1) {
        
        
        if ([viewController isKindOfClass:[InfomationDetailVC class]]) {
            [self configNavWeb:viewController];
        }else{
            // 左上角的返回
            [self configNav:viewController];
        }
        
        viewController.hidesBottomBarWhenPushed = YES; // 隐藏底部的工具条
    }
    
    // 设置子控制器的颜色
    
    // super的push方法一定要写到最后面
    // 一旦调用super的pushViewController方法,就会创建子控制器viewController的view
    // 也就会调用viewController的viewDidLoad方法

//    [super pushViewController:viewController animated:animated];
    if (!viewController.view.superview) {
        [super pushViewController:viewController animated:animated];
    }
}

#pragma mark - 返回按钮
-(void)configNav:(UIViewController *)vc
{
    //11 20
//    UIView *backView = [[UIView alloc] init];
    
//    [backView addSubview:backImageView];
    
//    UILabel *backLabel = [UILabel createLabelWithFrame:CGRectMake(11 + 5,(35-20)/2, 40, 20) Font:17 Text:@"返回" andLCR:0 andColor:[ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Navigation_Color" WithKind:XMLTypeColors]]];
//    [backView addSubview:backLabel];
//    UIControl *back = [[UIControl alloc] initWithFrame:backView.bounds];
//    [back addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
//    [backView addSubview:back];
    
//    UIImageView *backImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ZCCG_NAV_ARROW"]];
//    backImageView.userInteractionEnabled = YES;
//    
//    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:backImageView];
//    vc.navigationItem.leftBarButtonItem.width = -16;
//    vc.navigationItem.leftBarButtonItem = leftBtnItem;
//    vc.navigationItem.leftBarButtonItem.width = -16;
//    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backAction)];
//    
//    [backImageView addGestureRecognizer:tap];
    
//    UIButton* back = [UIButton buttonWithType:UIButtonTypeCustom];
//    [back setImage:[UIImage imageNamed:@"ZCCG_NAV_ARROW"] forState:UIControlStateNormal];
//    back.frame = CGRectMake(0, 0, 20, 20);
//    [back setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 0)]; // 向左边拉伸
//    
//    [back addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc] initWithCustomView:back];
//    vc.navigationItem.leftBarButtonItems = @[leftItem];
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 11 + 5 + 40, 35)];
    UIImageView *backImageView = [UIImageView createImageViewWithFrame:CGRectMake(10, (35-20)/2, 20, 20) ImageName:@"DL_light_ARROW"];
    backImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backAction)];
    [backImageView addGestureRecognizer:tap];
//    backImageView.userInteractionEnabled = YES;
    [backView addSubview:backImageView];
    //    UILabel *backLabel = [UILabel createLabelWithFrame:CGRectMake(11 + 5,(35-20)/2, 40, 20) Font:17 Text:@"返回" andLCR:0 andColor:[ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Navigation_Color" WithKind:XMLTypeColors]]];
    //    [backView addSubview:backLabel];
    UIControl *back = [[UIControl alloc] initWithFrame:backView.bounds];
    [back addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:back];

    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace   target:nil action:nil];
    /**
     width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和  边界间距为5pix，所以width设为-5时，间距正好调整为0；width为正数 时，正好相反，相当于往左移动width数值个像素
     */
    negativeSpacer.width = -12;
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
    vc.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, leftBtnItem, nil];
}


-(void)configNavWeb:(UIViewController *)vc
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 11 + 5 + 40, 35)];
    UIImageView *backImageView = [UIImageView createImageViewWithFrame:CGRectMake(10, (35-20)/2, 20, 20) ImageName:@"DL_light_ARROW"];
    backImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backActionWeb)];
    [backImageView addGestureRecognizer:tap];
    //    backImageView.userInteractionEnabled = YES;
    [backView addSubview:backImageView];
    //    UILabel *backLabel = [UILabel createLabelWithFrame:CGRectMake(11 + 5,(35-20)/2, 40, 20) Font:17 Text:@"返回" andLCR:0 andColor:[ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Navigation_Color" WithKind:XMLTypeColors]]];
    //    [backView addSubview:backLabel];
    UIControl *back = [[UIControl alloc] initWithFrame:backView.bounds];
    [back addTarget:self action:@selector(backActionWeb) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:back];
    
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace   target:nil action:nil];
    /**
     width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和  边界间距为5pix，所以width设为-5时，间距正好调整为0；width为正数 时，正好相反，相当于往左移动width数值个像素
     */
    negativeSpacer.width = -12;
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
    vc.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, leftBtnItem, nil];

}

#pragma mark - 返回按钮
- (void)backActionWeb{
    
    
    InfomationDetailVC *infoDVC = (InfomationDetailVC *)self.topViewController;
    GLLog(@"%@",infoDVC)
    [infoDVC backAction];
}

#pragma mark - 返回按钮
- (void)backAction{
    [self popViewControllerAnimated:YES];
    
    GLLog(@"backAction-topVC%@",self.topViewController);
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    NSLog(@"11121212121212");
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.tabBarController.tabBar.gly_y = GLScreenH - 49;
}

- (BOOL)shouldAutorotate
{
    GLLog(@"glnavrotate1%@",self.topViewController);
    GLLog(@"glnavrotate2%@",self.navigationController);
    GLLog(@"glnavrotate3%@",self.navigationController.topViewController);
    GLLog(@"glnavrotate4%@",self.childViewControllers);
    
    for (HomeTabBarVC *vc in self.childViewControllers) {
    
        if ([vc isKindOfClass:[HomeTabBarVC class]]) {
            UINavigationController *nav = (UINavigationController *)vc.viewControllers[0];
            GLLog(@"旋转测试 NO %@=-=-=%@",nav,nav.topViewController)
            if ([nav.topViewController isKindOfClass:[XBVideoAndVoiceVC class]] || [nav.topViewController isKindOfClass:[LiveVideoViewController class]]) {
                GLLog(@"旋转测试 YES %@=-=-=%@",nav,nav.topViewController)
                return nav.topViewController.shouldAutorotate;
            }
        }
    
        
    }
    
    
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}



@end
