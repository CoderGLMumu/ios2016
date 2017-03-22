//
//  XBLiveVideoShowVC.m
//  JZBRelease
//
//  Created by zjapple on 16/9/13.
//  Copyright © 2016年 zjapple. All rights reserved.
//

@import SocketIO;
//#import "SocketIO.h"
//#import "SocketIO-Swift.h"
//#import "SocketIO.h"
//#import "JZBRelease-Swift.h"
#import "Defaults.h"
#import "XBLiveVideoShowVC.h"

#import "AliVcMoiveViewController.h"
#import "online_userItem.h"
#import "Masonry.h"
#import "avaIconCell.h"
#import "UIButton+CreateButton.h"

#import "ChatKeyBoard.h"
#import "MoreItem.h"
#import "FaceSourceManager.h"
#import "FaceThemeModel.h"
#import "ChatToolBarItem.h"
#import "AskAnswerList.h"
#import "RewardAlertView.h"
#import "LewPopupViewAnimationSpring.h"
#import "CustomAlertView.h"
#import "RewardModel.h"
#import "IntegralDetailVC.h"
#import "startNoticeView.h"

#import "GLAlertView_tip.h"

#import "DanmuCell.h"
#import "DanmuItem.h"

#import "PublicOtherPersonVC.h"

#import "MessageTableViewController.h"
#import "socketChatListCell.h"

@interface XBLiveVideoShowVC () <UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDelegate, UITableViewDataSource,ChatKeyBoardDataSource, ChatKeyBoardDelegate>

@property(nonatomic,strong) MessageTableViewController *messageVC;
@property(nonatomic, strong) NSMutableArray *msgList;

/** contentView Insite LoverankTableView */
@property (nonatomic, weak) UIView *loverankView;
/** rankTableView */
@property (nonatomic, weak) UITableView *rankTableView;

@property (nonatomic, strong) ChatKeyBoard *chatKeyBoard;
/** videoViewContr */
@property (nonatomic, weak) UIView *videoViewContr;

@property (nonatomic, strong) UITableView *chatTableView;
@property (nonatomic, strong) NSMutableArray *chatDataArray;
/** socket */
@property (nonatomic, strong) SocketIOClient *socket;
/** user */
@property (nonatomic, strong) Users *user;
/** isMineInfo */
@property (nonatomic, assign) BOOL isMineInfo;
@property (atomic, assign) BOOL noticeViewBlock;
/** noticeview */
@property (nonatomic, weak) startNoticeView *noticeview;
/** 关注按钮 */
@property (nonatomic, weak) UIButton *FocusButton1;

@property (weak, nonatomic) IBOutlet UIView *videoView;
/** videoViewImageV */
@property (nonatomic, weak) UIImageView *videoViewImageV;

@property (strong, nonatomic) TBMoiveViewController* currentView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *userInfoView;

/** collectionV */
@property (nonatomic, weak) UICollectionView *collectionV;

/** dataSource */
@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, strong) NSArray *tableVdataSource;
@property (weak, nonatomic) IBOutlet UIImageView *teacher_avaImageView;
@property (weak, nonatomic) IBOutlet UILabel *teacher_nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *teacher_companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *teacher_jobLabel;
@property (weak, nonatomic) IBOutlet UILabel *liveNumLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *teacher_companyLabel_Widthconstraint;
@property (weak, nonatomic) IBOutlet UIView *botView;

@property (weak, nonatomic) UITableView *tableView;

/** topTeacherInfoView */
@property (nonatomic, weak) UIView *topTeacherInfoView;

@end

static NSString *ID = @"ViocechatTableCELLID";

@implementation XBLiveVideoShowVC

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

- (void)setupChatView
{
    //图文混排子控制器
    self.messageVC = [[MessageTableViewController alloc] init];
    self.messageVC.isMobShow = YES;
    [self.view addSubview:self.messageVC.tableView];
    //    self.messageVC.tableView.frame = CGRectMake(10, 20, self.view.bounds.size.width - 20, 300);
    
    //    self.messageVC.tableView.frame = CGRectMake(10, GLScreenH - 250, GLScreenW - 110, 170);
    [self.messageVC.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(170));
        make.leading.equalTo(self.view).offset(10);
        make.trailing.equalTo(self.view).offset(-110);
        make.top.equalTo(self.view).offset(GLScreenH - 250);
    }];
    
    //    [self.messageVC.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.edges.equalTo(contentView).width.insets(UIEdgeInsetsMake(0, 10, 0, 10));
    //    }];
    
    self.messageVC.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.messageVC.tableView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"f2f2f2"];
    
    self.messageVC.tableView.backgroundColor = [UIColor clearColor];
    
    self.messageVC.tableView.showsVerticalScrollIndicator = NO;
    
    //赋值,自动刷新,滚动到最后一行
    self.messageVC.msgList = self.msgList;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.user = [[LoginVM getInstance] users];
    
//    self.dataSource = [online_userItem mj_objectArrayWithKeyValuesArray:self.join_list_user];
    
    TBMoiveViewController* currentView = [[TBMoiveViewController alloc] init];
    self.currentView = currentView;
//    NSURL *url = [NSURL URLWithString:@"http://live2.jianzhongbang.com/tset/aaa1234.m3u8"];
    
    NSURL *url = [NSURL URLWithString:self.playUrl];
    
    [currentView SetMoiveSource:url];
    
    [self setupVideoUpPicView];
//    [self.view layoutIfNeeded];
    
    currentView.videoFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.videoView.glh_height);
    __weak typeof(self) weakSelf = self;
    currentView.callBack = ^(NSString *timeLabel,VideoActionType type){
//        weakSelf.liveTimeLabel.text = timeLabel;
        if (type == VideoActionTypePreparedPlay) {
            if ([weakSelf.liveitem.type isEqualToString:@"2"]) return ;
            [weakSelf.noticeview removeFromSuperview];
            weakSelf.videoViewImageV.hidden = NO;
            [weakSelf setupyuyinTip];
        }
    };
    
    [self addChildViewController:currentView];
    [self.videoView addSubview:currentView.view];
    
    currentView.view.hidden = YES;
    
    [self setupTopInfo];
    
    [self setupjoin_userScrollVAndCloseBtn];
    
    [self StartNotice];
    
//    [self setupSayInfoView];
    
    self.chatDataArray = [NSMutableArray array];
    
//    [self loadChatTableView];
    
    [self setupChatView];
    
    [self setUpSocket];
    
    [self setUpInputView];
    
}

//- (void)setupSayInfoView
//{
//    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, GLScreenW, GLScreenH -106 - 190 - 50) style:UITableViewStylePlain];
//    self.tableView = tableView;
//    [self.botView addSubview:tableView];
//    tableView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"f2f2f2"];
//    tableView.dataSource = self;
//    tableView.delegate = self;
//    
//    [tableView registerClass:[UITableView class] forCellReuseIdentifier:@"SayInfoCell"];
//}

#pragma mark - viewWillAppear设置 导航条出现
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - 预告view
- (void)StartNotice
{
    [self.view layoutIfNeeded];
    
    if (self.noticeViewBlock) {
        return ;
    }else{
        self.noticeViewBlock = YES;
    }
    
    startNoticeView *noticeview = [startNoticeView startNoticeView];
    [self.view addSubview:noticeview];
    self.noticeview = noticeview;
    noticeview.glx_x = 0;
    noticeview.gly_y = GLScreenH * 0.35;
    noticeview.glw_width = GLScreenW;
    noticeview.glh_height = 155;
//    noticeview.contentMode = UIViewContentModeScaleAspectFill;
    
    noticeview.alpha = 0;
    
    noticeview.panelView.hidden = YES;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        noticeview.alpha = 1;
    });
    
    
    noticeview.liveitem = self.liveitem;
}


- (void)tapvideoView:(UITapGestureRecognizer *)tap
{
    [self InputViewDown];
    
}

- (void)setUpInputView
{
    
    self.chatKeyBoard = [ChatKeyBoard keyBoardWithNavgationBarTranslucent:YES];
    self.chatKeyBoard.delegate = self;
    self.chatKeyBoard.dataSource = self;
    self.chatKeyBoard.placeHolder = @"输入小于20个字的评论";
    self.chatKeyBoard.allowMore = NO;
    //    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    //    if (appDelegate.audioSwitch) {
    //        self.chatKeyBoard.allowVoice = YES;
    //    }else{
    //        self.chatKeyBoard.allowVoice = NO;
    //    }
    self.chatKeyBoard.allowVoice = NO;
    
    self.chatKeyBoard.allowFace = NO;
    
    [self.view addSubview:self.chatKeyBoard];
    self.chatKeyBoard.hidden = YES;
}


// init TableView
- (void)loadChatTableView {
    
    self.chatTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, GLScreenH - 250, GLScreenW - 20, 170) style:(UITableViewStylePlain)];
    self.chatTableView.delegate = self;
    self.chatTableView.dataSource = self;
    self.chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.chatTableView registerNib:[UINib nibWithNibName:@"DanmuCell" bundle:nil] forCellReuseIdentifier:@"chatTableViewID"];
    [self.view addSubview:self.chatTableView];
    self.chatTableView.backgroundColor = [UIColor clearColor];
    
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
    item.avatar = self.user.avatar;
    
    item.id = self.user.uid;
    
    NSString *str = item.mj_JSONString;
    
    GLLog(@"mj_JSONString%@",str)
    
    //    NSDictionary *dict2 = @{@"log": item.avatar, item.avatar: @"123"};
    
    NSDictionary *dict = @{@"log": @YES, @"forcePolling": @YES,@"connectParams":@{@"room":self.liveitem.aid}};
    
//    NSURL* url = [[NSURL alloc] initWithString:@"http://120.77.48.254:7274/"];
    NSURL* url = [[NSURL alloc] initWithString:@"http://test.jianzhongbang.com:7274/"];
    self.socket = [[SocketIOClient alloc] initWithSocketURL:url config:dict];
    
    __weak typeof(self) wself = self;
    
    [self.socket on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
        GLLog(@"socket connected");
        
        [wself.socket emit:@"join" with:@[str]];
        
        [wself.socket on:@"result_user" callback:^(NSArray* data, SocketAckEmitter* ack) {
            GLLog(@"result_user%@%lu",data,data.count);
            
            // 设置在线用户信息
            
            NSArray *joinCount = data[1];
            
            wself.liveNumLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)joinCount.count + wself.liveitem.online_count2.integerValue];
            
            // 头像
            wself.dataSource = [HttpBaseRequestItem mj_objectArrayWithKeyValuesArray:joinCount];
            //            HttpBaseRequestItem *item = wself.dataSource[0];
            wself.collectionV.contentSize = CGSizeMake((30 + 3) * wself.dataSource.count, 0);
            
            [wself.collectionV reloadData];
            
            //            self.DanMuShowName = data[0];
            //            self.DanMuShowContent = @"";
            //            self.isFirst = YES;
            //            DanmuItem *model = [DanmuItem new];
            //            model.fisrtName = data[0];
            //            model.content_black = @"";
            //            model.isfisrtLabel = YES;
            //
            //            [wself.chatDataArray addObject:model];
            //
            //            [wself.chatTableView reloadData];
            //
            //            [wself chatDataArrayAddMessageWithString:data[0]];
            
            
            
            
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
            model.content_green_mob = data[0];
            model.is_greencontent_mob = YES;
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
            
            //            if ([model.allstring isEqualToString:@" "]) {
            //
            //            }else {
            //                [wself.msgList addObject:model];
            //
            //                wself.messageVC.msgList = wself.msgList;
            //            }
            
        }];
        
        [wself.socket on:@"result_message" callback:^(NSArray* data, SocketAckEmitter* ack) {
            
            GLLog(@"gaolinTTTresult_message%@",data);
            
            NSDictionary *info = data[1];
            
            HttpBaseRequestItem *item = [HttpBaseRequestItem mj_objectWithKeyValues:info];
            
            //            self.DanMuShowName = item.name;
            //            self.DanMuShowContent = item.content;
            //            self.isFirst = NO;
            
            //            DanmuItem *model = [DanmuItem new];
            //            model.userName = item.name;
            //            model.content_black = item.content;
            //            model.isfisrtLabel = NO;
            //
            //            [wself.chatDataArray addObject:model];
            //
            //            [wself.chatTableView reloadData];
            //
            //            [wself chatDataArrayAddMessageWithString:[NSString stringWithFormat:@"%@：%@",item.name,item.content]];
            
            
            DanmuItem *model = [DanmuItem new];
            
            if ([item.vip isEqualToString:@"0"]) {
                model.isvip = YES;
            }else {
                model.isvip = NO;
            }
            
            model.userName = [NSString stringWithFormat:@"%@：",item.name];
            
            // 0 评论，1 打赏
            if ([item.message_type isEqualToString:@"0"]) {
                
                model.content_white_mob = item.content;
                model.is_whitecontent_mob = YES;
                
            }else if ([item.message_type isEqualToString:@"1"]) {
                
                model.content_blue_mob = item.content;
                model.is_bluecontent_mob = YES;
            }
            
            //            model.content_black = item.content;
            //            model.is_blackcontent = YES;
            model.allstring = [NSString stringWithFormat:@" %@：%@",item.name,item.content];
            if (model.isvip) {
                model.allstring = [NSString stringWithFormat:@" %@：%@",item.name,item.content];
            }else{
                model.allstring = [NSString stringWithFormat:@"%@：%@",item.name,item.content];
            }
            
            [wself.msgList addObject:model];
            
            wself.messageVC.msgList = wself.msgList;
            
            
            
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

// reload dataArray
- (void)chatDataArrayAddMessageWithString:(NSString *)messageString {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
//        [self.chatDataArray addObject:messageString];
//        
//        [self.chatTableView reloadData];
        
        // 滑动到底部
        [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(self.chatDataArray.count - 1) inSection:0] atScrollPosition:(UITableViewScrollPositionBottom) animated:YES];
        
    });
}

#pragma mark - 老师信息
- (void)setupTeacherInfoView
{
    UIView *contentView = [UIView new];
    self.topTeacherInfoView = contentView;
    [self.view addSubview:contentView];
    contentView.frame = CGRectMake(0, 28, GLScreenW / 2, 44);
    contentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    
    
    //    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(120, 10, 80, 80)];
    //    view2.backgroundColor = [UIColor redColor];
    //    [self.view addSubview:view2];
    
    // 半边圆角
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:contentView.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(contentView.glh_height / 2, contentView.glh_height / 2)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = contentView.bounds;
    maskLayer.path = maskPath.CGPath;
    contentView.layer.mask = maskLayer;
    
    UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
    [contentView addSubview:imageV];
    imageV.frame = CGRectMake(10, 5, 35, 35);
    imageV.layer.cornerRadius = imageV.glw_width / 2;
    imageV.clipsToBounds = YES;
    //    imageV.backgroundColor = [UIColor yellowColor];
    
//    [imageV sd_setImageWithURL:[NSURL URLWithString:[AddHostToLoadPIC AddHostToLoadPICWithString:self.teacher.avatar]] placeholderImage:[UIImage imageNamed:@"ZCCG_TX"]];
    
    [LocalDataRW getImageWithDirectory:Directory_XB RetalivePath:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:self.teacher.avatar] WithContainerImageView:imageV];
    
    //    self.teacher_companyLabel.text = self.teacher.company;
    //    self.teacher_jobLabel.text = self.teacher.job;
    
    UILabel *nickNameLabel = [UILabel new];
    [contentView addSubview:nickNameLabel];
    nickNameLabel.frame = CGRectMake(imageV.glr_right + 5, 5, 0, 0);
    nickNameLabel.text = self.teacher.nickname;
    nickNameLabel.font = [UIFont systemFontOfSize:14];
    [nickNameLabel sizeToFit];
    nickNameLabel.textColor = [UIColor whiteColor];
    //    nickNameLabel.backgroundColor = [UIColor orangeColor];
    
    if (self.teacher.vip.uid) {
        UIImageView *vipIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"VIPicon"]];
        [contentView addSubview:vipIV];
        vipIV.frame = CGRectMake(nickNameLabel.glr_right + 5, 8, vipIV.glw_width, vipIV.glh_height);
        //        vipIV.backgroundColor = [UIColor yellowColor];
    }
    
    
    UILabel *companyLabel = [UILabel new];
    [contentView addSubview:companyLabel];
    companyLabel.frame = CGRectMake(imageV.glr_right + 5, nickNameLabel.glb_bottom + 5, 0, 0);
    companyLabel.text = self.teacher.company;
    companyLabel.font = [UIFont systemFontOfSize:12];
    [companyLabel sizeToFit];
    companyLabel.textColor = [UIColor whiteColor];
    //    companyLabel.backgroundColor = [UIColor orangeColor];
    
    UILabel *jobLabel = [UILabel new];
    [contentView addSubview:jobLabel];
    jobLabel.frame = CGRectMake(companyLabel.glr_right + 5, nickNameLabel.glb_bottom + 5, 0, 0);
    jobLabel.text = self.teacher.job;
    jobLabel.font = [UIFont systemFontOfSize:12];
    [jobLabel sizeToFit];
    jobLabel.textColor = [UIColor whiteColor];
    //    jobLabel.backgroundColor = [UIColor orangeColor];
    
    CGFloat maxW = contentView.glw_width - 20 - 10 -35 - 5 - 5;
    
    if (companyLabel.glw_width + jobLabel.glw_width > maxW) {
        
        if (companyLabel.glw_width > jobLabel.glw_width) {
            
            companyLabel.glw_width = maxW - jobLabel.glw_width - 5;
            
        }else {
            jobLabel.glw_width = maxW - companyLabel.glw_width - 5;
            
        }
        
        //        companyLabel.glw_width = maxW / 2;
        //        jobLabel.glw_width = maxW / 2;
        jobLabel.glx_x = companyLabel.glr_right + 5;
    }
    
    UIButton *tipButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:tipButton1];
    [self.view bringSubviewToFront:tipButton1];
    
    tipButton1.frame = contentView.frame;
    //    tipButton1.frame = CGRectMake(0, 0, contentView.glw_width, contentView.glh_height);
    //    [tipButton1 setBackgroundColor:[UIColor clearColor]];
    [tipButton1 addTarget:self action:@selector(tipButton1Active:) forControlEvents:UIControlEventTouchUpInside];
    //    tipButton1.userInteractionEnabled = YES;
    //    contentView.userInteractionEnabled = YES;
}

- (void)tipButton1Active:(UIButton *)btn
{
    
    PublicOtherPersonVC *vc = [[UIStoryboard storyboardWithName:@"PublicOtherPersonVC" bundle:nil]instantiateInitialViewController];
    
    Users *user = [Users new];
    user.uid = self.teacher.uid;
    
    vc.user = user;
    
    //    vc.fromDynamicDetailVC = YES;
    vc.isSecVCPush = YES;
    if ([vc.user.uid isEqualToString:[LoginVM getInstance].readLocal._id] || vc.user.uid == nil) {
        return ;
    }
    [self.navigationController setHidesBottomBarWhenPushed:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    /** 全部列表页面的空数据占位图片 */
    //    notDataShowView *view;
    
    //    if (self.loveRankDataSource.count) {
    //        if ([notDataShowView sharenotDataShowView].superview) {
    //            [[notDataShowView sharenotDataShowView] removeFromSuperview];
    //        }
    //    }else {
    //        view = [notDataShowView sharenotDataShowView:tableView];
    //        [tableView addSubview:view];
    //
    //    }
    
    //    return self.chatDataArray.count;
    return self.loveRankDataSource.count;
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
    return 64 + 10;
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
//    [self InputViewDown];
}

- (void)setupTopInfo
{
//    [self.teacher_avaImageView sd_setImageWithURL:[NSURL URLWithString:[AddHostToLoadPIC AddHostToLoadPICWithString:self.teacher.avatar]] placeholderImage:[UIImage imageNamed:@"ZCCG_TX"]];
//    
//    self.teacher_nickNameLabel.text = self.teacher.nickname;
//    self.teacher_companyLabel.text = self.teacher.company;
//    self.teacher_jobLabel.text = self.teacher.job;
    
    [self setupTeacherInfoView];
    
    [self.teacher_companyLabel sizeToFit];
    [self.teacher_jobLabel sizeToFit];
    
    if (self.teacher_companyLabel.glw_width + self.teacher_jobLabel.glw_width < 120) {
        self.teacher_companyLabel_Widthconstraint.constant = self.teacher_companyLabel.glw_width;
    }
    
//    self.liveNumLabel.text = self.liveitem.online_count;
    self.liveNumLabel.text = @"0";
    
    self.teacher_avaImageView.layer.cornerRadius = self.teacher_avaImageView.glw_width * 0.5;
    self.teacher_avaImageView.clipsToBounds = YES;
    
//    [self setupFocusView];
    [self setupLoveRankClickView];
}

- (void)setupFocusView
{
    UIButton *FocusButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.FocusButton1 = FocusButton1;
    //    [tipButton1 setImage:[UIImage imageNamed:@"RMzlt_tipIcon"] forState:UIControlStateNormal];
    [FocusButton1 setTitle:@"关注" forState:UIControlStateNormal];
    
    [FocusButton1 setFont:[UIFont systemFontOfSize:13]];
    
    FocusButton1.frame = CGRectMake(93, 87.5, 0, 0);
    [FocusButton1 sizeToFit];
    
    FocusButton1.layer.cornerRadius = 5;
    FocusButton1.clipsToBounds = YES;
    FocusButton1.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"2196f3"];
    [FocusButton1 addTarget:self action:@selector(addFans) forControlEvents:UIControlEventTouchUpInside];
    
    FocusButton1.glw_width = 40;
    FocusButton1.glh_height = 22;
    [self.view addSubview:FocusButton1];
    
    if ([self.teacher.is_fllow integerValue] == 1) {
        FocusButton1.hidden = YES;
    }else{
        FocusButton1.hidden = NO;
    }
    
}

- (void)setupLoveRankClickView
{
    UIView *LoveRankClickView = [UIView new];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickRankView)];
    [self.view addSubview:LoveRankClickView];
    [LoveRankClickView addGestureRecognizer:tap];
    LoveRankClickView.frame = CGRectMake(0, 120, 110, 27);
    
    UIImageView *BGView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ZB_xybdBG"]];
    [LoveRankClickView addSubview:BGView];
    BGView.frame = CGRectMake(0, 0, LoveRankClickView.glw_width, LoveRankClickView.glh_height);
    
    UIImageView *indView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ZB_more"]];
    [LoveRankClickView addSubview:indView];
    indView.frame = CGRectMake(LoveRankClickView.glw_width - 23, 6, indView.glw_width, indView.glh_height);
    
    UIButton *LoveRankClickButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [LoveRankClickButton2 setImage:[UIImage imageNamed:@"ZB_heart"] forState:UIControlStateNormal];
    [LoveRankClickButton2 setTitle:@"心意榜单" forState:UIControlStateNormal];
    
    [LoveRankClickButton2 setFont:[UIFont systemFontOfSize:13]];
    LoveRankClickButton2.frame = CGRectMake(-10, 0, LoveRankClickView.glw_width, LoveRankClickView.glh_height);
    LoveRankClickButton2.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 8);
    LoveRankClickButton2.userInteractionEnabled = NO;
    
    [LoveRankClickView addSubview:LoveRankClickButton2];
    
}

- (UIView *)loverankView
{
    if (_loverankView == nil) {
        UIView *loverankView = [[UIView alloc] init];
        _loverankView = loverankView;
        [self.view addSubview:loverankView];
        //        loverankView.frame = CGRectMake(100, 100, GLScreenW, GLScreenH);
        [loverankView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.view);
            make.trailing.equalTo(self.view);
            make.top.equalTo(self.mas_bottomLayoutGuide);
            make.height.equalTo(@(GLScreenH * 0.397));
        }];
        loverankView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"f8f8f8"];
        
        [loverankView layoutIfNeeded];
        
        UILabel *TtitleLabel = [UILabel new];
        [loverankView addSubview:TtitleLabel];
        TtitleLabel.frame = CGRectMake(loverankView.glx_x + 10, 13, 0, 0);
        TtitleLabel.text = @"心意榜单";
        TtitleLabel.font = [UIFont systemFontOfSize:15];
        [TtitleLabel sizeToFit];
        TtitleLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"212121"];
        
        UIButton *closeLVButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeLVButton setImage:[UIImage imageNamed:@"ZB_close2"] forState:UIControlStateNormal];
        
        [loverankView addSubview:closeLVButton];
        
        //        [closeLVButton setFont:[UIFont systemFontOfSize:15]];
        
        [closeLVButton setTitleColor:[UIColor hx_colorWithHexRGBAString:@"757575"] forState:UIControlStateNormal];
        
        closeLVButton.frame = CGRectMake(GLScreenW - 35 - 10, 6, 35, 35);
        
        //        closeLVButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 22);
        
        // tipButton1.userInteractionEnabled = NO;
        
        [closeLVButton addTarget:self action:@selector(closeLVButtonActive:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *fengexian1 = [UIView new];
        [loverankView addSubview:fengexian1];
        
        fengexian1.frame = CGRectMake(0, TtitleLabel.glb_bottom + 13 , GLScreenW, 1);
        
        fengexian1.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"bdbdbd"];
        
        
        UITableView *rankTableView = [[UITableView alloc] init];
        [loverankView addSubview:rankTableView];
        _rankTableView = rankTableView;
        
        rankTableView.frame = CGRectMake(0, fengexian1.glb_bottom, GLScreenW, GLScreenH * 0.397 - fengexian1.glb_bottom);
        
        [rankTableView registerNib:[UINib nibWithNibName:@"socketChatListCell" bundle:nil] forCellReuseIdentifier:ID];
        
        //        设置数据源
        rankTableView.dataSource = self;
        rankTableView.delegate = self;
        
        rankTableView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"f8f8f8"];
        rankTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _loverankView;
}

- (void)closeLVButtonActive:(UIButton *)btn
{
    GLLog(@"closeLVButtonActive--closeLVButtonActive")
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.loverankView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(GLScreenH));
        }];
        [self.view layoutIfNeeded];
    }];
    
}

- (void)clickRankView
{
    //    [Toast makeShowCommen:@"功能暂未开发" ShowHighlight:@"" HowLong:1];
    
    [self setupvideoViewContr];
    
    [self.view bringSubviewToFront:self.loverankView];
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.loverankView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(GLScreenH - self.loverankView.glh_height));
        }];
        [self.view layoutIfNeeded];
    }];
    
}

-(void)addFans{
    
    NSDictionary *parameters = @{
                                 @"access_token":[LoginVM getInstance].readLocal.token,
                                 @"uid":self.teacher.uid
                                 };
    
    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/Fans/add"] parameters:parameters success:^(id json) {
        
        if ([json[@"state"] isEqual:@(0)]) {
            //        [SVProgressHUD show];
        }
        
        [SVProgressHUD showSuccessWithStatus:@"成功关注"];
        //        [self.btn setTitle:@"取消关注" forState:UIControlStateNormal];
        //        [self.btn setBackgroundImage:[UIImage imageNamed:@"WDZY_SX"] forState:UIControlStateNormal];
        //        [self.btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        self.FocusButton1.hidden = YES;
        
        GLLog(@"TTT--json%@",json);
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)setupyuyinTip
{
    UILabel *tipInfo = [UILabel new];
    tipInfo.text = @"正在进行语音直播";
    tipInfo.font = [UIFont systemFontOfSize:17];
    tipInfo.textColor = [UIColor hx_colorWithHexRGBAString:@"f19d37"];
    [self.view addSubview:tipInfo];
    [tipInfo sizeToFit];
    tipInfo.glx_x = GLScreenW * 0.5 - tipInfo.glw_width * 0.5;
    tipInfo.gly_y = 172;
    tipInfo.textAlignment = NSTextAlignmentCenter;
    tipInfo.transform = CGAffineTransformMakeScale(1.5, 1.5);
    tipInfo.numberOfLines = 0;
}

- (void)setupVideoUpPicView
{
    
    UIImageView *view = [[UIImageView alloc]init];
    [self.videoView addSubview:view];
    view.backgroundColor = [UIColor blackColor];
    view.frame = CGRectMake(0, 60, GLScreenW, 155);
    view.contentMode = UIViewContentModeScaleToFill;
    
    view.hidden = YES;
    
//    [view sd_setImageWithURL:[NSURL URLWithString:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:self.liveitem.thumb2]] placeholderImage:nil];
    
    [view sd_setImageWithURL:[NSURL URLWithString:[LocalDataRW getImageAllStr:self.liveitem.thumb2]] placeholderImage:nil];
    
    self.videoViewImageV = view;
}

- (void)setupjoin_userScrollVAndCloseBtn
{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    //初始化步骤1创建FlowLayout
    layout.itemSize = CGSizeMake(32, 30);//决定cell宽高
    
    layout.minimumInteritemSpacing = 3;//这两个属性决定cell间距离
    layout.minimumLineSpacing = 3;
    
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //初始化步骤2
    //使用FlowLayout创建UICollectionView
    UICollectionView *collectionV = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
    collectionV.userInteractionEnabled = YES;
    //    collectionV.alwaysBounceVertical = YES;
    collectionV.alwaysBounceHorizontal = YES;
    [self.topView addSubview:collectionV];
    [collectionV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topTeacherInfoView);
        make.right.equalTo(self.view).offset(-20);
        make.left.equalTo(self.topTeacherInfoView.mas_right).offset(20);
        make.height.equalTo(@(30));
    }];
    self.collectionV = collectionV;
    //步骤3 各种设置属性
    //    collectionV.backgroundColor = [UIColor purpleColor];//背景分割线
    
    //    UICollectionView
    
    collectionV.dataSource = self;
    collectionV.delegate = self;
    //步骤4注册cell
    [collectionV registerNib:[UINib nibWithNibName:@"avaIconCell" bundle:nil] forCellWithReuseIdentifier:@"avaIconCell"];
    
    self.collectionV.transform = CGAffineTransformRotate(self.collectionV.transform, M_PI);
    
    collectionV.contentSize = CGSizeMake((30 + 3) * self.dataSource.count, 0);
    
//    UIButton *btn = [UIButton createButtonWithFrame:CGRectMake(0, 0, 0, 0) FImageName:@"close" Target:self Action:@selector(closeWindow:) Title:nil];
//    [self.topView addSubview:btn];
//    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.userInfoView);
//        make.right.equalTo(self.view).offset(-10);
//        make.height.width.equalTo(@(30));
//    }];

}

- (void)dealloc
{
//    [self.noticeview removeFromSuperview];
    [self.videoView removeFromSuperview];
    [self.currentView removeFromParentViewController];
    
    [self disMissSocket];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    avaIconCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"avaIconCell" forIndexPath:indexPath];
    
    //    cell.backgroundColor = [UIColor redColor];
    
    // 设置直播在线用户头像2
    cell.item = self.dataSource[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HttpBaseRequestItem *item = self.dataSource[indexPath.item];
    
    PublicOtherPersonVC *vc = [[UIStoryboard storyboardWithName:@"PublicOtherPersonVC" bundle:nil]instantiateInitialViewController];
    
    Users *user = [Users new];
    user.uid = item.id;
    
    vc.user = user;
    
    //    vc.fromDynamicDetailVC = YES;
    vc.isSecVCPush = YES;
    if ([vc.user.uid isEqualToString:[LoginVM getInstance].readLocal._id] || vc.user.uid == nil) {
        return ;
    }
    [self.navigationController setHidesBottomBarWhenPushed:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController pushViewController:vc animated:YES];
    
}

///** 点击关闭 */
- (IBAction)closeWindow:(UIButton *)sender {
    
    __weak typeof(self) weakSelf = self;
    
    GLAlertView_tip *view = [GLAlertView_tip glAlertView_tip];
    [self.view addSubview:view];
    view.center = CGPointMake(GLScreenW * 0.5, GLScreenH * 0.5);
    
    view.TtitleView.text = @"确定离开直播？";
    
    view.enterButtonClick = ^{
        [weakSelf dismissViewControllerAnimated:YES completion:^{
            [weakSelf.currentView closePlayer];
            [weakSelf.noticeview removeFromSuperview];
        }];
    };
    
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 100;
//}


/** 点击问答列表 */
- (IBAction)ClickQuestionListButton:(UIButton *)sender {
    
    AskAnswerList *list = [AskAnswerList new];
    
    list.teacher = self.teacher;
    list.dataSource = self.question;
    list.class_id = self.class_id;
    
    list.callBackDataS = ^(NSArray *dataSource){
        self.question = dataSource;
    };
    
    [self presentViewController:list animated:YES completion:^{
        self.noticeViewBlock = NO;
    }];
    
}

/** 点击评论 */
- (IBAction)ClickCommentButton:(UIButton *)sender {
    
    // 显示输入框，在输入框中 发送 消息
    [self InputViewUp];
    
    
    
    //    self.videoView.frame = CGRectMake(0, 0, GLScreenW, 250);
    //
    //    self.currentView.videoFrame = CGRectMake(0, 0, GLScreenW, 250);
    //    [self.videoView addSubview:self.currentView.view];
    //    self.chatKeyBoard.gly_y -= 250;
}

/** 点击打赏 */
- (IBAction)ClickPayButton:(UIButton *)sender {
    //  AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [self.view endEditing:YES];
    
    RewardAlertView *view = [RewardAlertView defaultPopupView];
    view.parentVC = self;
    view.isfromLiveToPrese = YES;
    
    Users *users = [[Users alloc]init];
    users.uid = [[LoginVM getInstance] readLocal]._id;
    users = (Users *)[[DataBaseHelperSecond getInstance] getModelFromTabel:users];
    
    [view.balanceLabel setText:users.money];
    __weak XBLiveVideoShowVC *wself = self;
    
    __weak typeof(self) weakSelf = self;
    
    view.sendAction = ^(Clink_Type clink_type,NSString *howmuch){
        
        if (clink_type == Clink_Type_Three) {
            IntegralDetailVC *vc = [[UIStoryboard storyboardWithName:@"IntegralDetailVC" bundle:nil] instantiateInitialViewController];
            
            vc.isFromPreseVC = YES;
            
            [self presentViewController:vc animated:YES completion:^{
                
            }];
        }
        
        if (clink_type == Clink_Type_One) {
            if ([users.money integerValue] < [howmuch integerValue]) {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"打赏失败" message:@"原因：您的余额不足" delegate:wself cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
                return ;
            }
            //            CustomAlertView *alertView = [CustomAlertView defaultCustomAlertView:@"支付中..."];
            //            [wself lew_presentPopupView:alertView animation:[LewPopupViewAnimationSpring new]];
            
            [SVProgressHUD showWithStatus:@"支付中..."];
            
            [UIApplication sharedApplication].keyWindow.userInteractionEnabled = NO;
            RewardModel *rewardModel = [[RewardModel alloc]init];
            rewardModel.access_token = [[LoginVM getInstance] readLocal].token;
            rewardModel.id = self.class_id;
            
            rewardModel.score = howmuch;
            
            SendAndGetDataFromNet *sendAndGet = [[SendAndGetDataFromNet alloc]init];
            sendAndGet.returnModel = ^(GetValueObject *obj,int state){
                if (1 == state) {
                    [SVProgressHUD showSuccessWithStatus:@"打赏完成"];
                    //                    [alertView.label setText:@"支付完成"];
                    
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
                        [wself lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
                        [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
                    });
                }else{
                    if (self.isMineInfo) {
                        [SVProgressHUD showErrorWithStatus:@"不能打赏自己"];
                        return ;
                    }
                    //                    [alertView.label setText:@"支付失败"];
                    [SVProgressHUD showErrorWithStatus:@"没有打赏,有需要联系我们"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [wself lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
                        [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
                    });
                }
            };
            
            [sendAndGet commenDataFromNet:rewardModel WithRelativePath:@"Reward_CourseTime_URL"];
        }
        
    };
    
    //    __block CellLayout *wlayout = layout;
    //    view.sendAction = ^(Clink_Type clink_type,NSString *howMuch){
    //        if (clink_type == Clink_Type_One) {
    ////            self.passwordView = [[PasswordView alloc]initWithFrame:self.view.frame];
    ////            self.tabBarController.tabBar.hidden = YES;
    ////            self.passwordView.vc = self;
    //            self.passwordView.returnData = ^(NSString *passwordStr){
    //                NSLog(@"%@",passwordStr);
    //                if ([users.score integerValue] < [howMuch integerValue]) {
    //                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"打赏失败" message:@"原因：您的余额不足" delegate:wself cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    //                    [alertView show];
    //                    return ;
    //                }
    //                CustomAlertView *alertView = [CustomAlertView defaultCustomAlertView:@"支付中..."];
    //                [wself lew_presentPopupView:alertView animation:[LewPopupViewAnimationSpring new]];
    //                [UIApplication sharedApplication].keyWindow.userInteractionEnabled = NO;
    //                RewardModel *rewardModel = [[RewardModel alloc]init];
    //                rewardModel.access_token = [[LoginVM getInstance] readLocal].token;
    //                rewardModel.dynamic_id = statusModel.id;
    //                rewardModel.score = howMuch;
    //                SendAndGetDataFromNet *sendAndGet = [[SendAndGetDataFromNet alloc]init];
    //                sendAndGet.returnModel = ^(GetValueObject *obj,int state){
    //                    if (1 == state) {
    //                        [alertView.label setText:@"支付完成"];
    //                        [[DataBaseHelperSecond getInstance] delteModelFromTabel:users];
    //                        [[DataBaseHelperSecond getInstance] insertModelToTabel:users];
    //                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //                            [wself lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
    //                            [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
    //                            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(wlayout.rewardNumPosition.origin.x, wlayout.rewardNumPosition.origin.y - 2 * wlayout.rewardNumPosition.size.width, wlayout.rewardNumPosition.size.width, wlayout.rewardNumPosition.size.height)];
    //                            [label setTextColor:[UIColor redColor]];
    //                            [label setText:@"+1"];
    //                            [cell addSubview:label];
    //                            [UIView animateWithDuration:1 animations:^{
    //                                label.frame = wlayout.rewardNumPosition;
    //                            } completion:^(BOOL finished) {
    //                                [label removeFromSuperview];
    //                                statusModel.reward_count = [NSNumber numberWithInteger:[statusModel.reward_count integerValue] + 1];
    //                                _titleArr = @[[NSString stringWithFormat:@"评论 %@",self.statusModel.evaluation_count],[NSString stringWithFormat:@"打赏 %@",statusModel.reward_count],];
    //                                wself.dydHeaderView = nil;
    //                                wself.selectTools = nil;
    //                                [wself.tableView reloadData];
    //                            }];
    //                        });
    //                    }else{
    //                        [alertView.label setText:@"支付失败"];
    //                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //                            [wself lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
    //                            [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
    //                        });
    //                    }
    //                };
    //                [sendAndGet commenDataFromNet:rewardModel WithRelativePath:@"Reward_Data"];
    //            };
    //            [self.view addSubview:self.passwordView];
    //            [self.passwordView Action];
    //        }
    //    };
    
    [self lew_presentPopupView:view animation:[LewPopupViewAnimationSpring new] dismissed:^{
        NSLog(@"动画结束");
    }];
    
}

/** 点击分享 */
- (IBAction)ClickShareButton:(UIButton *)sender {
    
    
    
}


#pragma 文本改变
- (void)chatKeyBoardTextViewDidChange:(UITextView *)textView{
    if (textView.text.length > 20) {
        [Toast makeShowCommen:@"您评论字数不要超过" ShowHighlight:@"20" HowLong:0.8];
        [textView setText:[textView.text substringToIndex:20]];
    }
}

#pragma mark -- 发送文本
- (void)chatKeyBoardSendText:(NSString *)text
{
    
    [[HttpManager shareManager] netStatus:^(AFNetworkReachabilityStatus status) {
        if(status == AFNetworkReachabilityStatusReachableViaWWAN || status ==AFNetworkReachabilityStatusReachableViaWiFi){
            
        }else{
            [Toast makeShowCommen:@"您的网络有问题 " ShowHighlight:@"请重置" HowLong:1.2];
            return ;
        }
    }];
    
    if (!(text.length > 0)) {
        return;
    }
    
    //    HttpBaseRequestItem *item = [HttpBaseRequestItem new];
    //    item.content = [NSString stringWithFormat:@"%@",text];
    //    item.name = self.user.nickname;
    //    item.avatar = self.user.avatar;
    //    item.id = self.user.uid;
    //
    //    NSString *str2 = item.mj_JSONString;
    //
    //    [self.socket emit:@"send_message" with:@[str2]];
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
    
    [self InputViewDown];
    
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

- (void)InputViewUp
{
    [self setupvideoViewContr];
    
    self.chatKeyBoard.hidden = NO;
    [self.chatKeyBoard keyboardUp];
    
    
    if (IS_IPHONE_5 || IS_IPHONE_4) {
        
    }else {
        self.chatTableView.gly_y = GLScreenH / 2 - 180;
    }
    
    
}

- (void)InputViewDown
{
    self.chatKeyBoard.hidden = YES;
    [self.chatKeyBoard keyboardDown];
    
    if (IS_IPHONE_5 || IS_IPHONE_4) {
        
    }else {
        self.chatTableView.gly_y = GLScreenH - 250;
    }
    
    [self closeLVButtonActive:nil];
    
    [self.videoViewContr removeFromSuperview];
}

- (void)setupvideoViewContr
{
    UIView *videoViewContr = [UIView new];
    videoViewContr.frame = self.view.frame;
    videoViewContr.backgroundColor = [UIColor clearColor];
    [self.view addSubview:videoViewContr];
    
    self.videoViewContr = videoViewContr;
    
    UITapGestureRecognizer *tapVideoView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapvideoView:)];
    [videoViewContr addGestureRecognizer:tapVideoView];
}


@end
