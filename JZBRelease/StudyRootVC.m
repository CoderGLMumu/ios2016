//
//  StudyRootVC.m
//  JZBRelease
//
//  Created by cl z on 16/8/19.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "StudyRootVC.h"
#import "ZLCWebView.h"
#import "Defaults.h"
#import "GLNAVC.h"

@interface StudyRootVC ()<ZLCWebViewDelegate>{
    ZLCWebView *web;
    UIView *backView;
}

@end

@implementation StudyRootVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self configNav];
    backView.hidden = YES;
}

-(void)viewDidAppear:(BOOL)animated{
    web = [[ZLCWebView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    [self.view addSubview:web];
    NSString *path = [[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingString:[ValuesFromXML getValueWithName:@"Study_First_URL" WithKind:XMLTypeNetPort]] stringByReplacingOccurrencesOfString:@"%@" withString:[[LoginVM getInstance] readLocal].token];
    [web loadURLString:path];
    web.delegate = self;
 
}

-(void)configNav
{
    //11 20
    backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 11 + 5 + 40, 35)];
    UIImageView *backImageView = [UIImageView createImageViewWithFrame:CGRectMake(0, (35-20)/2, 20, 20) ImageName:@"DL_light_ARROW"];
    backImageView.userInteractionEnabled = YES;
    [backView addSubview:backImageView];
//    UILabel *backLabel = [UILabel createLabelWithFrame:CGRectMake(11 + 5,(35-20)/2, 40, 20) Font:17 Text:@"返回" andLCR:0 andColor:[ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Navigation_Color" WithKind:XMLTypeColors]]];
//    [backView addSubview:backLabel];
    UIControl *back = [[UIControl alloc] initWithFrame:backView.bounds];
    [back addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:back];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
}



- (void) backAction{
    if (web.wkWebView) {
        [web.wkWebView goBack];
    }else{
        [web.uiWebView goBack];
    }
}

- (void)zlcwebViewDidStartLoad:(ZLCWebView *)webview
{
    
    NSLog(@"页面开始加载");
}

- (void)zlcwebView:(ZLCWebView *)webview shouldStartLoadWithURL:(NSURL *)URL
{
    NSLog(@"截取到URL：%@",URL);
}
- (void)zlcwebView:(ZLCWebView *)webview didFinishLoadingURL:(NSURL *)URL
{
    if (web.wkWebView.backForwardList.backList.count == 0) {
        backView.hidden = YES;
        self.tabBarController.tabBar.hidden = NO;
    }else{
        backView.hidden = NO;
        self.tabBarController.tabBar.hidden = YES;
    }
    NSLog(@"页面加载完成");
    
}

- (void)zlcwebView:(ZLCWebView *)webview didFailToLoadURL:(NSURL *)URL error:(NSError *)error
{
    NSLog(@"加载出现错误");
}


@end
