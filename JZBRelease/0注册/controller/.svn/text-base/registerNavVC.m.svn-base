//
//  registerNavVC.m
//  JZBRelease
//
//  Created by zjapple on 16/8/26.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "registerNavVC.h"

@interface registerNavVC ()

@end

@implementation registerNavVC

- (BOOL)shouldAutorotate
{
    //    UINavigationController *nav = (UINavigationController *)self.viewControllers[0];
    //    GLLog(@"旋转测试 NO %@=-=-=%@",nav,nav.topViewController)
    //    if ([nav.topViewController isKindOfClass:[XBVideoAndVoiceVC class]] || [nav.topViewController isKindOfClass:[LiveVideoViewController class]]) {
    //        GLLog(@"旋转测试 YES %@=-=-=%@",nav,nav.topViewController)
    //        return nav.topViewController.shouldAutorotate;
    //    }
    
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configNavF:self.childViewControllers[0]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * 拦截所有push进来的子控制器
 * @param viewController 每一次push进来的子控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //    if (不是第一个push进来的子控制器) {
    if (self.childViewControllers.count >= 1) {
        // 左上角的返回
        [self configNav:viewController];
        
        viewController.hidesBottomBarWhenPushed = YES; // 隐藏底部的工具条
    }else{
        [self configNavF:viewController];
        
        viewController.hidesBottomBarWhenPushed = YES; // 隐藏底部的工具条
    }
    
    // 设置子控制器的颜色
    //    viewController.view.backgroundColor = XMGCommonBgColor;
    
    // super的push方法一定要写到最后面
    // 一旦调用super的pushViewController方法,就会创建子控制器viewController的view
    // 也就会调用viewController的viewDidLoad方法
    [super pushViewController:viewController animated:animated];
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
    
    UIButton* back = [UIButton buttonWithType:UIButtonTypeCustom];
    [back setImage:[UIImage imageNamed:@"ZCCG_NAV_ARROW"] forState:UIControlStateNormal];
    back.frame = CGRectMake(0, 0, 20, 20);
    [back setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 0)]; // 向左边拉伸
    
    [back addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    vc.navigationItem.leftBarButtonItems = @[leftItem];
    
}


#pragma mark - 返回按钮
-(void)configNavF:(UIViewController *)vc
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
    
    UIButton* back = [UIButton buttonWithType:UIButtonTypeCustom];
    [back setImage:[UIImage imageNamed:@"ZCCG_NAV_ARROW"] forState:UIControlStateNormal];
    back.frame = CGRectMake(0, 0, 20, 20);
    [back setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 0)]; // 向左边拉伸
    
    [back addTarget:self action:@selector(backActionF) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    vc.navigationItem.leftBarButtonItems = @[leftItem];
    
}

-(void) backAction{
    [self popViewControllerAnimated:YES];
}

-(void) backActionF{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
