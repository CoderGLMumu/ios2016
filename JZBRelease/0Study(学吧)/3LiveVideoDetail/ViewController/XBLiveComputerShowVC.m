//
//  XBLiveComputerShowVC.m
//  JZBRelease
//
//  Created by Apple on 16/12/8.
//  Copyright © 2016年 zjapple. All rights reserved.
//

//#import "SocketIO.h"
//#import "JZBRelease-Swift.h"

@import SocketIO;
//#import "SocketIO.h"
//#import "SocketIO-Swift.h"

#import "XBLiveComputerShowVC.h"
#import "XBLiveMobileVideoShowVC.h"
#import "AliVcMoiveViewController.h"
#import "socketChatListCell.h"

#import "Masonry.h"

#import "GrowingInputView.h"
#import "MessageTableViewController.h"

#import "DataBaseHelperSecond.h"
#import "DanmuItem.h"

#import "AskAnswerList.h"
#import "RewardAlertView.h"
#import "IntegralDetailVC.h"
#import "RewardModel.h"
#import "LewPopupViewAnimationSpring.h"
#import "PublicOtherPersonVC.h"

//#import "JZBRelease-Swift.h"

@interface XBLiveComputerShowVC ()<UITableViewDelegate,UITableViewDataSource,GrowingInputViewDelegate,UIGestureRecognizerDelegate>
{
    GrowingInputView *_growingInputView;//输入框
    BOOL _showKeyBoard;
    NSInteger _keyboardHeight;
    BOOL _keyboardVisible;
    
    BOOL _canResetGrowingInputView;
}
@property(nonatomic,strong) MessageTableViewController *messageVC;
@property(nonatomic, strong) NSMutableArray *msgList;

/** tableViewDataSouce */
@property (nonatomic, strong) NSArray *tableViewDataSouce;
/** rankTableView */
@property (nonatomic, weak) UITableView *rankTableView;

@property (strong, nonatomic) TBMoiveViewController* currentView;

/** blueFlag */
@property (nonatomic, weak) UIView *blueFlag;
/** zoomButton */
@property (nonatomic, weak) UIButton *zoomButton;
/** LoveRankButton */
@property (nonatomic, weak) UIButton *loveRankButton;
/** commentButton */
@property (nonatomic, weak) UIButton *commentButton;
/** contentScrView */
@property (nonatomic, weak) UIScrollView *contentScrView;

/** topPanel */
@property (nonatomic, weak) UIView *topPanel;
/** botPanel */
@property (nonatomic, weak) UIView *botPanel;

/** tableChangePanel */
@property (nonatomic, weak) UIView *tableChangePanel;

@property (nonatomic, strong) NSMutableArray *chatDataArray;
/** socket */
@property (nonatomic, strong) SocketIOClient *socket;
/** user */
@property (nonatomic, strong) Users *user;

/** 是否为全屏 */
@property (nonatomic, assign) BOOL                isFullScreen;

/** 头像数组 */
@property (nonatomic, strong) NSArray *dataSource;

@property (weak, nonatomic) UILabel *liveNumLabel;

/** isMineInfo */
@property (nonatomic, assign) BOOL isMineInfo;

@end

@implementation XBLiveComputerShowVC

static NSString *ID = @"chatTableCELLID";

- (Users *)user
{
    if (_user == nil) {
        _user = [[Users alloc] init];
    }
    return _user;
}

-(NSMutableArray *)msgList {
    if (_msgList == nil) {
        _msgList = [NSMutableArray array];
    }
    return _msgList;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)tapEvent{
    NSLog(@"==============TapEvent");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.autoresizesSubviews = NO;
    
    if ([self.teacher.uid isEqualToString:[LoginVM getInstance].readLocal._id]) {
        self.isMineInfo = YES;
//        self.payMoneyButton.enabled = NO;
    }
    

    self.user = [[LoginVM getInstance] users];
    
//    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEvent)];
//    tap.delegate=self;
//    [self.view addGestureRecognizer:tap];
    
    TBMoiveViewController* currentView = [[TBMoiveViewController alloc] init];
    
//    if ([self.liveitem.type isEqualToString:@"2"]) {
//        currentView.isVoice = YES;
//    }else if ([self.liveitem.type isEqualToString:@"1"]) {
//        currentView.clickVideoView = ^{
//            
//            GLLog(@"currentView.clickVideoView");
//            
//        };
//    }
    
    self.currentView = currentView;
    
    NSURL *url = [NSURL URLWithString:self.playUrl];
    
    [currentView SetMoiveSource:url];
    
    currentView.videoFrame = CGRectMake(0, 20, GLScreenW, GLScreenW* 9 / 16);
    
    
    [self addChildViewController:currentView];
    [self.view addSubview:currentView.view];
    currentView.view.userInteractionEnabled = NO;
    
    [self topPanel];
    [self botPanel];
    
    [self tableChangePanel];
    
    [self chatTableView_new];
    
    [self setUpSocket];
}

- (void)chatTableView_new
{
    self.chatDataArray = [NSMutableArray array];
    
//    UIView *contentView = [UIView new];
//    [self.view addSubview:contentView];
//    contentView.backgroundColor = [UIColor whiteColor];
    
//    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(self.view.mas_leading);
//        make.trailing.equalTo(self.view.mas_trailing);
//        make.top.equalTo(self.tableChangePanel.mas_bottom);
//        make.bottom.equalTo(self.view.mas_bottom).offset(-49);
//    }];
    
    
    UIScrollView *contentScrView = [UIScrollView new];
    self.contentScrView = contentScrView;
    [self.view addSubview:contentScrView];
    contentScrView.pagingEnabled = YES;
    contentScrView.showsHorizontalScrollIndicator = NO;
    contentScrView.contentSize = CGSizeMake(GLScreenW * 2, 0);
    contentScrView.delegate = self;
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapcollection)];
//    
//    [tap setNumberOfTapsRequired:0];
//    tap.delegate = self;
//    [contentScrView addGestureRecognizer:tap];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        contentScrView.contentSize = CGSizeMake(GLScreenW * 2, 0);
    });
    
    [contentScrView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading);
        make.trailing.equalTo(self.view.mas_trailing);
        make.top.equalTo(self.tableChangePanel.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom).offset(-49);
    }];
    
    contentScrView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"f2f2f2"];
    
    [self.view layoutIfNeeded];
    
//    UIView *BGt = [UIView new];
//    [contentScrView addSubview:BGt];
//    BGt.frame = CGRectMake(GLScreenW, 0, contentView.glw_width, contentView.glh_height);
//    BGt.backgroundColor = [UIColor redColor];
    [self rankTableView];
    
    //图文混排子控制器
    self.messageVC = [[MessageTableViewController alloc] init];
    self.messageVC.isMobShow = NO;
    [contentScrView addSubview:self.messageVC.tableView];
//    self.messageVC.tableView.frame = CGRectMake(10, 20, self.view.bounds.size.width - 20, 300);
    
    self.messageVC.tableView.frame = CGRectMake(10, 0, GLScreenW - 20, contentScrView.glh_height);
    
//    [self.messageVC.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(contentView).width.insets(UIEdgeInsetsMake(0, 10, 0, 10));
//    }];
    
    self.messageVC.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.messageVC.tableView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"f2f2f2"];
    
    //赋值,自动刷新,滚动到最后一行
    self.messageVC.msgList = self.msgList;
    
    //加载输入框
    [self showGrowingInputView];
}

- (void)tapcollection
{

}

//输入框
-(void)showGrowingInputView {
    if (_growingInputView == nil) {
        _growingInputView = [[GrowingInputView alloc] initWithFrame:CGRectZero];
        _growingInputView.frame = CGRectMake(0, self.view.frame.size.height - [GrowingInputView defaultHeight], self.view.frame.size.width, [GrowingInputView defaultHeight]);
        _growingInputView.placeholder = @"我也要评论...";
        _growingInputView.delegate = self;
        _growingInputView.parentView = self.view;
        
        __weak typeof(self) weakSelf = self;
        
        // 点击打赏
        _growingInputView.activatePayForUp = ^{
            
            [weakSelf.view endEditing:YES];
            
            RewardAlertView *view = [RewardAlertView defaultPopupView];
            view.parentVC = weakSelf;
            view.isfromLiveToPrese = YES;
            
            Users *users = [[Users alloc]init];
            users.uid = [[LoginVM getInstance] readLocal]._id;
            users = (Users *)[[DataBaseHelperSecond getInstance] getModelFromTabel:users];
            
            [view.balanceLabel setText:users.money];
//            __weak XBLiveMobileVideoShowVC *wself = weakSelf;
            
            view.sendAction = ^(Clink_Type clink_type,NSString *howmuch){
                
                if (clink_type == Clink_Type_Three) {
                    IntegralDetailVC *vc = [[UIStoryboard storyboardWithName:@"IntegralDetailVC" bundle:nil] instantiateInitialViewController];
                    
                    vc.isFromPreseVC = YES;
                    
                    [weakSelf presentViewController:vc animated:YES completion:^{
                        
                    }];
                }
                
                if (clink_type == Clink_Type_One) {
                    if ([users.money integerValue] < [howmuch integerValue]) {
                        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"打赏失败" message:@"原因：您的余额不足" delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alertView show];
                        return ;
                    }
                    //            CustomAlertView *alertView = [CustomAlertView defaultCustomAlertView:@"支付中..."];
                    //            [wself lew_presentPopupView:alertView animation:[LewPopupViewAnimationSpring new]];
                    
                    [SVProgressHUD showWithStatus:@"支付中..."];
                    
                    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = NO;
                    RewardModel *rewardModel = [[RewardModel alloc]init];
                    rewardModel.access_token = [[LoginVM getInstance] readLocal].token;
                    rewardModel.id = weakSelf.class_id;
                    
                    rewardModel.score = howmuch;
                    
                    SendAndGetDataFromNet *sendAndGet = [[SendAndGetDataFromNet alloc]init];
                    sendAndGet.returnModel = ^(GetValueObject *obj,int state){
                        if (1 == state) {
                            [SVProgressHUD showSuccessWithStatus:@"打赏完成"];
                            
                            // 请求课程详情
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                HttpBaseRequestItem *BRitem = [HttpBaseRequestItem new];
                                BRitem.access_token = [[LoginVM getInstance]readLocal].token;
                                BRitem.id = weakSelf.liveitem.aid;
                                BRitem.my = @"1";
                                NSDictionary *parameters = BRitem.mj_keyValues;
                                
                                [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/Study/getClass"] parameters:parameters success:^(id json) {
                                    
                                    if ([json[@"state"] isEqual:@(0)]) {
                                        [SVProgressHUD showInfoWithStatus:json[@"info"]];
                                        return ;
                                    }
                                    
                                    weakSelf.liveitem = [LiveVideoDetailItem mj_objectWithKeyValues:json[@"data"]];
                                    weakSelf.loveRankDataSource = [reward_rankItem mj_objectArrayWithKeyValuesArray:weakSelf.liveitem.reward_rank];
                                    
                                    [weakSelf.rankTableView reloadData];
                                    
                                    //        NSLog(@"TTT--json%@",json);
                                } failure:^(NSError *error) {
                                    
                                }];
                            });
                            
                            [weakSelf.contentScrView setContentOffset:CGPointMake(0, 0) animated:YES];
                            
                            //                    [alertView.label setText:@"支付完成"];
                            
                            int result_num = users.money.intValue;
                            
                            result_num -= howmuch.intValue;
                            
                            users.money = [NSString stringWithFormat:@"%d",result_num];
                            
                            [[DataBaseHelperSecond getInstance] delteModelFromTabel:users];
                            [[DataBaseHelperSecond getInstance] insertModelToTabel:users];
                            
                            GLLog(@"howmuch--howmuch%@",howmuch)
                            
                            HttpBaseRequestItem *item = [HttpBaseRequestItem new];
                            item.content = [NSString stringWithFormat:@"打赏了%@帮币!",howmuch];
                            item.name = weakSelf.user.nickname;
                            item.avatar = weakSelf.user.avatar;
                            item.id = weakSelf.user.uid;
                            
                            if (weakSelf.user.vip) {
                                item.vip = @"0";
                            }else{
                                item.vip = @"1";
                            }
                            item.message_type = @"1";
                            
                            NSString *str2 = item.mj_JSONString;
                            [weakSelf.socket emit:@"send_message" with:@[str2]];
                            
                            
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [weakSelf lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
                                [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
                            });
                        }else{
                            if (weakSelf.isMineInfo) {
                                [SVProgressHUD showErrorWithStatus:@"不能打赏自己"];
                                return ;
                            }
                            //                    [alertView.label setText:@"支付失败"];
                            [SVProgressHUD showErrorWithStatus:@"没有打赏,有需要联系我们"];
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [weakSelf lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
                                [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
                            });
                        }
                    };
                    
                    [sendAndGet commenDataFromNet:rewardModel WithRelativePath:@"Reward_CourseTime_URL"];
                }
                
            };
            
            
            [weakSelf lew_presentPopupView:view animation:[LewPopupViewAnimationSpring new] dismissed:^{
                NSLog(@"动画结束");
            }];
        
        };
        
        
        // 提问列表
        _growingInputView.activateQNAButton = ^{
            
            AskAnswerList *list = [AskAnswerList new];
            
            list.teacher = weakSelf.teacher;
            list.dataSource = weakSelf.question;
            list.class_id = weakSelf.class_id;
            
            list.callBackDataS = ^(NSArray *dataSource){
                weakSelf.question = dataSource;
            };
            
            [weakSelf presentViewController:list animated:YES completion:^{
//                weakSelf.noticeViewBlock = NO;
            }];
            
        };
        
        // 这里可以用self.
        [self.view addSubview:_growingInputView];
    }
    _growingInputView.hidden = NO;
    //让组件内部的textView成为第一响应者
//    [_growingInputView activateInput];
    
    //添加点击空白处退键盘
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backViewTap)];
//    [self.view addGestureRecognizer:tap];
}
- (void)backViewTap {
    [self.view endEditing:YES];
}


#pragma mark - GrowingInputView输入框代理
//输入框改变高度(行数改变时)
- (void)growingInputView:(GrowingInputView *)growingInputView didChangeHeight:(CGFloat)height keyboardVisible:(BOOL)keyboardVisible
{
    _keyboardVisible = keyboardVisible;
    if (keyboardVisible) {
        _keyboardHeight = height;
        
    } else {
        _keyboardHeight = 0;
    }
}
//输入框结束编辑
- (void)growingTextViewDidEndEditing:(GrowingInputView *)growingInputView
{
    [self resetGrowingInputView];
    _canResetGrowingInputView = YES;
}
//输入框开始编辑
- (BOOL)growingTextViewShouldBeginEditing:(GrowingInputView *)growingInputView
{
    _canResetGrowingInputView = YES;
    return YES;
}
//点击发送按钮
- (BOOL)growingInputView:(GrowingInputView *)growingInputView didSendText:(NSString *)text
{
    
//    DanmuItem *model = [DanmuItem new];
//    if (self.user.vip) {
//        model.isvip = YES;
//    }
//    model.isvip = YES;
//    model.userName = [NSString stringWithFormat:@"%@：",self.user.nickname];
//    model.content_black = text;
//    model.is_blackcontent = YES;
//    model.allstring = [NSString stringWithFormat:@"%@：%@",self.user.nickname,text];
    
//    [self.msgList addObject:model];

    self.messageVC.msgList = self.msgList;
    
    HttpBaseRequestItem *item = [HttpBaseRequestItem new];
    item.content = [NSString stringWithFormat:@"%@",text];
    item.name = self.user.nickname;
    item.avatar = self.user.avatar;
    item.id = self.user.uid;
    
    if (self.user.vip) {
        item.vip = @"0";
    }else{
        item.vip = @"1";
    }
    item.message_type = @"0";
    
    NSString *str2 = item.mj_JSONString;
    [self.socket emit:@"send_message" with:@[str2]];
    
    [self.view endEditing:YES];
    
    return YES;
    
}
//清空输入框
- (void)resetGrowingInputView
{
    if (_canResetGrowingInputView == YES) {
        _growingInputView.placeholder = @"我也要评论...";
    }
}
//切换Emoji,不清空现有内容
- (void)growingInputViewEmojiBtnClick:(GrowingInputView *)growingInputView
{
    _canResetGrowingInputView = NO;
}
//隐藏键盘时还要做的其他事,在这个代理方法中实现
-(void)growingInputView:(GrowingInputView *)growingInputView didRecognizer:(id)sender {
    
}


- (UIView *)topPanel
{
    if (_topPanel == nil) {
        UIView *topPanel = [[UIView alloc] init];
        [self.view addSubview:topPanel];
        _topPanel = topPanel;
        
//        topPanel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        
//        topPanel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        topPanel.backgroundColor = [UIColor clearColor];
        
        [topPanel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.right.equalTo(@(20));
            make.height.right.equalTo(@(60));
        }];
        
//        topPanel.frame = CGRectMake(0, 20, GLScreenW, 40);
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setImage:[UIImage imageNamed:@"DNZB_back"] forState:UIControlStateNormal];
//        [tipButton1 setTitle:@"" forState:UIControlStateNormal];
        
        [topPanel addSubview:backButton];
        
        [backButton setFont:[UIFont systemFontOfSize:0]];
        
        [backButton setTitleColor:[UIColor hx_colorWithHexRGBAString:@"757575"] forState:UIControlStateNormal];
        
        backButton.frame = CGRectMake(20, 13, 30, 30);
        
//        backButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 22);
        
        
        [backButton addTarget:self action:@selector(backActive:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [shareButton setImage:[UIImage imageNamed:@"DNZB_ZF"] forState:UIControlStateNormal];
        //        [tipButton1 setTitle:@"" forState:UIControlStateNormal];
        
        [topPanel addSubview:shareButton];
        
        [shareButton setFont:[UIFont systemFontOfSize:0]];
        
        [shareButton setTitleColor:[UIColor hx_colorWithHexRGBAString:@"757575"] forState:UIControlStateNormal];
        
        [self.view layoutIfNeeded];
        
//        shareButton.frame = CGRectMake(self.view.glw_width - 20 - 30, 13, 30, 30);
        [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(shareButton.superview.mas_trailing).offset(-20);
            make.top.equalTo(@(13));
            make.height.width.equalTo(@(30));
        }];
        
//        shareButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 22);
//        shareButton.autoresizesSubviews = YES;
        
        [shareButton addTarget:self action:@selector(shareActive:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _topPanel;
}

- (UIView *)botPanel
{
    if (_botPanel == nil) {
        UIView *botPanel = [[UIView alloc] init];
        [self.view addSubview:botPanel];
        _botPanel = botPanel;
        
//        botPanel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        botPanel.backgroundColor = [UIColor clearColor];
        
        [botPanel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.right.equalTo(@(20 + GLScreenW * 9/16 - 60));
            make.height.equalTo(@(60));
        }];
        
//        botPanel.frame = CGRectMake(0, 20 + GLScreenW * 9/16 - 40, GLScreenW, 40);
        
        UIView *livePeoView = [[UIView alloc] init];
        [botPanel addSubview:livePeoView];
        livePeoView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        
        [self.view layoutIfNeeded];
        
        CGFloat livePeoViewH = 27;
        
        [livePeoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(botPanel.mas_leading);
//            make.centerY.equalTo(botPanel.mas_centerY);
            make.height.equalTo(@(livePeoViewH));
            make.width.equalTo(@(85));
            make.centerY.equalTo(@(livePeoViewH / 2)).offset(5);
        }];
        
        [self.view layoutIfNeeded];
        
        // 半边圆角
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:livePeoView.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(livePeoViewH / 2, livePeoViewH / 2)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = livePeoView.bounds;
        maskLayer.path = maskPath.CGPath;
        livePeoView.layer.mask = maskLayer;

        
        UILabel *numLabel = [UILabel new];
        [botPanel addSubview:numLabel];
        self.liveNumLabel = numLabel;
        [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(livePeoView.mas_leading).offset(12);
            make.centerY.equalTo(@(livePeoView.glh_height / 2)).offset(5);
        }];
        
        numLabel.text = @"正在加载...";
        numLabel.text = @"0";
        numLabel.font = [UIFont systemFontOfSize:12];
        [numLabel sizeToFit];
//        numLabel.backgroundColor = [UIColor orangeColor];
        numLabel.textColor = [UIColor whiteColor];
        
        UILabel *renzaikan = [UILabel new];
        [botPanel addSubview:renzaikan];
        
        [renzaikan mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(numLabel.mas_trailing).offset(2);
            make.centerY.equalTo(@(livePeoView.glh_height / 2)).offset(5);
        }];
        
        renzaikan.text = @"人在看";
        renzaikan.font = [UIFont systemFontOfSize:12];
        [renzaikan sizeToFit];
//        renzaikan.backgroundColor = [UIColor orangeColor];
        renzaikan.textColor = [UIColor whiteColor];
        
        
        UIButton *zoomButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [zoomButton setImage:[UIImage imageNamed:@"ZBHF_fd"] forState:UIControlStateNormal];
        //        [tipButton1 setTitle:@"" forState:UIControlStateNormal];
        
        self.zoomButton = zoomButton;
        
        [botPanel addSubview:zoomButton];
        
        [zoomButton setFont:[UIFont systemFontOfSize:0]];
        
        [zoomButton setTitleColor:[UIColor hx_colorWithHexRGBAString:@"757575"] forState:UIControlStateNormal];
        
        [self.view layoutIfNeeded];
        
        //        shareButton.frame = CGRectMake(self.view.glw_width - 20 - 30, 13, 30, 30);
        [zoomButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(zoomButton.superview.mas_trailing).offset(-17);
            make.centerY.equalTo(renzaikan.mas_centerY).offset(3);
            make.height.width.equalTo(@(32));
        }];
        
//        [zoomButton sizeToFit];
        
        //        shareButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 22);
        //        shareButton.autoresizesSubviews = YES;
        
        [zoomButton addTarget:self action:@selector(zoomActive:) forControlEvents:UIControlEventTouchUpInside];

        
    }
    return _botPanel;
}

- (void)backActive:(UIButton *)btn
{
    if (self.isFullScreen) {
        [self zoomActive:self.zoomButton];
    }else {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    
    GLLog(@"backActive--backActive")
}

- (void)shareActive:(UIButton *)btn
{
    [SVProgressHUD showInfoWithStatus:@"功能暂未开发"];
    
    GLLog(@"shareActive--shareActive")
}

- (void)zoomActive:(UIButton *)btn
{
    btn.selected = !btn.selected;
    
    GLLog(@"zoomActive--zoomActive")
    
    [self fullScreenAction:btn];
    
}


- (UIView *)tableChangePanel
{
    if (_tableChangePanel == nil) {
        UIView *tableChangePanel = [[UIView alloc] init];
        [self.view addSubview:tableChangePanel];
        
        [tableChangePanel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.view.mas_leading);
            make.trailing.equalTo(self.view.mas_trailing);
            make.top.equalTo(self.currentView.view.mas_bottom);
            make.height.equalTo(@(44));
            //            make.height.width.equalTo(@(30));
        }];
        
        _tableChangePanel = tableChangePanel;
        
        tableChangePanel.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:1];
//        tableChangePanel.frame = CGRectMake(0, self.currentView.view.glh_height, GLScreenW, 44);
        
        
        UIView *fengexian1 = [UIView new];
        [tableChangePanel addSubview:fengexian1];

        [fengexian1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(tableChangePanel.mas_top);
            make.leading.equalTo(tableChangePanel.mas_leading);
            make.trailing.equalTo(tableChangePanel.mas_trailing);
            make.height.equalTo(@(1));
        }];
        
        fengexian1.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"bdbdbd"];
        
        UIView *fengexian2 = [UIView new];
        [tableChangePanel addSubview:fengexian2];
        
        [fengexian2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(tableChangePanel.mas_bottom);
            make.leading.equalTo(tableChangePanel.mas_leading);
            make.trailing.equalTo(tableChangePanel.mas_trailing);
            make.height.equalTo(@(1));
        }];
        
        fengexian2.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"bdbdbd"];
        
        // 评论按钮
        UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.commentButton = commentButton;
        [commentButton setTitle:@"评论" forState:UIControlStateNormal];
        
        [tableChangePanel addSubview:commentButton];
        
        [commentButton setFont:[UIFont systemFontOfSize:15]];
        
        [commentButton setTitleColor:[UIColor hx_colorWithHexRGBAString:@"212121"] forState:UIControlStateNormal];
        
//        commentButton.frame = CGRectMake(0, 0, GLScreenW / 2, tableChangePanel);
        [commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(tableChangePanel.mas_leading);
            make.top.equalTo(tableChangePanel.mas_top);
            make.width.equalTo(@(GLScreenW / 2));
            make.height.equalTo(tableChangePanel.mas_height);
        }];
        
        commentButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 22);
        
        [commentButton addTarget:self action:@selector(commentActive:) forControlEvents:UIControlEventTouchUpInside];
        
        // 心意榜单
        UIButton *loveRankButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.loveRankButton = loveRankButton;
        [loveRankButton setTitle:@"心意榜单" forState:UIControlStateNormal];
        
        [tableChangePanel addSubview:loveRankButton];
        
        [loveRankButton setFont:[UIFont systemFontOfSize:15]];
        
        [loveRankButton setTitleColor:[UIColor hx_colorWithHexRGBAString:@"212121"] forState:UIControlStateNormal];
        
        [loveRankButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(tableChangePanel.mas_trailing);
            make.top.equalTo(tableChangePanel.mas_top);
            make.width.equalTo(@(GLScreenW / 2));
            make.height.equalTo(tableChangePanel.mas_height);
        }];
        
        loveRankButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 22);
        
        [loveRankButton addTarget:self action:@selector(LoveRankActive:) forControlEvents:UIControlEventTouchUpInside];
        
//        UIView *fengexian3 = [UIView new];
//        [tableChangePanel addSubview:fengexian3];
//        
//        [fengexian3 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(tableChangePanel.mas_top);
//            make.centerX.equalTo(tableChangePanel.mas_centerX);
//            make.height.equalTo(tableChangePanel.mas_height);
//            make.width.equalTo(@(1));
//        }];
//        
//        fengexian3.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"bdbdbd"];
        
        UIView *blueFlag = [UIView new];
        [tableChangePanel addSubview:blueFlag];
        self.blueFlag = blueFlag;
        [blueFlag mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(tableChangePanel.mas_bottom);
            make.leading.equalTo(@(0)).offset(GLScreenW / 8);
            make.height.equalTo(@(3));
            make.width.equalTo(@(GLScreenW / 2 / 2));
        }];
        
        blueFlag.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"2196f3"];
        
        
    }
    return _tableChangePanel;
}

- (void)commentActive:(UIButton *)btn
{
    GLLog(@"commentActive--commentActive")
    
//    [self.blueFlag mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.commentButton.mas_centerX);
//    }];
    
//    [UIView animateWithDuration:0.25 animations:^{
//        [self.blueFlag mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self.tableChangePanel.mas_bottom);
//            make.leading.equalTo(@(0));
//            make.height.equalTo(@(3));
//            make.width.equalTo(@(GLScreenW / 2));
//        }];
//        [self.view layoutIfNeeded];
//    }];
    
    [self.contentScrView setContentOffset:CGPointMake(0, 0) animated:YES];
    
}

- (void)LoveRankActive:(UIButton *)btn
{
    GLLog(@"LoveRankActive--LoveRankActive")
    
//    [UIView animateWithDuration:0.25 animations:^{
//        [self.blueFlag mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self.tableChangePanel.mas_bottom);
//            make.leading.equalTo(@(GLScreenW / 2));
//            make.height.equalTo(@(3));
//            make.width.equalTo(@(GLScreenW / 2));
//        }];
//        [self.view layoutIfNeeded];
//    }];
    
    [self.contentScrView setContentOffset:CGPointMake(GLScreenW, 0) animated:YES];
    
//    [self.blueFlag mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.commentButton.mas_centerX);
//    }];
    
}


#pragma mark - 初始化socket
- (void)setUpSocket
{
    
    HttpBaseRequestItem *item = [HttpBaseRequestItem new];
    item.name = self.user.nickname;
    if ([item.name isEqualToString:@""] || item.name == nil) {
        item.name = @"新用户";
    }
    item.avatar = self.user.avatar;
    if (self.user.vip) {
        item.vip = @"0";
    }else{
        item.vip = @"1";
    }
    
    item.id = self.user.uid;
    
   // NSString *str = item.mj_JSONString ;
    NSString *str = [item mj_JSONString];
    
    GLLog(@"mj_JSONString%@",str)
    
    //    NSDictionary *dict2 = @{@"log": item.avatar, item.avatar: @"123"};
    
    NSDictionary *dict = @{@"log": @YES,@"DoubleEncodeUTF8": @YES, @"forcePolling": @YES,@"connectParams":@{@"room":self.liveitem.aid}};
    
//    self.socket = SocketIOClient(socket(1, 1, 1));
    
//    NSURL* url = [[NSURL alloc] initWithString:@"http://120.77.48.254:7274/"];
    NSURL* url = [[NSURL alloc] initWithString:@"http://test.jianzhongbang.com:7274/"];
    
//    if ([[SocketIOClient class] instancesRespondToSelector:@selector(initWithSocketURL: config:)]) {
//        
//    }
    self.socket = [[SocketIOClient alloc] initWithSocketURL:url config:dict];
    
    __weak typeof(self) wself = self;
    
    [self.socket on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
        GLLog(@"socket connected");
        
        [wself.socket emit:@"join" with:@[str]];
        
        [wself.socket on:@"result_user" callback:^(NSArray* data, SocketAckEmitter* ack) {
            GLLog(@"result_user%@%lu",data,data.count);
            
            NSMutableArray *resultArr = [NSMutableArray arrayWithArray:data];
            
            GLLog(@"resultArr = %@",resultArr);
            
            // 设置在线用户信息
            
            NSArray *joinCount = data[1];
            
            wself.liveNumLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)joinCount.count + wself.liveitem.online_count2.integerValue ];
            
            // 头像
            wself.dataSource = [HttpBaseRequestItem mj_objectArrayWithKeyValuesArray:joinCount];
            
            

//            wself.collectionV.contentSize = CGSizeMake((30 + 3) * wself.dataSource.count, 0);
//            
//            [wself.collectionV reloadData];
//            DanmuItem *model = [DanmuItem new];
//            model.fisrtName = data[0];
//            model.content = @"";
//            model.isfisrtLabel = YES;
            
            // 进入 退出房间 接收的消息
            DanmuItem *model = [DanmuItem new];
            
//            HttpBaseRequestItem *item = wself.dataSource.lastObject;
            HttpBaseRequestItem *UserInfo = [HttpBaseRequestItem mj_objectWithKeyValues:data.lastObject];
            if ([UserInfo.vip isEqualToString:@"0"]) {
                model.isvip = YES;
            }else {
                model.isvip = NO;
            }
            
            if (model.isvip) {
                model.userName = [NSString stringWithFormat:@"%@：",item.name];
            }else{
                model.userName = [NSString stringWithFormat:@"%@：",item.name];
            }
            
            //            model.userName = self.user.nickname;
            model.content_blue = data[0];
            model.is_bluecontent = YES;
            model.allstring = [NSString stringWithFormat:@"%@",data[0]];
            model.allstring = [NSString stringWithFormat:@"%@",data[0]];
            if (model.isvip) {
                model.allstring = [NSString stringWithFormat:@" %@",data[0]];
            }else{
                model.allstring = [NSString stringWithFormat:@"%@",data[0]];
            }
            
            if (model.isvip) {
                
                if ([model.allstring isEqualToString:@" "]) {
                    
                }else {
                    [wself.msgList addObject:model];
                    
                    wself.messageVC.msgList = wself.msgList;
                }
                
            }else {
                
                if ([model.allstring isEqualToString:@""]) {
                    
                }else {
                    [wself.msgList addObject:model];
                    
                    wself.messageVC.msgList = wself.msgList;
                }
                
            }
            
//            [wself.chatDataArray addObject:model];
//            
//            [wself.chatTableView reloadData];
//            
//            [wself chatDataArrayAddMessageWithString:data[0]];
            
        }];
        
        [wself.socket on:@"result_message" callback:^(NSArray* data, SocketAckEmitter* ack) {
            
            GLLog(@"gaolinTTTresult_message%@",data);
            
            NSDictionary *info = data[1];
            
            HttpBaseRequestItem *item = [HttpBaseRequestItem mj_objectWithKeyValues:info];
//
//            DanmuItem *model = [DanmuItem new];
//            model.userName = item.name;
//            model.content = item.content;
//            model.isfisrtLabel = NO;
            
            
            DanmuItem *model = [DanmuItem new];
            
            if ([item.vip isEqualToString:@"0"]) {
                model.isvip = YES;
            }else {
                model.isvip = NO;
            }
            
            model.userName = [NSString stringWithFormat:@"%@：",item.name];
            
            // 0 评论，1 打赏
            if ([item.message_type isEqualToString:@"0"]) {
                
                model.content_black = item.content;
                model.is_blackcontent = YES;
                
            }else if ([item.message_type isEqualToString:@"1"]) {
            
                model.content_red = item.content;
                model.is_redcontent = YES;
            }
            
//            model.content_black = item.content;
//            model.is_blackcontent = YES;
            model.allstring = [NSString stringWithFormat:@" %@：%@",item.name,item.content];
            if (model.isvip) {
                model.allstring = [NSString stringWithFormat:@" %@：%@",item.name,item.content];
            }else{
                model.allstring = [NSString stringWithFormat:@"%@：%@",item.name,item.content];
            }
            NSData *jsondata = [model.allstring mj_JSONData];
            model.allstring =  [model.allstring stringByRemovingPercentEncoding];
            
            [wself.msgList addObject:model];
            
            wself.messageVC.msgList = wself.msgList;
            
//            [wself.chatDataArray addObject:model];
//            
//            [wself.chatTableView reloadData];
//            
//            [wself chatDataArrayAddMessageWithString:[NSString stringWithFormat:@"%@：%@",item.name,item.content]];
            
        }];
        
    }];
    
    [self.socket connect];
}

#pragma mark - 初始化socket
- (void)disMissSocket
{
    //    [self.socket emit:@"disconnect" with:@[]];
    [self.socket disconnect];
}

//// reload dataArray
//- (void)chatDataArrayAddMessageWithString:(NSString *)messageString {
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        
//        // 滑动到底部
//        [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(self.chatDataArray.count - 1) inSection:0] atScrollPosition:(UITableViewScrollPositionBottom) animated:YES];
//        
//    });
//}


- (void)dealloc
{
    [self.currentView closePlayer];
    [self.currentView removeFromParentViewController];
    
    [self disMissSocket];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}


#pragma mark - 旋转
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    
//    /** 高林修改了 旋转屏幕后 9：16 view 没有返回按钮 */
//    if (self.playerVie.isFullScreen == YES) {
//        // 这里 YES / NO  是反的 是转换前
//        self.playerVie.panel.backBtn.hidden = NO;
//    }else {
//        self.playerVie.panel.backBtn.hidden = NO;
//    }
    
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {

        GLLog(@"小屏小屏小屏小屏小屏")
        GLLog(@"%@",self.currentView.view)
        
        self.currentView.view.frame = CGRectMake(0, 20, GLScreenH, GLScreenH * 9 / 16);

        [self.topPanel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(20));
        }];
        
        [self.botPanel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(@(20 + GLScreenH * 9/16 - 60));
        }];
        
        self.isFullScreen = NO;
        
    }else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {

        //if use Masonry,Please open this annotation
        
        GLLog(@"全屏全屏全屏全屏全屏")
        GLLog(@"%@",self.currentView.view)
        
        self.currentView.view.frame = CGRectMake(0, 0, GLScreenH, GLScreenW);
        
        [self.topPanel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(0));
        }];
        
        [self.botPanel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(GLScreenW - 60));
        }];
        
        self.isFullScreen = YES;
        
    }
    
//    [self.blueFlag mas_updateConstraints:^(MASConstraintMaker *make) {
//        
//        
//    }];
    
    if (self.contentScrView.contentOffset.x) {
        [self.blueFlag mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.tableChangePanel.mas_bottom);
            make.leading.equalTo(@(GLScreenH * 0.5 + GLScreenH / 8));
            make.height.equalTo(@(3));
            make.width.equalTo(@(GLScreenH / 2 / 2));
        }];
    }else {
        [self.blueFlag mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.tableChangePanel.mas_bottom);
            make.leading.equalTo(@(0)).offset(GLScreenH / 8);
            make.height.equalTo(@(3));
            make.width.equalTo(@(GLScreenH / 2 / 2));
        }];
    }
    
    if (self.contentScrView.contentOffset.x) {
        [self.contentScrView setContentOffset:CGPointMake(GLScreenH, 0) animated:YES];
    }
    
    for (socketChatListCell *cell in [self.rankTableView visibleCells]) {
        [cell updateSubViewConstraints];
    }
    
}


/**
 *  全屏按钮事件
 *
 *  @param sender 全屏Button
 */
- (void)fullScreenAction:(UIButton *)sender
{
//    if (self.isLocked) {
//        [self unLockTheScreen];
//        return;
//    }
    if (sender.selected == NO) {
        [self interfaceOrientation:UIInterfaceOrientationPortrait];
        return;
    }
    
    UIDeviceOrientation orientation             = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    switch (interfaceOrientation) {
            
        case UIInterfaceOrientationPortraitUpsideDown:{
            
            [self interfaceOrientation:UIInterfaceOrientationPortrait];
        }
            break;
        case UIInterfaceOrientationPortrait:{
            
            [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:{
            if (!self.isFullScreen) {
                
                [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
            } else {
                
                [self interfaceOrientation:UIInterfaceOrientationPortrait];
            }
        }
            break;
        case UIInterfaceOrientationLandscapeRight:{
            if (!self.isFullScreen) {
                
                [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
            } else {
                
                [self interfaceOrientation:UIInterfaceOrientationPortrait];
            }
        }
            break;
            
        default: {
            if (!self.isFullScreen) {
               
                [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
            } else {
                
                [self interfaceOrientation:UIInterfaceOrientationPortrait];
            }
        }
            break;
    }
    
}


/**
 *  强制屏幕转屏
 *
 *  @param orientation 屏幕方向
 */
- (void)interfaceOrientation:(UIInterfaceOrientation)orientation
{
    GLLog(@"强制屏幕旋转--comp")
    
    
    // arc下
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector             = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val                  = orientation;
        // 从2开始是因为0 1 两个参数已经被selector和target占用
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
    if (orientation == UIInterfaceOrientationLandscapeRight || orientation == UIInterfaceOrientationLandscapeLeft) {
        // 设置横屏
//        [self setOrientationLandscape];
        
    }else if (orientation == UIInterfaceOrientationPortrait) {
        // 设置竖屏
//        [self setOrientationPortrait];
        
    }
    
    /*
     // 非arc下
     if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
     [[UIDevice currentDevice] performSelector:@selector(setOrientation:)
     withObject:@(orientation)];
     }
     
     // 直接调用这个方法通不过apple上架审核
     [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationLandscapeRight] forKey:@"orientation"];
     */
}




- (UITableView *)rankTableView
{
    if (_rankTableView == nil) {
        UITableView *rankTableView = [[UITableView alloc] init];
        [self.contentScrView addSubview:rankTableView];
        _rankTableView = rankTableView;
        
        rankTableView.frame = CGRectMake(GLScreenW, 0, GLScreenW, self.contentScrView.glh_height);

        [rankTableView registerNib:[UINib nibWithNibName:@"socketChatListCell" bundle:nil] forCellReuseIdentifier:ID];

//        设置数据源
        rankTableView.dataSource = self;
        rankTableView.delegate = self;

        rankTableView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"f2f2f2"];
        rankTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _rankTableView;
}

#pragma mark - chatTableView --Delegate

//chatTableView总共有多少行.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return self.loveRankDataSource.count;
//    return self.tableViewDataSouce.count;
}

//chatTableView每行展示什么内容  【#import "UserInfoListItemView.h"】
- (socketChatListCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    socketChatListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    
    cell.model = self.loveRankDataSource[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    
    reward_rankItem *item = self.loveRankDataSource[indexPath.row];
    
    PublicOtherPersonVC *vc = [[UIStoryboard storyboardWithName:@"PublicOtherPersonVC" bundle:nil]instantiateInitialViewController];
    
    vc.user = item.user;
    
    //    vc.fromDynamicDetailVC = YES;
    vc.isSecVCPush = YES;
    
    if ([vc.user.uid isEqualToString:[LoginVM getInstance].readLocal._id] || vc.user.uid == nil) {
        return ;
    }
    
    [self.navigationController setHidesBottomBarWhenPushed:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        return ;
    }
    GLLog(@"%f",scrollView.contentOffset.x)
    
    [self.view endEditing:YES];
    
    [self.blueFlag mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.tableChangePanel.mas_bottom);
        make.leading.equalTo(@(scrollView.contentOffset.x * 0.5 + GLScreenW / 8));
        make.height.equalTo(@(3));
        make.width.equalTo(@(GLScreenW / 2 / 2));
    }];
    [self.view layoutIfNeeded];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - UIGestureRecognizerDelegate
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    // 输出点击的view的类名
//    
//    GLLog(@"%@",touch.view)
//    
//    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
//    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
//        return NO;
//    }
//    return  YES;
//}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if(touch.view != self.contentScrView){
        return NO;
    }else
        return YES;
}


@end
