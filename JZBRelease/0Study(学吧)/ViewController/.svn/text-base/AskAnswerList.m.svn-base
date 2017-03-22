//
//  AskAnswerList.m
//  JZBRelease
//
//  Created by zjapple on 16/9/19.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "AskAnswerList.h"
#import "UIImageView+CreateImageView.h"
#import "UIButton+CreateButton.h"
#import "AskAnswerCell.h"
#import "AskAnswerItem.h"
#import "ChatKeyBoard.h"
#import "ChatToolBarItem.h"
#import "MoreItem.h"
#import "Toast.h"
#import "FaceSourceManager.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>

#import "ShareCustom.h"

@interface AskAnswerList () <UITableViewDataSource ,UITableViewDelegate , ChatKeyBoardDataSource, ChatKeyBoardDelegate>

/** 列表 */
@property (nonatomic, weak) UITableView *AskAnswerTableView;

@property (nonatomic, strong) ChatKeyBoard *chatKeyBoard;

/** eval_id */
@property (nonatomic, strong) NSString *eval_id;
/** isTeacher */
@property (nonatomic, assign) BOOL isTeacher;
/** isFreshenCell */
@property (nonatomic, assign) BOOL isFreshenCell;

/**
 *  面板
 */
@property (nonatomic, strong) UIView *panelView;

/**
 *  加载视图
 */
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;

@end

@implementation AskAnswerList

static NSString *ID = @"AskAnswerTableViewCell";

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.callBackDataS) {
        self.callBackDataS(self.dataSource);
    }
}

//-(void)keyboardHide:(UITapGestureRecognizer*)tap{
//    
//    [self.view endEditing:YES];
//    [self.chatKeyBoard keyboardDown];
//
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
//    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
//    tapGestureRecognizer.cancelsTouchesInView = NO;
//    //将触摸事件添加到当前view
//    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    if (self.isVoiceAndVideo) {
        [self.view setFrame:CGRectMake(0, 20 + GLScreenW / 16 * 9, GLScreenW, GLScreenH - (20 + GLScreenW / 16 * 9))];
    }
    
    self.chatKeyBoard = [ChatKeyBoard keyBoardWithNavgationBarTranslucent:YES];
    self.chatKeyBoard.delegate = self;
    self.chatKeyBoard.dataSource = self;
    self.chatKeyBoard.placeHolder = @"我要提问";
    self.chatKeyBoard.allowMore = NO;
    self.chatKeyBoard.allowVoice = NO;
    self.chatKeyBoard.allowFace = NO;
    [self.view addSubview:self.chatKeyBoard];
    
    if (![self.teacher.uid isEqualToString:[LoginVM getInstance].readLocal._id]) {
        
        self.eval_id = @"0";
        self.isTeacher = NO;
    }else {
        self.isTeacher = YES;
    }
    
    [self downLoadData];
    
    self.view.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"f8f8f8"];
    
    
    [self setupTableView];
    if (!self.isVoiceAndVideo) {
        [self setuptitleView];
    }
    //
    
    self.AskAnswerTableView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"f8f8f8"];
    
    self.AskAnswerTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.AskAnswerTableView.estimatedRowHeight = 200;
    
    [self.view bringSubviewToFront:self.chatKeyBoard];
    
}

- (void)downLoadData
{
    
    if (!self.class_id) {
        return ;
    }
    
    /** 请求直播详情 */
    NSDictionary *parameters = @{
                                 @"access_token":[LoginVM getInstance].readLocal.token,
                                 @"id":self.class_id,
                                 @"my":@"1"
                                 };
    
    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/Study/getClass"] parameters:parameters success:^(id json) {
        
        if ([json[@"state"] isEqual:@(0)]) {
            [SVProgressHUD showInfoWithStatus:json[@"info"]];
            return ;
        }
        
        self.dataSource = [AskAnswerItem mj_objectArrayWithKeyValuesArray:json[@"data"][@"question"]];
        

    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Nav按钮 and title
-(void)configNav:(UIViewController *)vc
{
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 11 + 5 + 40, 35)];
    UIImageView *backImageView = [UIImageView createImageViewWithFrame:CGRectMake(0, (35-20)/2, 20, 20) ImageName:@"close"];
    backImageView.userInteractionEnabled = NO;
    //    backImageView.userInteractionEnabled = YES;
    [backView addSubview:backImageView];
    //    UILabel *backLabel = [UILabel createLabelWithFrame:CGRectMake(11 + 5,(35-20)/2, 40, 20) Font:17 Text:@"返回" andLCR:0 andColor:[ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Navigation_Color" WithKind:XMLTypeColors]]];
    //    [backView addSubview:backLabel];
    UIControl *back = [[UIControl alloc] initWithFrame:backView.bounds];
    [back addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:back];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
    vc.navigationItem.leftBarButtonItem = leftBtnItem;
    
    UIButton *shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 35, 28)];
    [shareBtn setImage:[UIImage imageNamed:@"BQ_DT_release"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareList) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *shareBarBtn = [[UIBarButtonItem alloc]initWithCustomView:shareBtn];
    self.navigationItem.rightBarButtonItem = shareBarBtn;
    
}

- (void)backAction{
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.callBackDataS) {
            self.callBackDataS(self.dataSource);
        }
    }];
}

/** 设置64标题 */
- (void)setuptitleView
{
    UIView *top64View = [UIView new];
    [self.view addSubview:top64View];
    top64View.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"2198f2"];
    top64View.frame = CGRectMake(0, 0, self.view.glw_width, 64);
    
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    titleLable.text = @"问答列表";
    titleLable.textColor = [UIColor hx_colorWithHexRGBAString:@"ffffff"];
    titleLable.textAlignment = NSTextAlignmentCenter;
    [top64View addSubview:titleLable];
    titleLable.font = [UIFont systemFontOfSize:20];
    [titleLable sizeToFit];
    titleLable.gly_y = 28;
    titleLable.glcx_centerX = self.view.glw_width * 0.5;
    
    UIButton *backBtn = [UIButton createButtonWithFrame:CGRectMake(15, 28, 25, 25) FImageName:@"close" Target:self Action:@selector(backAction) Title:nil];
    backBtn.contentMode = UIViewContentModeCenter;
    [top64View addSubview:backBtn];
    
    UIButton *shareBtn = [UIButton createButtonWithFrame:CGRectMake(self.view.glw_width - backBtn.glw_width - 15, 28, 25, 25) FImageName:@"myhomepage_icon_share" Target:self Action:@selector(shareAction) Title:nil];
    shareBtn.contentMode = UIViewContentModeCenter;
    [top64View addSubview:shareBtn];
    
}

- (void)shareAction
{
    [self showShareActionSheet:self.view];
}

/**
 *  显示分享菜单
 *
 *  @param view 容器视图
 */
- (void)showShareActionSheet:(UIView *)view
{
    /** 还没有分享 */
    return ;
    
    /**
     * 在简单分享中，只要设置共有分享参数即可分享到任意的社交平台
     **/
    __weak AskAnswerList *theController = self;
    
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray = @[[UIImage imageNamed:@"shareImage"]];
    [shareParams SSDKSetupShareParamsByText:@"来自【建众帮】"
                                     images:imageArray
                                        url:[NSURL URLWithString:[NSString stringWithFormat:@"http://bang.jianzhongbang.com/index.php/Share/Question/info/id/%@.html",@"1"]]
                                      title:nil//title:@"分享标题-欢迎下载【建众帮】"
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
//                [SSUIShareActionSheetStyle setActionSheetBackgroundColor:[UIColor colorWithRed:249/255.0 green:0/255.0 blue:12/255.0 alpha:0.5]];
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


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.chatKeyBoard endEditing:YES];
    [self.chatKeyBoard keyboardDown];
    if (self.isTeacher) {
        self.chatKeyBoard.hidden = YES;
    }
}

- (void)shareList
{
    
}

- (void)setupTableView
{
    
    CGFloat TableViewH = 0;
    
    if (self.isTeacher) {
        TableViewH = self.view.glh_height - 64;
        self.chatKeyBoard.hidden = YES;
    }else {
        TableViewH = self.view.glh_height - 49 - 64;
    }
    
    UITableView *tableView;
    if (self.isVoiceAndVideo) {
        tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.glw_width, self.view.frame.size.height) style:UITableViewStylePlain];
        self.chatKeyBoard.hidden = NO;
    }else{
        tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.glw_width, TableViewH) style:UITableViewStylePlain];
    }
    self.AskAnswerTableView = tableView;
    [self.view addSubview:tableView];
    tableView.dataSource = self;
    tableView.delegate = self;
    
    [tableView registerNib:[UINib nibWithNibName:@"AskAnswerCell" bundle:nil] forCellReuseIdentifier:ID];
}



#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    /** 全部列表页面的空数据占位图片 */
    notDataShowView *view;
    
    if (self.dataSource.count) {
        if ([notDataShowView sharenotDataShowView].superview) {
            [[notDataShowView sharenotDataShowView] removeFromSuperview];
        }
    }else {
        view = [notDataShowView sharenotDataShowView:tableView];
        [tableView addSubview:view];
        
    }
    
    return self.dataSource.count;
}

- (AskAnswerCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AskAnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    // 设置 Cell...
    cell.isTeacher = self.isTeacher;
    cell.isFreshenCell = self.isFreshenCell;
    cell.model = self.dataSource[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 设置背景色
    cell.backgroundColor = [UIColor whiteColor];
    
    cell.clickUpButton = ^{
    
        [self downLoadData];
    
    };
    
    return cell;
}

//【先调-这个方法确定tableViewcell的高度,内部给cell设置frame】返回每个cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    if (indexPath.row %2 ==0) {
//        return 50;
//    }else
//    {
//        return 80;
//    }
    
    AskAnswerItem *item = self.dataSource[indexPath.row];
    return item.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.isTeacher) {
        return ;
    }else {
        self.chatKeyBoard.hidden = NO;
        AskAnswerItem *item = self.dataSource[indexPath.row];
        
        self.eval_id = item.eval_id;
        
        [self.chatKeyBoard canBecomeFirstResponder];
        [self.chatKeyBoard becomeFirstResponder];
        [self.chatKeyBoard canBecomeFirstResponder];
        [self.chatKeyBoard becomeFirstResponder];

        [self.chatKeyBoard keyboardUp];
        self.chatKeyBoard.placeHolder = @"我的回答";
        
    }
}



#pragma 文本改变
- (void)chatKeyBoardTextViewDidChange:(UITextView *)textView{
    if (textView.text.length > 255) {
        [Toast makeShowCommen:@"您问题描述字数已超 " ShowHighlight:@"255" HowLong:0.8];
        [textView setText:[textView.text substringToIndex:255]];
    }
}

#pragma mark -- 发送文本
- (void)chatKeyBoardSendText:(NSString *)text
{
    if (!self.class_id) return;
    
    if (!self.eval_id) return;
    
    [self.chatKeyBoard keyboardDown];
    
    if (self.isTeacher) {
        self.chatKeyBoard.hidden = YES;
    }
    
    NSDictionary *parameters = @{
                                 @"access_token":[LoginVM getInstance].readLocal.token,
                                 @"class_id":self.class_id,
                                 @"content":text,
                                 @"eval_id":self.eval_id
                                 };
    
    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/Study/answer"] parameters:parameters success:^(id json) {
    
    if ([json[@"state"] isEqual:@(0)]) {
        [SVProgressHUD showInfoWithStatus:json[@"info"]];
    }else {
        /** 请求直播详情 */
        NSDictionary *parameters = @{
                                     @"access_token":[LoginVM getInstance].readLocal.token,
                                     @"id":self.class_id,
                                     @"my":@"1"
                                     };
        
        [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/Study/getClass"] parameters:parameters success:^(id json) {
            
            publicBaseJsonItem *item = [publicBaseJsonItem mj_objectWithKeyValues:json];
            
            if ([json[@"state"] isEqual:@(0)]) {
                [SVProgressHUD showInfoWithStatus:item.info];
                return ;
            }
            
            self.dataSource = [AskAnswerItem mj_objectArrayWithKeyValuesArray:json[@"data"][@"question"]];
            
//            for (UIView *view in self.AskAnswerTableView.subviews[0].subviews) {
//                if ([view isKindOfClass:[AskAnswerCell class]]) {
//                    [view removeFromSuperview];
//                }
//            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.isFreshenCell = YES;
                [self.AskAnswerTableView reloadData];
                self.isFreshenCell = NO;
                [SVProgressHUD showSuccessWithStatus:item.info];
            });
            
            //        NSLog(@"TTT--json%@",json);
        } failure:^(NSError *error) {
            
        }];
    }
    
    } failure:^(NSError *error) {
        
    }];
    
//    [[HttpManager shareManager] netStatus:^(AFNetworkReachabilityStatus status) {
//        if(status == AFNetworkReachabilityStatusReachableViaWWAN || status ==AFNetworkReachabilityStatusReachableViaWiFi){
//            
//        }else{
//            [Toast makeShowCommen:@"您的网络有问题 " ShowHighlight:@"请重置" HowLong:1.2];
//            return ;
//        }
//    }];
//    
//    if (!(text.length > 0)) {
//        return;
//    }
//    SendEvaluateForQuestionModel *model = [[SendEvaluateForQuestionModel alloc]init];
//    model.access_token = [[LoginVM getInstance] readLocal].token;
//    model.question_id = self.questionModel.question_id;
//    model.eval_id = @"0";
//    model.content = text;
//    SendAndGetDataFromNet *send = [[SendAndGetDataFromNet alloc]init];
//    __block SendAndGetDataFromNet *wsend = send;
//    send.returnDict = ^(NSDictionary *dict){
//        if (!dict) {
//            [Toast makeShowCommen:@"抱歉，您的网络出现故障，" ShowHighlight:@"评论失败" HowLong:1.5];
//        }else{
//            if (1 == [[dict objectForKey:@"state"] intValue]) {
//                [self downloadData];
//                [Toast makeShowCommen:@"恭喜您，" ShowHighlight:@"评论成功" HowLong:1.5];
//            }else{
//                [LoginVM getInstance].isGetToken = ^(){
//                    model.access_token = [[LoginVM getInstance] readLocal].token;
//                    [wsend dictFromNet:model WithRelativePath:@"Send_Evaluate_For_Question"];
//                };
//                [[LoginVM getInstance] loginWithUserInfoForGetNewToken:[[LoginVM getInstance] readLocal]];
//            }
//        }
//    };
//    [send dictFromNet:model WithRelativePath:@"Send_Evaluate_For_Question"];
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.isTeacher) {
        [self.view endEditing:YES];
        [self.chatKeyBoard keyboardDown];
        self.chatKeyBoard.hidden = YES;
    }
    
}

#pragma mark - Private Method
- (void)goShare {
    
//    NSString *shareUrl_str = [[ValuesFromXML getValueWithName:@"ZiXun_Sever_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingFormat:@"%@", [NSString stringWithFormat:@"/Share/Article/info/id/%@.html",self.infoID]];
    
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray = @[[UIImage imageNamed:@"shareImage"]];
//    [shareParams SSDKSetupShareParamsByText:@"来自【建众帮】"
//                                     images:imageArray
//                                        url:[NSURL URLWithString:shareUrl_str]
//                                      title:self.model.title//title:@"分享标题-欢迎下载【建众帮】"
//                                       type:SSDKContentTypeWebPage];
    
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
