
//
//  InfomationDetailVC.m
//  JZBRelease
//
//  Created by cl z on 16/11/25.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "InfomationDetailVC.h"
#import "ZLCWebView.h"
#import "Defaults.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>

#import "ShareCustom.h"
#import "ChatKeyBoard.h"
#import "MoreItem.h"
#import "FaceSourceManager.h"
#import "FaceThemeModel.h"
#import "ChatToolBarItem.h"

@interface InfomationDetailVC ()<UIWebViewDelegate,ChatKeyBoardDelegate,ChatKeyBoardDataSource>{
    UIWebView *web;
    BOOL isFinish;
}

@property (nonatomic, strong) ChatKeyBoard *chatKeyBoard;

/**
 *  面板
 */
@property (nonatomic, strong) UIView *panelView;

/**
 *  加载视图
 */
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;

//设置加载进度条
@property (nonatomic,strong) UIProgressView *progressView;

@property (strong, nonatomic) JSContext *context;

@end

@implementation InfomationDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"详情";
    
//    [self configNav];
    
    [self setupShareView];
    
    [self.view setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"fefefe"]];

    
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.tabBarController.tabBar.hidden = YES;
    
    GLLog(@"%@",self.navigationController);
    if ([self.navigationController isKindOfClass:[GLNAVC class]]) {
        if (self.fromMesVC) {

            //11 20
            UIView *shareView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 11 + 5 + 40, 35)];
            UIImageView *shareImageView = [UIImageView createImageViewWithFrame:CGRectMake(45 - 20, (35-20)/2, 20, 20) ImageName:@"WDXQ_share"];
            shareImageView.userInteractionEnabled = YES;
            [shareView addSubview:shareImageView];
            //    UILabel *backLabel = [UILabel createLabelWithFrame:CGRectMake(11 + 5,(35-20)/2, 40, 20) Font:17 Text:@"返回" andLCR:0 andColor:[ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Navigation_Color" WithKind:XMLTypeColors]]];
            //    [backView addSubview:backLabel];
            UIControl *share = [[UIControl alloc] initWithFrame:shareView.bounds];
            [share addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
            [shareView addSubview:share];
            
            UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace   target:nil action:nil];
            
            /**
             width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和  边界间距为5pix，所以width设为-5时，间距正好调整为0；width为正数 时，正好相反，相当于往左移动width数值个像素
             */
            negativeSpacer.width = -10;
            
            UIBarButtonItem *rifhtBtnItem = [[UIBarButtonItem alloc] initWithCustomView:shareView];
            self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, rifhtBtnItem, nil];
            
            
        }else{
            [self configNav];
        }
    }else {
        [self configNav];
    }
}

- (UIProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.frame = CGRectMake(0, 64, self.view.bounds.size.width, 2);
        // 设置进度条的色彩
        //[_progressView setTrackTintColor:[UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1.0]];
        _progressView.progressTintColor = [UIColor greenColor];
        _progressView.hidden = YES;
    }
    return _progressView;
}

- (void)setupShareView
{
    //加载等待视图
    self.panelView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.panelView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.panelView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    
    self.loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.loadingView.frame = CGRectMake((self.view.frame.size.width - self.loadingView.frame.size.width) / 2, (self.view.frame.size.height - self.loadingView.frame.size.height) / 2, self.loadingView.frame.size.width, self.loadingView.frame.size.height);
    self.loadingView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    [self.panelView addSubview:self.loadingView];
}

-(void)configNav
{
    //11 20
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, 11 + 5 + 20, 35)];
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
    
    //11 20
    UIView *shareView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 11 + 5 + 40, 35)];
    UIImageView *shareImageView = [UIImageView createImageViewWithFrame:CGRectMake(45 - 20, (35-20)/2, 20, 20) ImageName:@"WDXQ_share"];
    shareImageView.userInteractionEnabled = YES;
    [shareView addSubview:shareImageView];
    //    UILabel *backLabel = [UILabel createLabelWithFrame:CGRectMake(11 + 5,(35-20)/2, 40, 20) Font:17 Text:@"返回" andLCR:0 andColor:[ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Navigation_Color" WithKind:XMLTypeColors]]];
    //    [backView addSubview:backLabel];
    UIControl *share = [[UIControl alloc] initWithFrame:shareView.bounds];
    [share addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    [shareView addSubview:share];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace   target:nil action:nil];
    
    /**
     width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和  边界间距为5pix，所以width设为-5时，间距正好调整为0；width为正数 时，正好相反，相当于往左移动width数值个像素
     */
    negativeSpacer.width = -10;
    
    UIBarButtonItem *rifhtBtnItem = [[UIBarButtonItem alloc] initWithCustomView:shareView];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, rifhtBtnItem, nil];
    
}

-(void)viewDidAppear:(BOOL)animated{
    if (!web) {
        web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        [[UIApplication sharedApplication].keyWindow addSubview:web];
        //添加进度条
        [[UIApplication sharedApplication].keyWindow addSubview:self.progressView];
    }
    UserInfo *userInfo = [[LoginVM getInstance] readLocal];
    if (!userInfo && !userInfo.token) {
        
    }else{
        NSString *path = [[ValuesFromXML getValueWithName:@"ZiXun_Sever_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:[NSString stringWithFormat:[ValuesFromXML getValueWithName:@"Article_Detail_URL" WithKind:XMLTypeNetPort],self.infoID,userInfo.token]];
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:path]]];
        web.delegate = self;
    }
    self.chatKeyBoard = [ChatKeyBoard keyBoardWithNavgationBarTranslucent:YES];
    self.chatKeyBoard.delegate = self;
    self.chatKeyBoard.dataSource = self;
    self.chatKeyBoard.placeHolder = @"我也要回答";
    self.chatKeyBoard.allowMore = NO;
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if (appDelegate.audioSwitch) {
        self.chatKeyBoard.allowVoice = NO;
    }else{
        self.chatKeyBoard.allowVoice = NO;
    }
    
    self.chatKeyBoard.allowFace = NO;
    [[UIApplication sharedApplication].keyWindow addSubview:self.chatKeyBoard];
}


-(void) backAction{
    [web removeFromSuperview];
    web  = nil;
//    if (self.fromPerson) {
//        [self.navigationController popViewControllerAnimated:YES];
//        return;
//    }
    [self.progressView removeFromSuperview];
    self.progressView = nil;
    [self.chatKeyBoard removeFromSuperview];
    self.chatKeyBoard = nil;
    [self.navigationController popViewControllerAnimated:YES];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    

    
    self.progressView.hidden = NO;
    
    [self loadProgress];
}

- (void)loadProgress{
    float progress = 0;
    __block typeof (progress) wp = progress;
    [NSTimer scheduledTimerWithTimeInterval:0.05 repeats:YES block:^(NSTimer * _Nonnull timer) {
        if (isFinish) {
            [timer invalidate];
            timer = nil;
        }
        wp = wp + 0.01;
        [self.progressView setProgress:wp];
        if (wp > 0.8) {
            [timer invalidate];
            timer = nil;
        }
    }];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    //js 交互
    if (!self.context) {
        self.context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        
        // 打印异常
        self.context.exceptionHandler =
        ^(JSContext *context, JSValue *exceptionValue)
        {
            context.exception = exceptionValue;
            NSLog(@"%@", exceptionValue);
        };
    }
    
    
    NSString *hideWay = @"hideComment()";
    [self.context evaluateScript:hideWay];
    
    // 以 JSExport 协议关联 native 的方法
    self.context[@"native"] = self;
    
    // 以 block 形式关联 JavaScript function
    __weak typeof (self) wself = self;
    self.context[@"pushToPersonalVC"] =
    ^(NSString *str)
    {
        
        NSLog(@"%@",str);
    };

    
    
    isFinish = YES;
    [NSTimer scheduledTimerWithTimeInterval:0.01 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [self.progressView setProgress:self.progressView.progress + 0.05];
        if ((int)self.progressView.progress == 1) {
            [timer invalidate];
            timer = nil;
            self.progressView.hidden = YES;
        }
    }];
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}

#pragma mark -- 发送文本
- (void)chatKeyBoardSendText:(NSString *)text
{
    [self.chatKeyBoard keyboardDown];
    NSString *comment = [NSString stringWithFormat:@"comment('%@')",text];
    [self.context evaluateScript:comment];
}

#pragma mark -- ChatKeyBoardDataSource
- (NSArray<MoreItem *> *)chatKeyBoardMorePanelItems
{
    MoreItem *item1 = [MoreItem moreItemWithPicName:@"sharemore_location" highLightPicName:nil itemName:@"位置"];
    MoreItem *item2 = [MoreItem moreItemWithPicName:@"sharemore_pic" highLightPicName:nil itemName:@"图片"];
    MoreItem *item3 = [MoreItem moreItemWithPicName:@"sharemore_video" highLightPicName:nil itemName:@"拍照"];
    MoreItem *item4 = [MoreItem moreItemWithPicName:@"sharemore_location" highLightPicName:nil itemName:@"位置"];
    MoreItem *item5 = [MoreItem moreItemWithPicName:@"sharemore_pic" highLightPicName:nil itemName:@"图片"];
    MoreItem *item6 = [MoreItem moreItemWithPicName:@"sharemore_video" highLightPicName:nil itemName:@"拍照"];
    MoreItem *item7 = [MoreItem moreItemWithPicName:@"sharemore_location" highLightPicName:nil itemName:@"位置"];
    MoreItem *item8 = [MoreItem moreItemWithPicName:@"sharemore_pic" highLightPicName:nil itemName:@"图片"];
    MoreItem *item9 = [MoreItem moreItemWithPicName:@"sharemore_video" highLightPicName:nil itemName:@"拍照"];
    return @[item1, item2, item3, item4, item5, item6, item7, item8, item9];
}
- (NSArray<ChatToolBarItem *> *)chatKeyBoardToolbarItems
{
    ChatToolBarItem *item1 = [ChatToolBarItem barItemWithKind:kBarItemFace normal:@"face" high:@"face_HL" select:@"keyboard"];
    
    ChatToolBarItem *item2 = [ChatToolBarItem barItemWithKind:kBarItemVoice normal:@"voice" high:@"voice_HL" select:@"keyboard"];
    
    ChatToolBarItem *item3 = [ChatToolBarItem barItemWithKind:kBarItemMore normal:@"more_ios" high:@"more_ios_HL" select:nil];
    
    ChatToolBarItem *item4 = [ChatToolBarItem barItemWithKind:kBarItemSwitchBar normal:@"switchDown" high:nil select:nil];
    
    return @[item1, item2, item3, item4];
}

- (NSArray<FaceThemeModel *> *)chatKeyBoardFacePanelSubjectItems
{
    return [FaceSourceManager loadFaceSource];
}




-(void)dealloc{
    [web removeFromSuperview];
    web = nil;
}


/**
 *  显示分享菜单
 *
 *  @param view 容器视图
 */
- (void)showShareActionSheet:(UIView *)view
{
    /**
     * 在简单分享中，只要设置共有分享参数即可分享到任意的社交平台
     **/
    __weak InfomationDetailVC *theController = self;
    
//    NSString *shareUrl_str = [[ValuesFromXML getValueWithName:@"Sever_Absolute_Address" WithKind:XMLTypeNetPort]stringByAppendingPathComponent:[NSString stringWithFormat:@"Share/Article/info/id/%@.html",self.infoID]];
    
    NSString *shareUrl_str = [[ValuesFromXML getValueWithName:@"ZiXun_Sever_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingFormat:@"%@", [NSString stringWithFormat:@"/Share/Article/info/id/%@.html",self.infoID]];
    
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray = @[[UIImage imageNamed:@"shareImage"]];
    [shareParams SSDKSetupShareParamsByText:@"来自【建众帮】"
                                     images:imageArray
                                        url:[NSURL URLWithString:shareUrl_str]
                                      title:self.model.title//title:@"分享标题-欢迎下载【建众帮】"
                                       type:SSDKContentTypeWebPage];
    
    //1.2、自定义分享平台（非必要）
    NSMutableArray *activePlatforms = [NSMutableArray arrayWithArray:[ShareSDK activePlatforms]];
    //添加一个自定义的平台（非必要）
    SSUIShareActionSheetCustomItem *item = [SSUIShareActionSheetCustomItem itemWithIcon:[UIImage imageNamed:@"Icon.png"]
                                                                                  label:@"自定义"
                                                                                onClick:^{
                                                                                    
                                                                                    //自定义item被点击的处理逻辑
                                                                                    NSLog(@"=== 自定义item被点击 ===");
                                                                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"自定义item被点击"
                                                                                                                                        message:nil
                                                                                                                                       delegate:nil
                                                                                                                              cancelButtonTitle:@"确定"
                                                                                                                              otherButtonTitles:nil];
                                                                                    [alertView show];
                                                                                }];
    [activePlatforms addObject:item];
    
    //设置分享菜单栏样式（非必要）
    //            [SSUIShareActionSheetStyle setActionSheetBackgroundColor:[UIColor colorWithRed:249/255.0 green:0/255.0 blue:12/255.0 alpha:0.5]];
    //            [SSUIShareActionSheetStyle setActionSheetColor:[UIColor colorWithRed:21.0/255.0 green:21.0/255.0 blue:21.0/255.0 alpha:1.0]];
    //            [SSUIShareActionSheetStyle setCancelButtonBackgroundColor:[UIColor colorWithRed:21.0/255.0 green:21.0/255.0 blue:21.0/255.0 alpha:1.0]];
    //            [SSUIShareActionSheetStyle setCancelButtonLabelColor:[UIColor whiteColor]];
    //            [SSUIShareActionSheetStyle setItemNameColor:[UIColor whiteColor]];
    //            [SSUIShareActionSheetStyle setItemNameFont:[UIFont systemFontOfSize:10]];
    //            [SSUIShareActionSheetStyle setCurrentPageIndicatorTintColor:[UIColor colorWithRed:156/255.0 green:156/255.0 blue:156/255.0 alpha:1.0]];
    //            [SSUIShareActionSheetStyle setPageIndicatorTintColor:[UIColor colorWithRed:62/255.0 green:62/255.0 blue:62/255.0 alpha:1.0]];
    
    //2、分享
    [ShareSDK showShareActionSheet:view
                             items:nil
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   switch (state) {
                           
                       case SSDKResponseStateBegin:
                       {
                           [theController showLoadingView:YES];
                           break;
                       }
                       case SSDKResponseStateSuccess:
                       {
                           //Facebook Messenger、WhatsApp等平台捕获不到分享成功或失败的状态，最合适的方式就是对这些平台区别对待
                           if (platformType == SSDKPlatformTypeFacebookMessenger)
                           {
                               break;
                           }
                           
                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                               message:nil
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil];
                           [alertView show];
                           break;
                       }
                       case SSDKResponseStateFail:
                       {
                           if (platformType == SSDKPlatformTypeSMS && [error code] == 201)
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:@"失败原因可能是：1、短信应用没有设置帐号；2、设备不支持短信应用；3、短信应用在iOS 7以上才能发送带附件的短信。"
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           else if(platformType == SSDKPlatformTypeMail && [error code] == 201)
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:@"失败原因可能是：1、邮件应用没有设置帐号；2、设备不支持邮件应用；"
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           else
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           break;
                       }
                       case SSDKResponseStateCancel:
                       {
                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                                                                               message:nil
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil];
//                           [alertView show];
                           break;
                       }
                       default:
                           break;
                   }
                   
                   if (state != SSDKResponseStateBegin)
                   {
                       [theController showLoadingView:NO];
                       //                       [theController.tableView reloadData];
                   }
                   
               }];
    
    //另附：设置跳过分享编辑页面，直接分享的平台。
    //        SSUIShareActionSheetController *sheet = [ShareSDK showShareActionSheet:view
    //                                                                         items:nil
    //                                                                   shareParams:shareParams
    //                                                           onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
    //                                                           }];
    //
    //        //删除和添加平台示例
    //        [sheet.directSharePlatforms removeObject:@(SSDKPlatformTypeWechat)];
    //        [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeSinaWeibo)];
    
}

/**
 *  显示加载动画
 *
 *  @param flag YES 显示，NO 不显示
 */
- (void)showLoadingView:(BOOL)flag
{
    if (flag)
    {
        [self.view addSubview:self.panelView];
        [self.loadingView startAnimating];
    }
    else
    {
        [self.panelView removeFromSuperview];
    }
}

- (void)shareAction
{
//    [self showShareActionSheet:self.view];
    [self goShare];
}


#pragma mark - Private Method
- (void)goShare {
    
    NSString *shareUrl_str = [[ValuesFromXML getValueWithName:@"ZiXun_Sever_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingFormat:@"%@", [NSString stringWithFormat:@"/Share/Article/info/id/%@.html",self.infoID]];
    
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray = @[[UIImage imageNamed:@"shareImage"]];
    [shareParams SSDKSetupShareParamsByText:@"来自【建众帮】"
                                     images:imageArray
                                        url:[NSURL URLWithString:shareUrl_str]
                                      title:self.model.title//title:@"分享标题-欢迎下载【建众帮】"
                                       type:SSDKContentTypeWebPage];
    
    //1、创建分享参数
//    NSArray* imageArray = @[[UIImage imageNamed:@"share_icon"]];
    if (imageArray) {
        
//        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//        [shareParams SSDKSetupShareParamsByText:@"11111"
//                                         images:imageArray
//                                            url:[NSURL URLWithString:@"http://baidu.com"]
//                                          title:@"2222"
//                                           type:SSDKContentTypeAuto];
        
        
        //调用自定义分享
        [ShareCustom shareWithContent:shareParams];
    }
    
}

@end
