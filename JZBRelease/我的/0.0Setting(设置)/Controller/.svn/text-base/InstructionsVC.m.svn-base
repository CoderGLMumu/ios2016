//
//  InstructionsVC.m
//  JZBRelease
//
//  Created by Apple on 16/12/29.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "InstructionsVC.h"
#import "GLNAVC.h"

@interface InstructionsVC ()<UIWebViewDelegate>

@property (weak, nonatomic) UIWebView *webView;

/** pageNum */
@property (nonatomic, assign) NSInteger pageNum;

@end

@implementation InstructionsVC

- (BOOL)shouldAutorotate
{
    
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"使用说明";
    
    self.pageNum = 0;
    
    UIWebView *webView = [UIWebView new];
    [self.view addSubview:webView];
    webView.frame = CGRectMake(0, 0, GLScreenW, GLScreenH);
    self.webView = webView;
    
    //设置代理
    self.webView.delegate = self;
    
    [self setupWebView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIButton *tipButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [tipButton1 setImage:[UIImage imageNamed:@"DL_light_ARROW"] forState:UIControlStateNormal];
//    [tipButton1 setTitle:@"fanhuo" forState:UIControlStateNormal];
    tipButton1.frame = CGRectMake(0, 0, 35, 35);
    
    // tipButton1.userInteractionEnabled = NO;
    
    [tipButton1 addTarget:self action:@selector(tipButton1Active:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = nil;
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace   target:nil action:nil];
    /**
     width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和  边界间距为5pix，所以width设为-5时，间距正好调整为0；width为正数 时，正好相反，相当于往左移动width数值个像素
     */
    negativeSpacer.width = -12;
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:tipButton1];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, leftBtnItem, nil];
}

- (void)tipButton1Active:(UIButton *)btn
{
    self.pageNum--;
    
    GLLog(@"%ld",(long)self.pageNum)
    
    if (!self.pageNum) {
        if (self.presentingViewController) {
            
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        if ([self.webView canGoBack]) {
            [self.webView goBack];
        }
    }
    self.pageNum--;
}


//- (void)viewWillDisappear:(BOOL)animated
//{
//    
//    
//    self.pageNum--;
//    GLLog(@"")
//    if (self.pageNum) {
//        
//    }
//    
//    [super viewWillDisappear:animated];
//    
//}

//加载网页
-(void)setupWebView
{
    NSURL *url = [NSURL URLWithString:@"https://bang.jianzhongbang.com/Bang/index.php/Share/Tips/lists"];
    
//    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com/"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:request];
    
//    self.webView.scrollView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    
}

#pragma mark --------------------
#pragma mark UIWebViewDelegate
//1
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"shouldStartLoadWithRequest--即将加载--%@",request.URL);
    return YES;
}

//2
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad--开始加载的时候调用");
    
    self.pageNum++;
     GLLog(@"%ld",(long)self.pageNum)
}

//3
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad---加载结束的时候调用");
    
    
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"didFailLoadWithError---当加载失败的时候调用---");
}



@end
