//
//  XBLiveMobileVideoShowVC.m
//  JZBRelease
//
//  Created by zjapple on 16/9/13.
//  Copyright © 2016年 zjapple. All rights reserved.
//


//#import "SocketIO.h"
//#import "JZBRelease-Swift.h"
//#import "SocketIO.h"
//#import "SocketIO-Swift.h"
@import SocketIO;

#import "HttpBaseRequestItem.h"
#import "Defaults.h"
#import "XBLiveMobileVideoShowVC.h"
#import "AliVcMoiveViewController.h"
#import "RewardAlertView.h"
#import "DataBaseHelperSecond.h"
#import "StatusModel.h"
#import "AskAnswerList.h"
#import "LewPopupViewAnimationSpring.h"
#import "CustomAlertView.h"
#import "RewardModel.h"
#import "IntegralDetailVC.h"
#import "startNoticeView.h"
#import "Masonry.h"
#import "UIButton+CreateButton.h"
#import "avaIconCell.h"
#import "online_userItem.h"

#import "AppDelegate.h"

#import "ChatKeyBoard.h"
#import "MoreItem.h"
#import "FaceSourceManager.h"
#import "FaceThemeModel.h"
#import "ChatToolBarItem.h"

#import "GLAlertView_tip.h"
#import "DanmuLabel.h"

#import "DanmuCell.h"
#import "DanmuItem.h"
#import "PublicOtherPersonVC.h"

#import "MessageTableViewController.h"
#import "socketChatListCell.h"

//#import <IJKMediaFramework/IJKMediaFramework.h>

@interface XBLiveMobileVideoShowVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDelegate, UITableViewDataSource,ChatKeyBoardDataSource, ChatKeyBoardDelegate>

@property(nonatomic,strong) MessageTableViewController *messageVC;
@property(nonatomic, strong) NSMutableArray *msgList;

/** contentView Insite LoverankTableView */
@property (nonatomic, weak) UIView *loverankView;
/** rankTableView */
@property (nonatomic, weak) UITableView *rankTableView;

/** DanMuShowName */
@property (nonatomic, strong) NSString *DanMuShowName;
/** DanMuShowContent */
@property (nonatomic, strong) NSString *DanMuShowContent;
/** isFirst */
@property (nonatomic, assign) BOOL isFirst;

@property (nonatomic, strong) ChatKeyBoard *chatKeyBoard;

/** videoViewContr */
@property (nonatomic, weak) UIView *videoViewContr;

@property (nonatomic, strong) UITableView *chatTableView;
@property (nonatomic, strong) NSMutableArray *chatDataArray;
/** socket */
@property (nonatomic, strong) SocketIOClient *socket;
/** user */
@property (nonatomic, strong) Users *user;

@property (atomic, assign) BOOL noticeViewBlock;

@property (atomic, strong) NSURL *url;
//@property (atomic, retain) id <IJKMediaPlayback> player;
@property (weak, nonatomic) UIView *PlayerView;
/** 关注按钮 */
@property (nonatomic, weak) UIButton *FocusButton1;

@property (nonatomic,assign) BOOL paused;
@property (nonatomic,strong) NSTimer *progressUpdateTimer;
@property (nonatomic,assign) float volumeBeforeRamping;
@property (nonatomic,assign) int rampStep;
@property (nonatomic,assign) int rampStepCount;
@property (nonatomic,assign) bool rampUp;
@property (nonatomic,assign) SEL postRampAction;
@property (nonatomic,strong) NSTimer *playbackSeekTimer;
@property (nonatomic,strong) NSTimer *volumeRampTimer;
@property (nonatomic,strong) NSTimer *statisticsSnapshotTimer;
@property (nonatomic,assign) double seekToPoint;
@property (nonatomic,copy) NSURL *stationURL;
//@property (nonatomic,strong) UIBarButtonItem *infoButton;
//@property (nonatomic,readonly) FSLogger *stateLogger;
@property (nonatomic,assign) BOOL enableLogging;
@property (nonatomic,assign) BOOL initialBuffering;
@property (nonatomic,assign) UInt64 measurementCount;
@property (nonatomic,assign) UInt64 audioStreamPacketCount;
@property (nonatomic,assign) UInt64 bufferUnderrunCount;


//- (void)clearStatus;
//- (void)showStatus:(NSString *)status;
//- (void)showErrorStatus:(NSString *)status;
//- (void)updatePlaybackProgress;
//- (void)rampVolume;
//- (void)seekToNewTime;
//- (void)determineStationNameWithMetaData:(NSDictionary *)metaData;
//- (void)doSeeking;
//- (void)finalizeSeeking;
//- (void)snapshotStats;



/**
 * Reference to the play button.
 */
@property (nonatomic,strong) UIButton *playButton;
/**
 * Reference to the pause button.
 */
@property (nonatomic,strong) UIButton *pauseButton;

/**
 * Reference to the progress slider.
 */
@property (nonatomic,strong) UISlider *progressSlider;
/**
 * Reference to the label displaying the current playback time.
 */
@property (nonatomic,strong) UILabel *currentPlaybackTime;

@property (weak, nonatomic) IBOutlet UIView *videoView;
@property (weak, nonatomic) IBOutlet UILabel *liveTimeLabel;

@property (strong, nonatomic) TBMoiveViewController* currentView;

@property (weak, nonatomic) IBOutlet UIImageView *teacher_avaImageView;
@property (weak, nonatomic) IBOutlet UILabel *teacher_nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *teacher_companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *teacher_jobLabel;
@property (weak, nonatomic) IBOutlet UILabel *liveNumLabel;

@property (weak, nonatomic) IBOutlet UIImageView *join_userAvaImageView4;
@property (weak, nonatomic) IBOutlet UIImageView *join_userAvaImageView3;
@property (weak, nonatomic) IBOutlet UIImageView *join_userAvaImageView2;
@property (weak, nonatomic) IBOutlet UIImageView *join_userAvaImageView1;

/** join_userScrollV */
//@property (nonatomic, weak) UIScrollView *join_userScrollV;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *teacher_companyLabel_Widthconstraint;
@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UIView *seeLiveNumView;

@property (weak, nonatomic) IBOutlet UIView *userInfoView;
@property (weak, nonatomic) IBOutlet UIView *botView;
@property (weak, nonatomic) IBOutlet UIView *panelView;

@property (weak, nonatomic) UIImageView *avaIcon;

/** join_userScrollV */
@property (weak, nonatomic) UICollectionView *collectionV;

/** isMineInfo */
@property (nonatomic, assign) BOOL isMineInfo;

@property (weak, nonatomic) IBOutlet UIButton *payMoneyButton;

/** noticeview */
@property (nonatomic, weak) startNoticeView *noticeview;

/** dataSource */
@property (nonatomic, strong) NSArray *dataSource;

/** 11s定时器 */
@property (nonatomic, strong) NSTimer *timer;

/** topTeacherInfoView */
@property (nonatomic, weak) UIView *topTeacherInfoView;
/** fengexianRWcompanyLabel */
@property (nonatomic, weak) UIView *fengexianRWcompanyLabel;

@end

@implementation XBLiveMobileVideoShowVC

static NSString *ID = @"MobchatTableCELLID";

-(NSMutableArray *)msgList {
    if (_msgList == nil) {
        _msgList = [NSMutableArray array];
    }
    return _msgList;
}

- (Users *)user
{
    if (_user == nil) {
        _user = [[Users alloc] init];
    }
    return _user;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
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
    
    self.DanMuShowName = @"";
    self.DanMuShowContent = @"";
    
//    self.view.backgroundColor = [UIColor greenColor];
    
//    self.dataSource = [online_userItem mj_objectArrayWithKeyValuesArray:self.join_list_user];

    TBMoiveViewController* currentView = [[TBMoiveViewController alloc] init];
    
    if ([self.liveitem.type isEqualToString:@"2"]) {
        currentView.isVoice = YES;
    }else if ([self.liveitem.type isEqualToString:@"1"]) {
        currentView.clickVideoView = ^{
            
            GLLog(@"currentView.clickVideoView");
        
        };
    }
    
    self.currentView = currentView;
    
    
    // ***************************************************
    
//    NSURL *url = [NSURL URLWithString:@"http://live2.jianzhongbang.com/tset/aaa1234.m3u8"];
    
    /** 利哥的直播间 */
//    NSURL *url = [NSURL URLWithString:@"http://live2.jianzhongbang.com/test/aaa.flv"];
    
//     NSURL *url = [NSURL URLWithString:@"http://data.5sing.kgimg.com/G065/M08/12/13/gQ0DAFe1GXGADiwUAHTtcKc0Z0A129.mp3"];
    
//    AppDelegate *delegate = ((AppDelegate *)[[UIApplication sharedApplication] delegate]);
//    
//    if (!delegate.checkpay) {
//        self.playUrl = @"http://bang.jianzhongbang.com/1.mp4";
//    }
    
    // ***************************************************
    
    NSURL *url = [NSURL URLWithString:self.playUrl];
    
    [currentView SetMoiveSource:url];
    
    currentView.videoFrame = CGRectMake(0, 0, GLScreenW, GLScreenH);
    
    __weak typeof(self) weakSelf = self;
    currentView.callBack = ^(NSString *timeLabel,VideoActionType type){
        weakSelf.liveTimeLabel.text = timeLabel;
        if (type == VideoActionTypePreparedPlay) {
            if ([weakSelf.liveitem.type isEqualToString:@"2"]) return ;
            [weakSelf.noticeview removeFromSuperview];
        }
        
        if (type == VideoActionTypeClose) {
            [weakSelf closeWindow:nil];
        }
        
    };
    
    [self addChildViewController:currentView];
    [self.videoView addSubview:currentView.view];
    currentView.view.userInteractionEnabled = NO;
    
    [self setupTopInfo];
    
    
    if ([self.teacher.uid isEqualToString:[LoginVM getInstance].readLocal._id]) {
        self.isMineInfo = YES;
        self.payMoneyButton.enabled = NO;
    }
//    
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:11 target:self selector:@selector(timeUpdata:) userInfo:nil repeats:YES];
//
//    
    if (self.isBackVideo) {
        [self HiddenTopView];
        [self StartNotice];
    }else {
        
        [self StartNotice];
        
        self.currentView.isStartNotice = YES;
    }
    
    self.chatDataArray = [NSMutableArray array];
    
//    [self loadChatTableView];
    
    [self setupChatView];
    
    [self setUpSocket];
    
    [self setUpInputView];
    
    [self loverankView];
    
    //检查开关
    //    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    //    if (appDelegate.checkpay) {
    self.payMoneyButton.hidden = NO;
    //    }else{
    //        self.payMoneyButton.hidden = YES;
    //    }
    
}

#pragma mark - 老师信息
- (void)setupTeacherInfoView
{
    UIView *contentView = [UIView new];
    self.topTeacherInfoView = contentView;
    [self.view addSubview:contentView];
    contentView.frame = CGRectMake(0, 28, GLScreenW / 2, 44);
    contentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
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
    
//    [imageV sd_setImageWithURL:[NSURL URLWithString:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:self.teacher.avatar]] placeholderImage:[UIImage imageNamed:@"ZCCG_TX"]];
    
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
    
    // company 右边 分割线
    UIView *fengexianRWcompanyLabel = [UIView new];
    self.fengexianRWcompanyLabel = fengexianRWcompanyLabel;
    [contentView addSubview:fengexianRWcompanyLabel];
    
    fengexianRWcompanyLabel.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"bdbdbd"];
    
    [self.fengexianRWcompanyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(companyLabel.mas_top).offset(3);
        make.leading.equalTo(companyLabel.mas_trailing).offset(5);
        make.height.equalTo(@(companyLabel.glh_height - 6));
        make.width.equalTo(@(1));
    }];
    
    UILabel *jobLabel = [UILabel new];
    [contentView addSubview:jobLabel];
    jobLabel.frame = CGRectMake(companyLabel.glr_right + 12, nickNameLabel.glb_bottom + 5, 0, 0);
    jobLabel.text = self.teacher.job;
    jobLabel.font = [UIFont systemFontOfSize:12];
    [jobLabel sizeToFit];
    jobLabel.textColor = [UIColor whiteColor];
//    jobLabel.backgroundColor = [UIColor orangeColor];
    
    CGFloat maxW = contentView.glw_width - 20 - 10 -35 - 12 - 5;
    
    if (companyLabel.glw_width + jobLabel.glw_width > maxW) {
        
        if (companyLabel.glw_width > jobLabel.glw_width) {
            
            companyLabel.glw_width = maxW - jobLabel.glw_width - 5;
            
        }else {
            jobLabel.glw_width = maxW - companyLabel.glw_width - 5;
            
        }
        
//        companyLabel.glw_width = maxW / 2;
//        jobLabel.glw_width = maxW / 2;
        
        self.fengexianRWcompanyLabel.glx_x = companyLabel.glr_right - 1;
        
        jobLabel.glx_x = companyLabel.glr_right + 12;
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
//- (void)loadChatTableView {
//    
//    self.chatTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, GLScreenH - 250, GLScreenW - 20, 170) style:(UITableViewStylePlain)];
//    self.chatTableView.delegate = self;
//    self.chatTableView.dataSource = self;
//    self.chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
////    [self.chatTableView registerClass:[DanmuCell class] forCellReuseIdentifier:@"chatTableViewID"];
//    
//    [self.chatTableView registerNib:[UINib nibWithNibName:@"DanmuCell" bundle:nil] forCellReuseIdentifier:@"chatTableViewID"];
//    [self.view addSubview:self.chatTableView];
//    self.chatTableView.backgroundColor = [UIColor clearColor];
//    
//}

#pragma mark - 初始化socket
- (void)setUpSocket
{
//    DataBaseHelperSecond *db = [DataBaseHelperSecond getInstance];
//    [db initDataBaseDB];
//    self.user = [[Users alloc]init];
//    self.user.uid = [[[LoginVM getInstance]readLocal] _id];
//    self.user = (Users *)[db getModelFromTabel:self.user];
    
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
//            wself.collectionV.contentSize = CGSizeMake((30 + 3) * wself.dataSource.count, 0);
            
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

//- (DanmuCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    DanmuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chatTableViewID" forIndexPath:indexPath];
//    
//    cell.backgroundColor = [UIColor clearColor];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    
//    cell.model = self.chatDataArray[indexPath.row];
//    
//    return cell;
//}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [self InputViewDown];
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    [self InputViewDown];
}


#pragma mark RCIMClientReceiveMessageDelegate



#pragma mark buttonAction

//- (IBAction)sendButtonAction:(UIButton *)sender {
//    
//    HttpBaseRequestItem *item = [HttpBaseRequestItem new];
//    item.content = @"我:123";
//    item.name = self.user.nickname;
//    item.avatar = @"http://bang.jianzhongbang.com/Public/Admin/new/images/bg_icon.png";
//    item.id = self.user.uid;
//    
//    NSString *str2 = item.mj_JSONString;
//    
//    [self.socket emit:@"send_message" with:@[str2]];
//    
//    [self chatDataArrayAddMessageWithString:[NSString stringWithFormat:@"我:123"]];
//    
//    
//    
//}

#pragma mark - 点击视频view
- (IBAction)clickVideoView:(UIButton *)sender {
    
    if (![self.liveitem.type isEqualToString:@"1"]) return ;
    
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        [UIView animateWithDuration:0.35 animations:^{
            self.botView.alpha = 0;
            self.panelView.alpha = 1;
        }];
        
        
    }else {
        [UIView animateWithDuration:0.35 animations:^{
            self.botView.alpha = 1;
            self.panelView.alpha = 0;
        }];
        
        
    }
    
}

- (void)timeUpdata:(NSTimer *)timer
{

}

- (void)setupjoin_userScrollVAndCloseBtn
{
    
//    UIButton *btn = [UIButton createButtonWithFrame:nil FImageName:@"close" Target:self Action:@selector() Title:<#(NSString *)#>]
    
//    UIScrollView *scrV = [[UIScrollView alloc]init];
//    [self.topView addSubview:scrV];
//    
//    [scrV mas_makeConstraints:^(MASConstraintMaker *make) {
//    
//        make.left.equalTo(self.userInfoView.mas_right).offset(10);
//        make.centerY.equalTo(self.userInfoView);
//        make.right.equalTo(self.view).offset(-10);
//        
//    }];
//    
//    
//    scrV = self.join_userScrollV;
//    
//    for (int i = 0; i < self.join_list_user.count; ++i) {
//        UIImageView *avaIcon = [[UIImageView alloc]init];
//        
//        [scrV addSubview:avaIcon];
//        
//        if (i) {
//            [avaIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//                //                make.centerY.equalTo(avaIcon.superview.mas_centerY);
//                make.height.width.equalTo(@(30));
//                make.right.equalTo(self.avaIcon.mas_left).offset(-3);
//            }];
//        }else {
//            [avaIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(@(10));
//                make.height.width.equalTo(@(30));
//                make.right.equalTo(self.view).offset(-10);
//            }];
//        }
//
//        
//        Users *user = [Users mj_objectWithKeyValues:self.join_list_user[i][@"user"]];
//        
//        [avaIcon sd_setImageWithURL:[NSURL URLWithString:[AddHostToLoadPIC AddHostToLoadPICWithString:user.avatar]] placeholderImage:[UIImage imageNamed:@"ZCCG_TX"]];
//        
//        
//        self.avaIcon = avaIcon;
//    }
//    
//    scrV.contentSize = CGSizeMake(self.join_list_user.count * 30 + self.join_list_user.count *3, 0);
    
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
    collectionV.showsVerticalScrollIndicator = NO;
    collectionV.showsHorizontalScrollIndicator = NO;
    [self.topView addSubview:collectionV];
    [collectionV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topTeacherInfoView);
        make.right.equalTo(self.view).offset(-20);
        make.left.equalTo(self.topTeacherInfoView.mas_right).offset(20);
        make.height.equalTo(@(30));
    }];
    self.collectionV = collectionV;
    
    collectionV.backgroundColor = [UIColor clearColor];
    
    //步骤3 各种设置属性
//    collectionV.backgroundColor = [UIColor purpleColor];//背景分割线
    
//    UICollectionView
    
    collectionV.dataSource = self;
    collectionV.delegate = self;
    //步骤4注册cell
    [collectionV registerNib:[UINib nibWithNibName:@"avaIconCell" bundle:nil] forCellWithReuseIdentifier:@"avaIconCell"];
    self.collectionV.transform = CGAffineTransformRotate(self.collectionV.transform, M_PI);
}

- (void)setupTopInfo
{
//    [self.teacher_avaImageView sd_setImageWithURL:[NSURL URLWithString:[AddHostToLoadPIC AddHostToLoadPICWithString:self.teacher.avatar]] placeholderImage:[UIImage imageNamed:@"ZCCG_TX"]];
//    
//    self.teacher_nickNameLabel.text = self.teacher.nickname;
//    self.teacher_companyLabel.text = self.teacher.company;
//    self.teacher_jobLabel.text = self.teacher.job;
    
    [self setupTeacherInfoView];
    
    [self setupjoin_userScrollVAndCloseBtn];
    
    [self.teacher_companyLabel sizeToFit];
    [self.teacher_jobLabel sizeToFit];
    
    if (self.teacher_companyLabel.glw_width + self.teacher_jobLabel.glw_width < 120) {
        self.teacher_companyLabel_Widthconstraint.constant = self.teacher_companyLabel.glw_width;
    }
    
//    self.liveNumLabel.text = self.liveitem.online_count;
    self.liveNumLabel.text = @"0";
    
    self.teacher_avaImageView.layer.cornerRadius = self.teacher_avaImageView.glw_width * 0.5;
    self.teacher_avaImageView.clipsToBounds = YES;
    /** 
     
     //    if (self.teacher_companyLabel.glw_width < 60) {
     //        self.teacher_companyLabel_Widthconstraint.constant = self.teacher_companyLabel.glw_width;
     //    }
     
     //    if (self.join_list_user.count > 0) {
     //        Users *user4 = [Users mj_objectWithKeyValues:self.join_list_user[self.join_list_user.count - 1][@"user"]];
     //
     //        [self.join_userAvaImageView1 sd_setImageWithURL:[NSURL URLWithString:[AddHostToLoadPIC AddHostToLoadPICWithString:user4.avatar]] placeholderImage:[UIImage imageNamed:@"ZCCG_TX"]];
     //    }else if (self.join_list_user.count > 1) {
     //        Users *user3 = [Users mj_objectWithKeyValues:self.join_list_user[self.join_list_user.count - 2][@"user"]];
     //
     //        [self.join_userAvaImageView2 sd_setImageWithURL:[NSURL URLWithString:[AddHostToLoadPIC AddHostToLoadPICWithString:user3.avatar]] placeholderImage:[UIImage imageNamed:@"ZCCG_TX"]];
     //
     //    }else if (self.join_list_user.count > 2) {
     //        Users *user2 = [Users mj_objectWithKeyValues:self.join_list_user[self.join_list_user.count - 3][@"user"]];
     //
     //        [self.join_userAvaImageView3 sd_setImageWithURL:[NSURL URLWithString:[AddHostToLoadPIC AddHostToLoadPICWithString:user2.avatar]] placeholderImage:[UIImage imageNamed:@"ZCCG_TX"]];
     //
     //    }else if (self.join_list_user.count > 3) {
     //        Users *user1 = [Users mj_objectWithKeyValues:self.join_list_user[self.join_list_user.count - 4][@"user"]];
     //
     //        [self.join_userAvaImageView4 sd_setImageWithURL:[NSURL URLWithString:[AddHostToLoadPIC AddHostToLoadPICWithString:user1.avatar]] placeholderImage:[UIImage imageNamed:@"ZCCG_TX"]];
     //    }
     
     
     //
     //    self.join_userAvaImageView4.layer.cornerRadius = self.teacher_avaImageView.glw_width * 0.5;
     //    self.join_userAvaImageView4.clipsToBounds = YES;
     //
     //    self.join_userAvaImageView3.layer.cornerRadius = self.teacher_avaImageView.glw_width * 0.5;
     //    self.join_userAvaImageView3.clipsToBounds = YES;
     //
     //    self.join_userAvaImageView2.layer.cornerRadius = self.teacher_avaImageView.glw_width * 0.5;
     //    self.join_userAvaImageView2.clipsToBounds = YES;
     //
     //    self.join_userAvaImageView1.layer.cornerRadius = self.teacher_avaImageView.glw_width * 0.5;
     //    self.join_userAvaImageView1.clipsToBounds = YES;
     }
     
     
     
     if ([self.liveitem.type isEqualToString:@"2"]) {
     
     //        [self pushTest];
     
     //        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
     //        btn.frame = CGRectMake(100, 400, 100, 100);
     //
     //        [btn setTitle:@"点击跳转播放控制器" forState:UIControlStateNormal];
     //
     //        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
     //        
     //        [btn addTarget:self action:@selector(play_btn:) forControlEvents:UIControlEventTouchUpInside];
     //        
     //        [btn sizeToFit];
     //        
     //        [self.view addSubview:btn];
     
     */
    
//    [self setupFocusView];
    [self setupLoveRankClickView];
}

- (void)setupFocusView
{
    UIButton *FocusButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.FocusButton1 = FocusButton1;
    [FocusButton1 setImage:[UIImage imageNamed:@"ZB_follow"] forState:UIControlStateNormal];
//    [FocusButton1 setTitle:@"关注" forState:UIControlStateNormal];
    
//    [FocusButton1 setFont:[UIFont systemFontOfSize:13]];
    
    FocusButton1.frame = CGRectMake(93, 87.5, 0, 0);
    [FocusButton1 sizeToFit];
    
    FocusButton1.layer.cornerRadius = 5;
    FocusButton1.clipsToBounds = YES;
//    FocusButton1.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"2196f3"];
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

- (void)HiddenTopView
{
    self.seeLiveNumView.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.callBackDataS) {
        self.callBackDataS(self.question);
    }
    
}

//- (void)pushTest
//{
//    //直播视频
//    self.url = [NSURL URLWithString:self.playUrl];
//    _player = [[IJKFFMoviePlayerController alloc] initWithContentURL:self.url withOptions:nil];
//    
//    UIView *playerView = [self.player view];
//    
//    UIView *displayView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, 180)];
//    self.PlayerView = displayView;
//    self.PlayerView.backgroundColor = [UIColor blackColor];
////    [self.view addSubview:self.PlayerView];
//    
//    playerView.frame = self.PlayerView.bounds;
//    playerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    
//    [self.PlayerView insertSubview:playerView atIndex:1];
//    [_player setScalingMode:IJKMPMovieScalingModeAspectFill];
//    [self installMovieNotificationObservers];
//
//    if (![self.player isPlaying]) {
//        [self.player prepareToPlay];
//    }
//}

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
    
    noticeview.alpha = 0;
    
    noticeview.panelView.hidden = YES;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        noticeview.alpha = 1;
    });
    
    /** 音频点播的话不需要一些预告信息 */
    if ([self.liveitem.type isEqualToString:@"2"]) {
        
//        [self pushTest];
        
        noticeview.onClickPlayButton = ^(UIButton *btn){
            if (!btn.isSelected) {
                btn.selected = YES;
//                [self.player play];
            }else{
                btn.selected = NO;
//                [self.player pause];
            }
        };
        
//        noticeview.endDragSlider = ^(float value){
//            self.player.currentPlaybackTime = value;
//        };
        
        noticeview.panelView.hidden = NO;
        noticeview.isVoice = YES;
        self.currentView.activityBackgroundView1.hidden = YES;
        
        /** 以下的代码没用 */
        //**************************************
        noticeview.gly_y = GLScreenH * 0.3;
        
        UIView *view = [UIView new];
//        [noticeview addSubview:view];
        view.frame = CGRectMake(0, 155 - 44, GLScreenW, 44);
        [view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
        
        self.progressSlider = [[UISlider alloc]init];
        [view addSubview:self.progressSlider];
        self.progressSlider.frame = CGRectMake(45, 8, GLScreenW - 76 * 2, 30);
        
        self.progressSlider.value = 0.0;
        
        [self.progressSlider setMinimumValue:0];
        [self.progressSlider setMaximumValue:1];
        
        self.progressSlider.userInteractionEnabled = NO;
        
        //设置已经滑过一端滑动条颜色
        self.progressSlider.minimumTrackTintColor=[UIColor hx_colorWithHexRGBAString:@"ff9800"];
        //设置未滑过一端滑动条颜色
        self.progressSlider.maximumTrackTintColor=[UIColor whiteColor];
        
        //设置滑块图片背景
        [self.progressSlider setThumbImage:[UIImage imageNamed:@"ZBHF_ty"] forState:UIControlStateNormal];
        //[self.progressSlider addTarget:self action:@selector(seek:) forControlEvents:UIControlEventValueChanged];
        
        self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [view addSubview:self.playButton];
        [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@(38));
            make.left.top.equalTo(@(5));
        }];
        
        [self.playButton setImage:[UIImage imageNamed:@"ZBHF_BF"] forState:UIControlStateNormal];
        [self.playButton addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
        
        self.pauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [view addSubview:self.pauseButton];
        [self.pauseButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(self.playButton);
            make.left.top.equalTo(@(5));
        }];
        
        [self.pauseButton setImage:[UIImage imageNamed:@"ZBHF_ZT"] forState:UIControlStateNormal];
        
        [self.pauseButton addTarget:self action:@selector(pause:) forControlEvents:UIControlEventTouchUpInside];
        
        
        self.currentPlaybackTime = [UILabel new];
        [view addSubview:self.currentPlaybackTime];
        [self.currentPlaybackTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(30));
            make.width.equalTo(@(108));
            make.right.top.equalTo(@(-5));
            make.centerY.equalTo(view);
        }];
        
        [self.currentPlaybackTime setFont:[UIFont systemFontOfSize:15]];
        [self.currentPlaybackTime setTextAlignment:NSTextAlignmentRight];
        
        self.currentPlaybackTime.textColor = [UIColor whiteColor];
        [self.view layoutIfNeeded];
//        [self.currentPlaybackTime sizeToFit];
//        self.currentPlaybackTime.text = @"100000";
        
        /** 以上的代码没用 */
        //**************************************
        
    }
    
    /** 视频点播 也先【同上】这样吧 */
    if ([self.liveitem.type isEqualToString:@"1"]) {
        noticeview.isVoice = YES;
    }
    
    noticeview.liveitem = self.liveitem;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}

- (void)dealloc
{
    [self.currentView closePlayer];
    
    [self.noticeview removeFromSuperview];
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
    
//    if ([item.url containsString:@"http://"]) {
//        
//        SFSafariViewController *SafariViewController = [[SFSafariViewController alloc]initWithURL:[NSURL URLWithString:item.url]];
//        
//        [self presentModalViewController:SafariViewController animated:YES];
//    }
    
}

/** 点击问答列表 */
- (IBAction)ClickQuestionListButton:(UIButton *)sender {
    
    AskAnswerList *list = [AskAnswerList new];
    
    list.teacher = self.teacher;
    list.dataSource = self.question;
    list.class_id = self.class_id;
    
    __weak typeof(self) weakSelf = self;
    
    list.callBackDataS = ^(NSArray *dataSource){
        weakSelf.question = dataSource;
    };
    
    [self presentViewController:list animated:YES completion:^{
        weakSelf.noticeViewBlock = NO;
    }];
    
}

/** 点击评论 */
- (IBAction)ClickCommentButton:(UIButton *)sender {
    
   // 显示输入框，在输入框中 发送 消息
    [self InputViewUp];
    
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
    __weak XBLiveMobileVideoShowVC *wself = self;
    
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

- (IBAction)closeWindow:(UIButton *)sender {
    
    __weak typeof(self) weakSelf = self;
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        [weakSelf.currentView closePlayer];
        [weakSelf.noticeview removeFromSuperview];
    }];
}

/** 点击关闭 */
- (IBAction)ClickCloseButton:(UIButton *)sender {
    if ([self.liveitem.type isEqualToString:@"1"]) {
        self.liveitem.type = @"3";
        [self.navigationController popViewControllerAnimated:YES];
        return ;
    }
    
    GLAlertView_tip *view = [GLAlertView_tip glAlertView_tip];
    [self.view addSubview:view];
    view.center = CGPointMake(GLScreenW * 0.5, GLScreenH * 0.5);
    
    view.TtitleView.text = @"确定离开直播？";
    __weak typeof(self) weakSelf = self;
    view.enterButtonClick = ^{
        [weakSelf dismissViewControllerAnimated:YES completion:^{
            
            [weakSelf.currentView closePlayer];
            [weakSelf.noticeview removeFromSuperview];
        }];
    };

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


//*****************************
/** 
 
 - (void)setupVideo
 {
 __weak XBLiveMobileVideoShowVC *weakSelf = self;
 
 self.audioController.onStateChange = ^(FSAudioStreamState state) {
 switch (state) {
 case kFsAudioStreamRetrievingURL:
 weakSelf.enableLogging = NO;
 
 [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
 
 //                [weakSelf showStatus:@"Retrieving URL..."];
 
 //                weakSelf.statusLabel.text = @"";
 
 weakSelf.progressSlider.enabled = NO;
 weakSelf.playButton.hidden = YES;
 weakSelf.pauseButton.hidden = NO;
 weakSelf.paused = NO;
 
 //                [weakSelf.stateLogger logMessageWithTimestamp:@"State change: retrieving URL"];
 
 break;
 
 case kFsAudioStreamStopped:
 weakSelf.enableLogging = NO;
 
 [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
 
 //                weakSelf.statusLabel.text = @"";
 
 weakSelf.progressSlider.enabled = NO;
 weakSelf.playButton.hidden = NO;
 weakSelf.pauseButton.hidden = YES;
 weakSelf.paused = NO;
 
 //                [weakSelf.stateLogger logMessageWithTimestamp:@"State change: stopped"];
 
 break;
 
 case kFsAudioStreamBuffering: {
 if (weakSelf.initialBuffering) {
 weakSelf.enableLogging = NO;
 weakSelf.initialBuffering = NO;
 } else {
 weakSelf.enableLogging = YES;
 }
 
 NSString *bufferingStatus = nil;
 if (weakSelf.configuration.usePrebufferSizeCalculationInSeconds) {
 bufferingStatus = [[NSString alloc] initWithFormat:@"Buffering %f seconds...", weakSelf.audioController.activeStream.configuration.requiredPrebufferSizeInSeconds];
 } else {
 bufferingStatus = [[NSString alloc] initWithFormat:@"Buffering %i bytes...", (weakSelf.audioController.activeStream.continuous ? weakSelf.configuration.requiredInitialPrebufferedByteCountForContinuousStream :
 weakSelf.configuration.requiredInitialPrebufferedByteCountForNonContinuousStream)];
 }
 
 //                [weakSelf showStatus:bufferingStatus];
 
 [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
 weakSelf.progressSlider.enabled = NO;
 weakSelf.playButton.hidden = YES;
 weakSelf.pauseButton.hidden = NO;
 weakSelf.paused = NO;
 
 //                [weakSelf.stateLogger logMessageWithTimestamp:@"State change: buffering"];
 
 break;
 }
 
 case kFsAudioStreamSeeking:
 weakSelf.enableLogging = NO;
 
 //                [weakSelf showStatus:@"Seeking..."];
 
 [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
 weakSelf.progressSlider.enabled = NO;
 weakSelf.playButton.hidden = YES;
 weakSelf.pauseButton.hidden = NO;
 weakSelf.paused = NO;
 
 //                [weakSelf.stateLogger logMessageWithTimestamp:@"State change: seeking"];
 
 break;
 
 case kFsAudioStreamPlaying:
 weakSelf.enableLogging = YES;
 
 #if DO_STATKEEPING
 NSLog(@"%@", weakSelf.audioController.activeStream);
 #endif
 
 //                [weakSelf determineStationNameWithMetaData:nil];
 
 //                [weakSelf clearStatus];
 
 [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
 
 weakSelf.progressSlider.enabled = YES;
 
 if (!weakSelf.progressUpdateTimer) {
 weakSelf.progressUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
 target:weakSelf
 selector:@selector(updatePlaybackProgress)
 userInfo:nil
 repeats:YES];
 }
 
 if (weakSelf.volumeBeforeRamping > 0) {
 // If we have volume before ramping set, it means we were seeked
 
 #if PAUSE_AFTER_SEEKING
 [weakSelf pause:weakSelf];
 weakSelf.audioController.volume = weakSelf.volumeBeforeRamping;
 weakSelf.volumeBeforeRamping = 0;
 
 break;
 #else
 weakSelf.rampStep = 1;
 weakSelf.rampStepCount = 5; // 50ms and 5 steps = 250ms ramp
 weakSelf.rampUp = true;
 weakSelf.postRampAction = @selector(finalizeSeeking);
 
 weakSelf.volumeRampTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 // 50ms
 target:weakSelf
 selector:@selector(rampVolume)
 userInfo:nil
 repeats:YES];
 #endif
 }
 [weakSelf toggleNextPreviousButtons];
 weakSelf.playButton.hidden = YES;
 weakSelf.pauseButton.hidden = NO;
 weakSelf.paused = NO;
 
 //                [weakSelf.stateLogger logMessageWithTimestamp:@"State change: playing"];
 
 break;
 
 case kFsAudioStreamFailed:
 weakSelf.enableLogging = YES;
 
 [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
 weakSelf.progressSlider.enabled = NO;
 weakSelf.playButton.hidden = NO;
 weakSelf.pauseButton.hidden = YES;
 weakSelf.paused = NO;
 
 //                [weakSelf.stateLogger logMessageWithTimestamp:@"State change: failed"];
 
 break;
 case kFsAudioStreamPlaybackCompleted:
 weakSelf.enableLogging = NO;
 
 [weakSelf toggleNextPreviousButtons];
 
 //                [weakSelf.stateLogger logMessageWithTimestamp:@"State change: playback completed"];
 
 break;
 
 case kFsAudioStreamRetryingStarted:
 weakSelf.enableLogging = YES;
 
 //                [weakSelf showStatus:@"Attempt to retry playback..."];
 
 //                [weakSelf.stateLogger logMessageWithTimestamp:@"State change: retrying started"];
 
 break;
 
 case kFsAudioStreamRetryingSucceeded:
 weakSelf.enableLogging = YES;
 
 //                [weakSelf.stateLogger logMessageWithTimestamp:@"State change: retrying succeeded"];
 
 break;
 
 case kFsAudioStreamRetryingFailed:
 weakSelf.enableLogging = YES;
 
 //                [weakSelf showErrorStatus:@"Failed to retry playback"];
 
 //                [weakSelf.stateLogger logMessageWithTimestamp:@"State change: retrying failed"];
 
 break;
 
 default:
 break;
 }
 };
 
 self.audioController.onFailure = ^(FSAudioStreamError error, NSString *errorDescription) {
 NSString *errorCategory;
 
 switch (error) {
 case kFsAudioStreamErrorOpen:
 errorCategory = @"Cannot open the audio stream: ";
 break;
 case kFsAudioStreamErrorStreamParse:
 errorCategory = @"Cannot read the audio stream: ";
 break;
 case kFsAudioStreamErrorNetwork:
 errorCategory = @"Network failed: cannot play the audio stream: ";
 break;
 case kFsAudioStreamErrorUnsupportedFormat:
 errorCategory = @"Unsupported format: ";
 break;
 case kFsAudioStreamErrorStreamBouncing:
 errorCategory = @"Network failed: cannot get enough data to play: ";
 break;
 default:
 errorCategory = @"Unknown error occurred: ";
 break;
 }
 
 NSString *formattedError = [NSString stringWithFormat:@"%@ %@", errorCategory, errorDescription];
 
 //        [weakSelf.stateLogger logMessageWithTimestamp:[NSString stringWithFormat:@"Audio stream failure: %@", formattedError]];
 
 //        [weakSelf showErrorStatus:formattedError];
 };
 
 self.audioController.onMetaDataAvailable = ^(NSDictionary *metaData) {
 NSMutableString *streamInfo = [[NSMutableString alloc] init];
 
 //        [weakSelf determineStationNameWithMetaData:metaData];
 
 NSMutableDictionary *songInfo = [[NSMutableDictionary alloc] init];
 
 if (metaData[@"MPMediaItemPropertyTitle"]) {
 songInfo[MPMediaItemPropertyTitle] = metaData[@"MPMediaItemPropertyTitle"];
 } else if (metaData[@"StreamTitle"]) {
 songInfo[MPMediaItemPropertyTitle] = metaData[@"StreamTitle"];
 }
 
 if (metaData[@"MPMediaItemPropertyArtist"]) {
 songInfo[MPMediaItemPropertyArtist] = metaData[@"MPMediaItemPropertyArtist"];
 }
 
 [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songInfo];
 
 if (metaData[@"MPMediaItemPropertyArtist"] &&
 metaData[@"MPMediaItemPropertyTitle"]) {
 [streamInfo appendString:metaData[@"MPMediaItemPropertyArtist"]];
 [streamInfo appendString:@" - "];
 [streamInfo appendString:metaData[@"MPMediaItemPropertyTitle"]];
 } else if (metaData[@"StreamTitle"]) {
 [streamInfo appendString:metaData[@"StreamTitle"]];
 }
 
 if (metaData[@"StreamUrl"] && [metaData[@"StreamUrl"] length] > 0) {
 weakSelf.stationURL = [NSURL URLWithString:metaData[@"StreamUrl"]];
 
 //            weakSelf.navigationItem.rightBarButtonItem = weakSelf.infoButton;
 }
 
 if (metaData[@"CoverArt"]) {
 //            FSAppDelegate *delegate = [UIApplication sharedApplication].delegate;
 
 NSData *data = [[NSData alloc] initWithBase64EncodedString:metaData[@"CoverArt"] options:0];
 
 UIImage *coverArt = [UIImage imageWithData:data];
 
 //            delegate.window.backgroundColor = [UIColor colorWithPatternImage:coverArt];
 }
 
 //        [weakSelf.statusLabel setHidden:NO];
 //        weakSelf.statusLabel.text = streamInfo;
 
 //        [weakSelf.stateLogger logMessageWithTimestamp:[NSString stringWithFormat:@"Meta data received: %@", streamInfo]];
 };
 
 }
 
 
 - (IBAction)play:(id)sender
 {
 if (self.paused) {
 
 [self.audioController pause];
 self.paused = NO;
 } else {
 
 [self.audioController play];
 }
 
 self.playButton.hidden = YES;
 self.pauseButton.hidden = NO;
 }
 
 - (IBAction)pause:(id)sender
 {
 [self.audioController pause];
 
 self.paused = YES;
 
 self.playButton.hidden = NO;
 self.pauseButton.hidden = YES;
 
 //    [_stateLogger logMessageWithTimestamp:@"Player paused"];
 }
 
 - (IBAction)seek:(id)sender
 {
 _seekToPoint = self.progressSlider.value;
 
 NSLog(@"value = %f",self.progressSlider.value);
 
 //    [_stateLogger logMessageWithTimestamp:@"Seek requested"];
 
 [_progressUpdateTimer invalidate], _progressUpdateTimer = nil;
 
 [_playbackSeekTimer invalidate], _playbackSeekTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
 target:self
 selector:@selector(seekToNewTime)
 userInfo:nil
 repeats:NO];
 }
 
 - (void)seekToNewTime
 {
 self.progressSlider.enabled = NO;
 
 // Fade out the volume to avoid pops
 _volumeBeforeRamping = self.audioController.volume;
 
 NSLog(@"volume === %f",self.audioController.volume);
 
 if (_volumeBeforeRamping > 0) {
 _rampStep = 1;
 _rampStepCount = 5; // 50ms and 5 steps = 250ms ramp
 _rampUp = false;
 _postRampAction = @selector(doSeeking);
 
 _volumeRampTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 // 50ms
 target:self
 selector:@selector(rampVolume)
 userInfo:nil
 repeats:YES];
 } else {
 // Just directly seek, volume is already 0
 [self doSeeking];
 }
 }
 
 - (void)updatePlaybackProgress
 {
 if (self.audioController.activeStream.continuous) {
 self.progressSlider.enabled = NO;
 self.progressSlider.value = 0;
 self.currentPlaybackTime.text = @"";
 } else {
 self.progressSlider.enabled = YES;
 
 FSStreamPosition cur = self.audioController.activeStream.currentTimePlayed;
 FSStreamPosition end = self.audioController.activeStream.duration;
 
 self.progressSlider.value = cur.position;
 
 self.currentPlaybackTime.text = [NSString stringWithFormat:@"%i:%02i / %i:%02i",
 cur.minute, cur.second,
 end.minute, end.second];
 }
 
 //    self.bufferingIndicator.hidden = NO;
 //    self.prebufferStatus.hidden = YES;
 
 if (self.audioController.activeStream.contentLength > 0) {
 // A non-continuous stream, show the buffering progress within the whole file
 FSSeekByteOffset currentOffset = self.audioController.activeStream.currentSeekByteOffset;
 
 UInt64 totalBufferedData = currentOffset.start + self.audioController.activeStream.prebufferedByteCount;
 
 float bufferedDataFromTotal = (float)totalBufferedData / self.audioController.activeStream.contentLength;
 
 //        self.bufferingIndicator.progress = (float)currentOffset.start / self.audioController.activeStream.contentLength;
 
 // Use the status to show how much data we have in the buffers
 //        self.prebufferStatus.frame = CGRectMake(self.bufferingIndicator.frame.origin.x,
 //                                                self.bufferingIndicator.frame.origin.y,
 //                                                CGRectGetWidth(self.bufferingIndicator.frame) * bufferedDataFromTotal,
 //                                                5);
 //        self.prebufferStatus.hidden = NO;
 } else {
 // A continuous stream, use the buffering indicator to show progress
 // among the filled prebuffer
 //        self.bufferingIndicator.progress = (float)self.audioController.activeStream.prebufferedByteCount / _maxPrebufferedByteCount;
 }
 }
 
 
 - (void)doSeeking
 {
 FSStreamPosition pos = {0};
 pos.position = _seekToPoint;
 
 [self.audioController.activeStream seekToPosition:pos];
 }
 
 //- (FSAudioController *)audioController
 //{
 //    if (!_audioController) {
 //        _audioController = [[FSAudioController alloc] init];
 //        _audioController.delegate = self;
 //    }
 //    return _audioController;
 //}
 
 - (FSStreamConfiguration *)configuration
 {
 return _configuration;
 }
 
 //- (void)clearStatus
 //{
 //    [AJNotificationView hideCurrentNotificationViewAndClearQueue];
 //}
 
 //- (void)showStatus:(NSString *)status
 //{
 //    [self clearStatus];
 //
 //    [AJNotificationView showNoticeInView:[[[UIApplication sharedApplication] delegate] window]
 //                                    type:AJNotificationTypeDefault
 //                                   title:status
 //                         linedBackground:AJLinedBackgroundTypeAnimated
 //                               hideAfter:0];
 //}
 //
 //- (void)showErrorStatus:(NSString *)status
 //{
 //    [self clearStatus];
 //
 //    [AJNotificationView showNoticeInView:[[[UIApplication sharedApplication] delegate] window]
 //                                    type:AJNotificationTypeRed
 //                                   title:status
 //                               hideAfter:10];
 //}
 
 
 -(void)toggleNextPreviousButtons
 {
 //    if([self.audioController hasNextItem] || [self.audioController hasPreviousItem])
 //    {
 //        self.nextButton.hidden = NO;
 //        self.previousButton.hidden = NO;
 //        self.nextButton.enabled = [self.audioController hasNextItem];
 //        self.previousButton.enabled = [self.audioController hasPreviousItem];
 //    }
 //    else
 //    {
 //        self.nextButton.hidden = YES;
 //        self.previousButton.hidden = YES;
 //    }
 }
 
 */


// ***********
// ***********
// ***********
// ***********
// ***********


#pragma Selector func

//- (void)loadStateDidChange:(NSNotification*)notification {
//    IJKMPMovieLoadState loadState = _player.loadState;
//    
//    if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
//        NSLog(@"LoadStateDidChange: IJKMovieLoadStatePlayThroughOK: %d\n",(int)loadState);
//    }else if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
//        NSLog(@"loadStateDidChange: IJKMPMovieLoadStateStalled: %d\n", (int)loadState);
//    } else {
//        NSLog(@"loadStateDidChange: ???: %d\n", (int)loadState);
//    }
//}
//
//- (void)moviePlayBackFinish:(NSNotification*)notification {
//    int reason =[[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
//    switch (reason) {
//        case IJKMPMovieFinishReasonPlaybackEnded:
//            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackEnded: %d\n", reason);
//            break;
//            
//        case IJKMPMovieFinishReasonUserExited:
//            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonUserExited: %d\n", reason);
//            break;
//            
//        case IJKMPMovieFinishReasonPlaybackError:
//            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackError: %d\n", reason);
//            break;
//            
//        default:
//            NSLog(@"playbackPlayBackDidFinish: ???: %d\n", reason);
//            break;
//    }
//}
//
//- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification {
//    NSLog(@"mediaIsPrepareToPlayDidChange\n");
//    
//    [self.noticeview refreshMediaControl];
//    self.noticeview.smallPlayOrPause.selected = !self.noticeview.smallPlayOrPause.selected;
//    
//    
//    
//}
//
//- (void)moviePlayBackStateDidChange:(NSNotification*)notification {
//    switch (_player.playbackState) {
//        case IJKMPMoviePlaybackStateStopped:
//            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: stoped", (int)_player.playbackState);
//            break;
//            
//        case IJKMPMoviePlaybackStatePlaying:
//            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: playing", (int)_player.playbackState);
//            break;
//            
//        case IJKMPMoviePlaybackStatePaused:
//            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: paused", (int)_player.playbackState);
//            break;
//            
//        case IJKMPMoviePlaybackStateInterrupted:
//            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: interrupted", (int)_player.playbackState);
//            break;
//            
//        case IJKMPMoviePlaybackStateSeekingForward:
//        case IJKMPMoviePlaybackStateSeekingBackward: {
//            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: seeking", (int)_player.playbackState);
//            break;
//        }
//            
//        default: {
//            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: unknown", (int)_player.playbackState);
//            break;
//        }
//    }
//}
//
//#pragma Install Notifiacation
//
//- (void)installMovieNotificationObservers {
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(loadStateDidChange:)
//                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
//                                               object:_player];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(moviePlayBackFinish:)
//                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
//                                               object:_player];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
//                                                 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
//                                               object:_player];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(moviePlayBackStateDidChange:)
//                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
//                                               object:_player];
//    
//}
//
//- (void)removeMovieNotificationObservers {
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:IJKMPMoviePlayerLoadStateDidChangeNotification
//                                                  object:_player];
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:IJKMPMoviePlayerPlaybackDidFinishNotification
//                                                  object:_player];
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
//                                                  object:_player];
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
//                                                  object:_player];
//    
//}
//
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//- (IBAction)play_btn:(id)sender {
//    if (![self.player isPlaying]) {
//        [self.player play];
//    }else{
//        [self.player pause];
//    }
//}
//
//- (void)viewDidDisappear:(BOOL)animated {
//    [super viewDidDisappear:animated];
//    
//    [self.player shutdown];
//    [self removeMovieNotificationObservers];
//    
//}



// ***********
// ***********
// ***********
// ***********
// ***********
// ***********


@end
