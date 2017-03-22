//
//  AlivcLiveViewController.m
//  DevAlivcLiveVideo
//
//  Created by yly on 16/3/21.
//  Copyright © 2016年 Alivc. All rights reserved.
//


/**
 *  杭州短趣传媒网络技术有限公司
 *  POWERED BY QUPAI
 */
@import SocketIO;
//#import "SocketIO.h"
//#import "SocketIO-Swift.h"
//#import "JZBRelease-Swift.h"
//@import SocketIO;
//#import "SocketIO.h"

#import "HttpBaseRequestItem.h"

#import "AlivcLiveViewController.h"
#import <AlivcLiveVideo/AlivcLiveVideo.h>
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
#import "AskAnswerList.h"
#import "Defaults.h"
#import "Masonry.h"
#import "avaIconCell.h"

#import "GLAlertView_tip.h"

#import "DanmuCell.h"
#import "DanmuItem.h"

#import "PublicOtherPersonVC.h"

#import "MessageTableViewController.h"
#import "socketChatListCell.h"

@interface AlivcLiveViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,AlivcLiveSessionDelegate,UITableViewDelegate, UITableViewDataSource>

/** videoViewContr */
@property (nonatomic, weak) UIView *videoViewContr;
/** fengexianRWcompanyLabel */
@property (nonatomic, weak) UIView *fengexianRWcompanyLabel;

@property(nonatomic,strong) MessageTableViewController *messageVC;
@property(nonatomic, strong) NSMutableArray *msgList;

/** contentView Insite LoverankTableView */
@property (nonatomic, weak) UIView *loverankView;
/** rankTableView */
@property (nonatomic, weak) UITableView *rankTableView;

/** tipInfo */
@property (nonatomic, weak) UILabel *YYtipInfo;

/** join_userScrollV */
@property (weak, nonatomic) UICollectionView *collectionV;
/** dataSource */
@property (nonatomic, strong) NSArray *dataSource;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *userInfoView;

@property (nonatomic, strong) UITableView *chatTableView;
@property (nonatomic, strong) NSMutableArray *chatDataArray;

@property (nonatomic, strong) CTCallCenter *callCenter;
@property (weak, nonatomic) IBOutlet UIButton *startLiveButton;

@property (weak, nonatomic) IBOutlet UIImageView *teacher_avaImageView;
@property (weak, nonatomic) IBOutlet UILabel *teacher_nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *teacher_companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *teacher_jobLabel;
@property (weak, nonatomic) IBOutlet UILabel *liveNumLabel;

//@property (weak, nonatomic) IBOutlet UIImageView *join_userAvaImageView4;
//@property (weak, nonatomic) IBOutlet UIImageView *join_userAvaImageView3;
//@property (weak, nonatomic) IBOutlet UIImageView *join_userAvaImageView2;
//@property (weak, nonatomic) IBOutlet UIImageView *join_userAvaImageView1;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *teacher_companyLabel_Widthconstraint;

@property (weak, nonatomic) UILabel *tipInfo;

/** socket */
@property (nonatomic, strong) SocketIOClient *socket;
/** user */
@property (nonatomic, strong) Users *user;
/** videoViewImageV */
@property (nonatomic, weak) UIImageView *videoViewImageV;

/** timer */
@property (nonatomic, strong) NSTimer *timer;

/** topTeacherInfoView */
@property (nonatomic, weak) UIView *topTeacherInfoView;

@end

@implementation AlivcLiveViewController{
    AlivcLiveSession *_liveSession;
    NSString *_url;
//    NSTimer *_timer;
    NSTimer *_timer10s;
    
    NSFileHandle *_handle;
    AVCaptureDevicePosition _currentPosition;
    NSUInteger _last;
    NSMutableArray *_logArray;
    
    CGFloat _lastPinchDistance;
    
    BOOL _isCTCallStateDisconnected;
}

static NSString *ID = @"TeacherMobchatTableCELLID";

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

#pragma mark - viewWillAppear设置 导航条出现
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil url:(NSString *)url{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    _url = url;
    return self;
}

- (void)setupAnimaTitle
{
    UILabel *tipInfo = [UILabel new];
    tipInfo.font = [UIFont systemFontOfSize:50];
    tipInfo.textColor = [UIColor hx_colorWithHexRGBAString:@"f19d37"];
    [self.view addSubview:tipInfo];
    tipInfo.frame = CGRectMake(0, 0, GLScreenW, GLScreenH);
    self.tipInfo = tipInfo;
    tipInfo.textAlignment = NSTextAlignmentCenter;
    tipInfo.alpha = 0;
    tipInfo.transform = CGAffineTransformMakeScale(1.5, 1.5);
    tipInfo.numberOfLines = 0;
}

- (void)setupAnima:(NSString *)content
{
    self.tipInfo.text = content;
    
    [UIView animateWithDuration:1 delay:0.25 usingSpringWithDamping:8 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.tipInfo.alpha = 1;
        self.tipInfo.transform = CGAffineTransformMakeScale(0.9, 0.9);
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.25 animations:^{
                self.tipInfo.alpha = 0;
                self.tipInfo.transform = CGAffineTransformMakeScale(0.3, 0.3);
            }completion:^(BOOL finished) {
                self.startLiveButton.enabled = YES;
                self.tipInfo.transform = CGAffineTransformMakeScale(1.5, 1.5);
            }];
        });
    }];
    
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
    
    self.liveNumLabel.text = @"0";
    
    self.user = [[LoginVM getInstance] users];
    
    [self setupAnimaTitle];
    
    _logArray = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    
//    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
//    [self.view addGestureRecognizer:gesture];
//    
//    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGesture:)];
//    [self.view addGestureRecognizer:pinch];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeUpdate) userInfo:nil repeats:YES];
    
    [self testPushCapture];
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"log.txt"];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
    _handle = [NSFileHandle fileHandleForWritingAtPath:path];
    
    [self setupChatView];
    
    [self setupTopInfo];
    [self setupjoin_userScrollVAndCloseBtn];
    
    self.chatDataArray = [NSMutableArray array];
//    
//    [self loadChatTableView];
//
    [self setUpSocket];
    
    [self loverankView];
    
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
//    GLLog(@"mj_JSONString%@",str)
//    GLLog(@"mj_JSONString%@",str)
    
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
            
            wself.liveNumLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)joinCount.count + wself.liveitem.online_count2.integerValue ];
            
            // 头像
            wself.dataSource = [HttpBaseRequestItem mj_objectArrayWithKeyValuesArray:joinCount];
//            
           // HttpBaseRequestItem *item = wself.dataSource[0];

            wself.collectionV.contentSize = CGSizeMake((30 + 3) * wself.dataSource.count, 0);
            [wself.collectionV reloadData];
            
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
            
            

            
        }];
        
        [wself.socket on:@"result_message" callback:^(NSArray* data, SocketAckEmitter* ack) {
            
            GLLog(@"gaolinTTTresult_message%@",data);
            
            NSDictionary *info = data[1];
            
            HttpBaseRequestItem *item = [HttpBaseRequestItem mj_objectWithKeyValues:info];
            
            // 下面 显示 是评论  或者  打赏的消息
            
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
        }];
        
    }];
    
    [self.socket connect];
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
    
//    [imageV sd_setImageWithURL:[NSURL URLWithString:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:self.liveitem.teacher.avatar]] placeholderImage:[UIImage imageNamed:@"ZCCG_TX"]];
    
    [imageV sd_setImageWithURL:[NSURL URLWithString:[LocalDataRW getImageAllStr:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:self.liveitem.teacher.avatar]]] placeholderImage:[UIImage imageNamed:@"ZCCG_TX"]];
    
    //    self.teacher_companyLabel.text = self.teacher.company;
    //    self.teacher_jobLabel.text = self.teacher.job;
    
    UILabel *nickNameLabel = [UILabel new];
    [contentView addSubview:nickNameLabel];
    nickNameLabel.frame = CGRectMake(imageV.glr_right + 5, 5, 0, 0);
    nickNameLabel.text = self.liveitem.teacher.nickname;
    nickNameLabel.font = [UIFont systemFontOfSize:14];
    [nickNameLabel sizeToFit];
    nickNameLabel.textColor = [UIColor whiteColor];
    //    nickNameLabel.backgroundColor = [UIColor orangeColor];
    
    if (self.liveitem.teacher.vip.uid) {
        UIImageView *vipIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"VIPicon"]];
        [contentView addSubview:vipIV];
        vipIV.frame = CGRectMake(nickNameLabel.glr_right + 5, 8, vipIV.glw_width, vipIV.glh_height);
        //        vipIV.backgroundColor = [UIColor yellowColor];
    }
    
    
    UILabel *companyLabel = [UILabel new];
    [contentView addSubview:companyLabel];
    companyLabel.frame = CGRectMake(imageV.glr_right + 5, nickNameLabel.glb_bottom + 5, 0, 0);
    companyLabel.text = self.liveitem.teacher.company;
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
    jobLabel.text = self.liveitem.teacher.job;
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
    user.uid = self.liveitem.teacher.uid;
    
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

#pragma mark - 初始化socket
- (void)disMissSocket
{
//    [self.socket emit:@"disconnect" with:@[]];
    [self.socket disconnect];
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
//    
//    if (self.chatDataArray.count) {
//        if ([notDataShowView sharenotDataShowView].superview) {
//            [[notDataShowView sharenotDataShowView] removeFromSuperview];
//        }
//    }else {
//        view = [notDataShowView sharenotDataShowView:tableView];
//        [tableView addSubview:view];
//        
//    }
//    
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

#pragma mark RCIMClientReceiveMessageDelegate



#pragma mark buttonAction

- (IBAction)sendButtonAction:(UIButton *)sender {
    
    HttpBaseRequestItem *item = [HttpBaseRequestItem new];
    item.content = @"我:123";
    item.name = self.user.nickname;
    item.avatar = @"http://bang.jianzhongbang.com/Public/Admin/new/images/bg_icon.png";
    item.id = self.user.uid;
    
    NSString *str2 = item.mj_JSONString;
    
    [self.socket emit:@"send_message" with:@[str2]];
    
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
    [self.view addSubview:collectionV];
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

- (void)setTeacher:(Users *)teacher
{
    _teacher = teacher;
    
//    [self.teacher_avaImageView sd_setImageWithURL:[NSURL URLWithString:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:self.liveitem.teacher.avatar]] placeholderImage:[UIImage imageNamed:@"ZCCG_TX"]];
    
    [self.teacher_avaImageView sd_setImageWithURL:[NSURL URLWithString:[LocalDataRW getImageAllStr:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:self.liveitem.teacher.avatar]]] placeholderImage:[UIImage imageNamed:@"ZCCG_TX"]];
    
    self.teacher_nickNameLabel.text = self.liveitem.teacher.nickname;
    self.teacher_companyLabel.text = self.liveitem.teacher.company;
    self.teacher_jobLabel.text = self.liveitem.teacher.job;
    
    [self.teacher_companyLabel sizeToFit];
    [self.teacher_jobLabel sizeToFit];
    
    if (self.teacher_companyLabel.glw_width + self.teacher_jobLabel.glw_width < 120) {
        self.teacher_companyLabel_Widthconstraint.constant = self.teacher_companyLabel.glw_width;
    }

    
}


- (void)setupTopInfo
{

//    [self.teacher_avaImageView sd_setImageWithURL:[NSURL URLWithString:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:self.teacher.avatar]] placeholderImage:[UIImage imageNamed:@"ZCCG_TX"]];
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
//    self.teacher_avaImageView.layer.cornerRadius = self.teacher_avaImageView.glw_width * 0.5;
//    self.teacher_avaImageView.clipsToBounds = YES;
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
    
    [self setupLoveRankClickView];
    
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

- (void)InputViewUp
{
    [self setupvideoViewContr];
    
}

- (void)InputViewDown
{

    [self closeLVButtonActive:nil];
    
    [self.videoViewContr removeFromSuperview];
}

- (void)timeUpdate{
    AlivcLDebugInfo *i = [_liveSession dumpDebugInfo];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:i.connectStatusChangeTime];
    
    NSMutableString *msg = [[NSMutableString alloc] init];
    [msg appendFormat:@"CycleDelay(%0.2fms)\n",i.cycleDelay];
    [msg appendFormat:@"bitrate(%zd) buffercount(%zd)\n",[_liveSession alivcLiveVideoBitRate] ,_liveSession.dumpDebugInfo.localBufferVideoCount];
    [msg appendFormat:@" efc(%zd) pfc(%zd)\n",i.encodeFrameCount, i.pushFrameCount];
    [msg appendFormat:@"%0.2ffps %0.2fKB/s %0.2fKB/s\n", i.fps,i.encodeSpeed, i.speed/1024];
    [msg appendFormat:@"%lluB pushSize(%lluB) status(%zd) %@",i.localBufferSize, i.pushSize, i.connectStatus, date];
    [msg appendFormat:@" %0.2fms\n",i.localDelay];
    [msg appendFormat:@"video_pts:%zd\naudio_pts:%zd\n", i.currentVideoPTS,i.currentAudioPTS];
    
    //    NSLog(@"%@", msg);
    
    _textView.text = msg;
    
    
    
    [_logArray addObject:msg];
    
    //    NSLog(@"%@", i.eventArray);
    
    
    [HttpToolSDK getHTMLDataWithURL:@"https://cdn.aliyuncs.com/?Action=DescribeLiveStreamOnlineUserNum&DomainName=live2.jianzhongbang.com" parameters:nil success:^(id json) {
        
        GLLog(@"json-json%@",json);
//        NSLog(@"json-json%@",json);
//        NSLog(@"json-json%@",json);
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)tapGesture:(UITapGestureRecognizer *)gesture{
    CGPoint point = [gesture locationInView:self.view];
    CGPoint percentPoint = CGPointZero;
    percentPoint.x = point.x / CGRectGetWidth(self.view.bounds);
    percentPoint.y = point.y / CGRectGetHeight(self.view.bounds);
    [_liveSession alivcLiveVideoFocusAtAdjustedPoint:percentPoint autoFocus:YES];
    
}

- (void)pinchGesture:(UIPinchGestureRecognizer *)gesture {
    
    if (_currentPosition == AVCaptureDevicePositionFront) {
        return;
    }
    
    if (gesture.numberOfTouches != 2) {
        return;
    }
    CGPoint p1 = [gesture locationOfTouch:0 inView:self.view];
    CGPoint p2 = [gesture locationOfTouch:1 inView:self.view];
    CGFloat dx = (p2.x - p1.x);
    CGFloat dy = (p2.y - p1.y);
    CGFloat dist = sqrt(dx*dx + dy*dy);
    if (gesture.state == UIGestureRecognizerStateBegan) {
        _lastPinchDistance = dist;
    }
    
    CGFloat change = dist - _lastPinchDistance;
    //    change = change / (CGRectGetWidth(self.view.bounds) * 0.5) * 2.0;
    //
    [_liveSession alivcLiveVideoZoomCamera:(change / 1000 )];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)appResignActive{
    [self destroySession];
    
    // 监听电话
    _callCenter = [[CTCallCenter alloc] init];
    _isCTCallStateDisconnected = NO;
    _callCenter.callEventHandler = ^(CTCall* call) {
        if ([call.callState isEqualToString:CTCallStateDisconnected])
        {
            _isCTCallStateDisconnected = YES;
        }
        else if([call.callState isEqualToString:CTCallStateConnected])
            
        {
            _callCenter = nil;
        }
    };
    
}

- (void)appBecomeActive{
    
    if (_isCTCallStateDisconnected) {
        sleep(2);
    }
    
    [self testPushCapture];
}

- (void)testPushCapture{
    
    //    _url = @"rtmp://192.168.30.69/live/movie";
    
    //    _url = @"rtmp://push.lss.qupai.me/qupai-live/qupai-live-wyj99?auth_key=4466400545-0-0-1d54a5911b70caccfce6983bced975e8";
    
    AlivcLConfiguration *configuration = [[AlivcLConfiguration alloc] init];
    configuration.url = _url;
    configuration.videoMaxBitRate = 2500 * 1000;
    configuration.videoBitRate = 600 * 1000;
    configuration.videoMinBitRate = 400 * 1000;
    configuration.audioBitRate = 64 * 1000;
    configuration.videoSize = CGSizeMake(360, 640);// 横屏状态宽高不需要互换
    configuration.fps = 30;
    configuration.preset = AVCaptureSessionPresetiFrame1280x720;
    configuration.screenOrientation = _isScreenHorizontal;
    if (_currentPosition) {
        configuration.position = _currentPosition;
    } else {
        configuration.position = AVCaptureDevicePositionFront;
        _currentPosition = AVCaptureDevicePositionFront;
    }
    
    _liveSession = [[AlivcLiveSession alloc] initWithConfiguration:configuration];
    _liveSession.delegate = self;
    
    [_liveSession alivcLiveVideoStartPreview];
    
    [_liveSession alivcLiveVideoUpdateConfiguration:^(AlivcLConfiguration *configuration) {
        configuration.videoMaxBitRate = 1500 * 1000;
        configuration.videoBitRate = 600 * 1000;
        configuration.videoMinBitRate = 400 * 1000;
        configuration.audioBitRate = 64 * 1000;
        configuration.fps = 20;
    }];
    
    /** 默认美颜 */
    [_liveSession setEnableSkin:YES];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view insertSubview:[_liveSession previewView] atIndex:0];
    });
    
}

- (void)destroySession{
    
    [_liveSession alivcLiveVideoDisconnectServer];
    
    [_liveSession alivcLiveVideoStopPreview];
    [_liveSession.previewView removeFromSuperview];
    
    _liveSession = nil;
}


- (void)alivcLiveVideoLiveSession:(AlivcLiveSession *)session error:(NSError *)error{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *msg = [NSString stringWithFormat:@"%zd %@",error.code, error.localizedDescription];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Live Error" message:msg delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"重新连接", nil];
        alertView.delegate = self;
        [alertView show];
    });
}

- (void)alivcLiveVideoLiveSessionConnectSuccess:(AlivcLiveSession *)session {
    
    GLLog(@"connect success!");
}

- (void)alivcLiveVideoLiveSessionNetworkSlow:(AlivcLiveSession *)session{
    dispatch_async(dispatch_get_main_queue(), ^{
        _textView.text = @"网络很差，不建议直播";
    });
}

- (void)alivcLiveVideoLiveSession:(AlivcLiveSession *)session OpenAudioError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"麦克风获取失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    });
}

- (void)alivcLiveVideoLiveSession:(AlivcLiveSession *)session OpenVideoError:(NSError *)error {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"摄像头获取失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    });
}

- (void)alivcLiveVideoLiveSession:(AlivcLiveSession *)session EncodeAudioError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"音频编码初始化失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    });
    
}

- (void)alivcLiveVideoLiveSession:(AlivcLiveSession *)session EncodeVideoError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"视频编码初始化失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    });
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex != alertView.cancelButtonIndex) {
        [_liveSession alivcLiveVideoConnectServer];
    }
}

/** 点击关闭 */
- (IBAction)buttonCloseClick:(id)sender {
    
    GLAlertView_tip *view = [GLAlertView_tip glAlertView_tip];
    [self.view addSubview:view];
    view.center = CGPointMake(GLScreenW * 0.5, GLScreenH * 0.5);
    
    view.TtitleView.text = @"确定结束直播？";
    __weak typeof(self) weakSelf = self;
    view.enterButtonClick = ^{
    
        [weakSelf destroySession];
        
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
        
        [weakSelf.timer invalidate];
        weakSelf.timer = nil;
        
    };
}

/** 点击问答列表 */
- (IBAction)ClickQuestionListButton:(UIButton *)sender {
    
    AskAnswerList *list = [AskAnswerList new];
    
    list.teacher = self.teacher;
    list.dataSource = self.question;
    list.class_id = self.class_id;
    
    __weak typeof(self) wself = self;
    list.callBackDataS = ^(NSArray *dataSource){
        wself.question = dataSource;
    };
    
    [self presentViewController:list animated:YES completion:^{
        
    }];
    
}

- (IBAction)startLiveButton:(UIButton *)sender {
    
     NSDate *datenow = [NSDate date];//现在时间
     NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]]; //时间戳的值
    
    sender.enabled = NO;
    
    sender.selected = !sender.selected;
    
    if (sender.isSelected) {
        if (timeSp.integerValue + 60 * 30 < self.start_time.integerValue) {
            sender.selected = !sender.selected;
            [self setupAnima:@"请在直播开始30分钟前开直播"];
            return ;
        }else if (timeSp.integerValue > self.end_time.integerValue + 60 * 30) {
            sender.selected = !sender.selected;
            [self setupAnima:@"直播结束后30分钟不能再开播"];
            return ;
        }
    }
    
    if (sender.isSelected) {
        [_liveSession alivcLiveVideoConnectServer];
        
        [self setupAnima:@"开始直播"];
        
        self.YYtipInfo.hidden = NO;
        
    }else {
        [_liveSession alivcLiveVideoDisconnectServer];
        [self setupAnima:@"结束直播"];
    }
    
}



/** 转换摄像头 */
- (IBAction)cameraButtonClick:(UIButton *)button {
    button.selected = !button.isSelected;
    _liveSession.devicePosition = button.isSelected ? AVCaptureDevicePositionBack : AVCaptureDevicePositionFront;
    _currentPosition = _liveSession.devicePosition;
}

//- (IBAction)skinButtonClick:(UIButton *)button {
//    button.selected = !button.isSelected;
//    [_liveSession setEnableSkin:button.isSelected];
//}
//- (IBAction)flashButtonClick:(UIButton *)button {
//    button.selected = !button.isSelected;
//    _liveSession.torchMode = button.isSelected ? AVCaptureTorchModeOn : AVCaptureTorchModeOff;
//}


//- (IBAction)disconnectButtonClick:(id)sender {
//    if (_liveSession.dumpDebugInfo.connectStatus == AlivcLConnectStatusNone) {
//        [_liveSession alivcLiveVideoConnectServer];
//    }else{
//        [_liveSession alivcLiveVideoDisconnectServer];
//    }
//}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_handle closeFile];
    
    [self disMissSocket];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}

-(void)setLiveitem:(LiveVideoDetailItem *)liveitem
{
    _liveitem = liveitem;
    // 语音直播
    if ([liveitem.type isEqualToString:@"4"]) {
        [self setupVideoUpPicView];
        
        UILabel *YYtipInfo = [UILabel new];
        NSString *text = @"正在进行语音直播";
        YYtipInfo.text = text;
        YYtipInfo.font = [UIFont systemFontOfSize:17];
        YYtipInfo.textColor = [UIColor hx_colorWithHexRGBAString:@"f19d37"];
        [self.view addSubview:YYtipInfo];
        [YYtipInfo sizeToFit];
        YYtipInfo.glx_x = GLScreenW * 0.5 - YYtipInfo.glw_width * 0.5;
        YYtipInfo.gly_y = 172;
        YYtipInfo.textAlignment = NSTextAlignmentCenter;
        YYtipInfo.transform = CGAffineTransformMakeScale(1.5, 1.5);
        YYtipInfo.numberOfLines = 0;
        
        YYtipInfo.hidden = YES;
        
        self.YYtipInfo = YYtipInfo;
    }
}

- (void)setupVideoUpPicView
{
    
    [_liveSession previewView].hidden = YES;
    
    _liveSession.devicePosition = AVCaptureDevicePositionBack;
    _liveSession.torchMode = AVCaptureTorchModeOff;
    
    UIView *BGview = [UIView new];
    BGview.backgroundColor = [UIColor blackColor];
    BGview.frame = CGRectMake(0, 0, GLScreenW, GLScreenH);
    [self.view addSubview:BGview];
    [self.view sendSubviewToBack:BGview];
    
    UIImageView *view = [[UIImageView alloc]init];
    [self.view insertSubview:view belowSubview:self.tipInfo];
    
    view.backgroundColor = [UIColor blackColor];
    view.frame = CGRectMake(0, 220, GLScreenW, 155);
    view.contentMode = UIViewContentModeScaleToFill;
    
//    [view sd_setImageWithURL:[NSURL URLWithString:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:self.liveitem.thumb2]] placeholderImage:nil];
    
    [view sd_setImageWithURL:[NSURL URLWithString:[LocalDataRW getImageAllStr:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:self.liveitem.thumb2]]] placeholderImage:[UIImage imageNamed:@"ZCCG_TX"]];
    
    self.videoViewImageV = view;
}


@end
