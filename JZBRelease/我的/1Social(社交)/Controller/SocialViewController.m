//
//  SocialViewController.m
//  huanxinFullDemo
//
//  Created by zjapple on 16/7/20.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "SocialViewController.h"
#import "ConversationListController.h"
#import "ContactListViewController.h"
#import "ApplyViewController.h"
#import "ChatViewController.h"
#import "RedPacketChatViewController.h"
#import "UserProfileManager.h"
#import "ChatDemoHelper.h"

#import "AFNetworking.h"
#import "HXFriendList.h"
#import "MJExtension.h"

#import "ApplyGruopNoticeVC.h"
#import "SendAndGetDataFromNet.h"

#import "updateTabBarBadge.h"

#import "Masonry.h"

//两次提示的默认间隔
static const CGFloat kDefaultPlaySoundInterval = 3.0;
static NSString *kMessageType = @"MessageType";
static NSString *kConversationChatter = @"ConversationChatter";
static NSString *kGroupName = @"GroupName";

@interface SocialViewController ()
/** tipView */
@property (nonatomic, weak) UIView *tipView;
/** startLock */
@property (nonatomic, assign) BOOL startLock;

@property (weak, nonatomic) UIView *midSegButton;

@property (strong, nonatomic) UIBarButtonItem *addFriendItem;

// 联系人
@property (strong, nonatomic) ContactListViewController *contactsVC;
// 消息
@property (strong, nonatomic) ConversationListController *chatListVC;

@property (strong, nonatomic) NSDate *lastPlaySoundDate;

/** nickname */
@property (nonatomic, strong) NSString *nickname;

/** userInfo */
@property (nonatomic, strong) UserInfo *userInfo;

@end

@implementation SocialViewController

- (UIView *)titleView
{
    UIView *contentView = [UIView new];
    [self.view addSubview:contentView];
    contentView.frame = CGRectMake(0, 0, 100, 44);
    contentView.backgroundColor = [UIColor clearColor];
    
    
    UIButton *tipButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [tipButton1 setTitle:@"消息" forState:UIControlStateNormal];
    
    [contentView addSubview:tipButton1];
    
    [tipButton1 setFont:[UIFont systemFontOfSize:17]];
    
    [tipButton1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    tipButton1.frame = CGRectMake(0, 5, 0, 0);
    
    [tipButton1 sizeToFit];
    
    [tipButton1 addTarget:self action:@selector(tipButton1Active:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *tipButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [tipButton2 setTitle:@"联系人" forState:UIControlStateNormal];
    
    [contentView addSubview:tipButton2];
    
    [tipButton2 setFont:[UIFont systemFontOfSize:17]];
    
    [tipButton2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    tipButton2.frame = CGRectMake(tipButton1.glr_right + 15, 5, 0, 0);
    
    [tipButton2 sizeToFit];
    
    [tipButton2 addTarget:self action:@selector(tipButton2Active:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *tipView = [UIView new];
    [contentView addSubview:tipView];
    self.tipView = tipView;
    
    tipView.frame = CGRectMake(-4, 40, 43, 3);
    
//    [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(contentView.mas_bottom).offset(-1);
//        make.left.equalTo(@(177)).offset(-3);
//        make.height.equalTo(@(3));
//        make.width.equalTo(@(45));
//    }];
    
    
    tipView.backgroundColor = [UIColor whiteColor];
    tipView.layer.cornerRadius = 2;
    tipView.clipsToBounds = YES;
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self tipButton2Active:nil];
        
        [self tipButton1Active:nil];
    });
    
    return contentView;
    
}

- (void)tipButton1Active:(UIButton *)btn
{
    if (!self.chatListVC.view.superview) {
        self.contactsVC.view.frame = CGRectMake(0, 64, self.contactsVC.view.frame.size.width, self.contactsVC.view.frame.size.height - 64 - 49);
        [self.view addSubview:self.contactsVC.view];
    }else{
        [self.view bringSubviewToFront:self.chatListVC.view];
        [self.chatListVC updatabadge];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
//        [self.tipView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self.tipView.superview.mas_bottom).offset(-1);
//            make.left.equalTo(@(88)).offset(-3);
//            make.height.equalTo(@(3));
//            make.width.equalTo(@(45));
//        }];
        
         self.tipView.frame = CGRectMake(-4, 40, 43, 3);
        
//         self.tipView.frame = CGRectMake(-3 + self.tipView.superview.glw_width * 0.5, 43, 43, 3);
        
        [self.view layoutIfNeeded];
    }];
    
}

- (void)tipButton2Active:(UIButton *)btn
{
    if (!self.contactsVC.view.superview) {
        /** 减64 是因为 原来demo下面有个自定义tabar 【下移64 高度-上64 下49】 */
        self.contactsVC.view.frame = CGRectMake(0, 64, self.contactsVC.view.frame.size.width, self.contactsVC.view.frame.size.height - 64 - 49);
        
        [self.view addSubview:self.contactsVC.view];
    }else{
        [self.view bringSubviewToFront:self.contactsVC.view];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
//        [self.tipView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self.tipView.superview.mas_bottom).offset(-1);
//            make.left.equalTo(@(99)).offset(-3);
//            make.height.equalTo(@(3));
//            make.width.equalTo(@(45));
//        }];
        
       
        
        self.tipView.frame = CGRectMake(-3 + self.tipView.superview.glw_width * 0.5, 40, 53, 3);
        
        [self.view layoutIfNeeded];
    }];
}

- (ContactListViewController *)contactsVC
{
    if (_contactsVC == nil) {
        _contactsVC = [[ContactListViewController alloc]init];
        [self addChildViewController:_contactsVC];
    }
    
    return _contactsVC;
}

- (ConversationListController *)chatListVC
{
    if (_chatListVC == nil) {
        _chatListVC = [[ConversationListController alloc]init];
        [self addChildViewController:_chatListVC];
    }
    
    return _chatListVC;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.tabBarController.tabBar setHidden:YES];
    
    [self setupData];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //获取未读消息数，此时并没有把self注册为SDK的delegate，读取出的未读数是上次退出程序时的
    //    [self didUnreadMessagesCountChanged];
    // 用于tabbar上面的未读消息数量,本程序没这需求
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupUntreatedApplyCount) name:@"setupUntreatedApplyCount" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupUnreadMessageCount) name:@"setupUnreadMessageCount" object:nil];
    
    [self.chatListVC networkChanged:_connectionState];
    
    UISegmentedControl *seg = [[UISegmentedControl alloc]initWithItems:@[@"消息",@"联系人"]];
    seg.selectedSegmentIndex = 1;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        seg.selectedSegmentIndex = 0;
    });
    
    seg.tintColor = [UIColor whiteColor];
    _midSegButton = seg;
    self.navigationItem.titleView = _midSegButton;
    [seg addTarget:self action:@selector(segBtnClick:) forControlEvents:UIControlEventValueChanged];
    
//    [seg setTintColor:[UIColor hx_colorWithHexRGBAString:@"ffffff"]];
    
    self.navigationItem.titleView = [self titleView];
    
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    // 还没导入图片
    [addButton setImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
    [addButton addTarget:self.contactsVC action:@selector(addFriendAction) forControlEvents:UIControlEventTouchUpInside];
    _addFriendItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    
    /** 高林 修改 取消环信内右上角加好友 .. 在app内部 其他个人详情页中点击【加好友】添加 */
//    self.navigationItem.rightBarButtonItem = _addFriendItem;
    
    /** 减64 是因为 原来demo下面有个自定义tabar 【下移64 高度-上64 下49】 */
    self.chatListVC.view.frame = CGRectMake(0, 64, self.chatListVC.view.frame.size.width, self.chatListVC.view.frame.size.height - 64 -49);
    [self.view addSubview:self.chatListVC.view];
    
    [ChatDemoHelper shareHelper].contactViewVC = _contactsVC;
    [ChatDemoHelper shareHelper].conversationListVC = _chatListVC;
    [ChatDemoHelper shareHelper].mainVC = self;
    
//    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].groupManager addDelegate:self delegateQueue:nil];
    
    /***********************************************/
    /** 这里是app启动跳转首页 【先去加载我的页面数据了，然后跳的学吧Index0】*/
    if (!self.startLock) {
        [self.tabBarController setSelectedIndex:0];
        self.startLock = YES;
        
//        [SVProgressHUD showSuccessWithStatus:@"登陆成功，增加积分 +2"];
        //[Toast makeShowCommen:@"欢迎," ShowHighlight:@"登陆成功" HowLong:0.8];
    }
    /***********************************************/
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.chatListVC updatabadge];
    
}

- (void)setupData
{
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        NSString *access_token = [defaults stringForKey:@"access_token"];
    
    self.userInfo = [[LoginVM getInstance]readLocal];
    
        /** 还没有做token过期处理 */
    NSDictionary *parameters = @{
                                 @"access_token":self.userInfo.token,
                                 @"uid":@"0"
                                 };
    
    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/user/info"] parameters:parameters success:^(id json) {
        
        if ([json[@"state"] isEqual:@(0)])  return ;
        
        self.nickname = json[@"data"][@"nickname"];
        self.contactsVC.nikename = self.nickname;
    } failure:^(NSError *error) {
        // 一个任务被取消了, 会调用AFN请求的failure这个block
        if (error.code == NSURLErrorCancelled) return ;
        //        [self tableViewDidFinishTriggerHeader:YES reload:NO];
        //        [SVProgressHUD showErrorWithStatus:@"网络错误"];
    }];
    
//        [self.manager POST:@"http://192.168.10.154/bang/index.php/Web/user/info" parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//    
//            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
//            if ([result[@"state"] isEqual:@(0)])  return ;
//    
//            self.nickname = result[@"data"][@"nickname"];
//            self.contactsVC.nikename = self.nickname;
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//    
//            // 一个任务被取消了, 会调用AFN请求的failure这个block
//            if (error.code == NSURLErrorCancelled) return ;
//            //        [self tableViewDidFinishTriggerHeader:YES reload:NO];
//            //        [SVProgressHUD showErrorWithStatus:@"网络错误"];
//        }];
}

- (void)segBtnClick:(UISegmentedControl *)seg
{
    
    [self.view endEditing:YES];
    
    if (seg.selectedSegmentIndex == 0) {
        
        if (!self.chatListVC.view.superview) {
            self.contactsVC.view.frame = CGRectMake(0, 64, self.contactsVC.view.frame.size.width, self.contactsVC.view.frame.size.height - 64 - 49);
            [self.view addSubview:self.contactsVC.view];
        }else{
            [self.view bringSubviewToFront:self.chatListVC.view];
            [self.chatListVC updatabadge];
        }
    }else{
        if (!self.contactsVC.view.superview) {
            /** 减64 是因为 原来demo下面有个自定义tabar 【下移64 高度-上64 下49】 */
            self.contactsVC.view.frame = CGRectMake(0, 64, self.contactsVC.view.frame.size.width, self.contactsVC.view.frame.size.height - 64 - 49);
            
            [self.view addSubview:self.contactsVC.view];
        }else{
            [self.view bringSubviewToFront:self.contactsVC.view];
        }
    }
}

- (void)jumpToChatList
{
    if ([self.navigationController.topViewController isKindOfClass:[ChatViewController class]]) {
        //        ChatViewController *chatController = (ChatViewController *)self.navigationController.topViewController;
        //        [chatController hideImagePicker];
    }
    else if(_chatListVC)
    {
        [self.navigationController popToViewController:self animated:NO];
//        [self setSelectedViewController:_chatListVC];
    }
}

// 统计未读消息数
- (void)setupUnreadMessageCount
{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    
    if (unreadCount != 0) {
        //        self.navigationController.tabBarItem.badgeValue = @"N";
        self.navigationController.tabBarItem.badgeValue = [updateTabBarBadge updateTabBarBadgeNum];
        
        if ([self.navigationController.tabBarItem.badgeValue isEqualToString:@"0"]) {
            self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",(long)unreadCount];
        }else{
            self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",(long)unreadCount + self.navigationController.tabBarItem.badgeValue.intValue];
        }
        
    }
    
    
    if (_chatListVC) {
        if (unreadCount > 0) {
            _chatListVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",(int)unreadCount];
        }else{
            _chatListVC.tabBarItem.badgeValue = nil;
        }
    }
    
//    [SVProgressHUD showInfoWithStatus:[updateTabBarBadge updateTabBarBadgeNum]];
    
//    unreadCount += [updateTabBarBadge updateTabBarBadgeNum].integerValue;
    
//    GLLog(@"更新nav3的badge值= %@",[updateTabBarBadge updateTabBarBadgeNum]);
    AppDelegate *appD = (AppDelegate*)[UIApplication sharedApplication].delegate;

    UIApplication *application = [UIApplication sharedApplication];
    if (appD.isLiveBG) {
        
    }else{
        appD.isGetUnreadCount = YES;
        [application setApplicationIconBadgeNumber:unreadCount];
    }
    
}

- (void)setupUntreatedApplyCount
{
    NSInteger unreadCount = [[[ApplyViewController shareController] dataSource] count];
    if (_contactsVC) {
        if (unreadCount > 0) {
            _contactsVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",(int)unreadCount];
        }else{
            _contactsVC.tabBarItem.badgeValue = nil;
        }
    }
}

- (void)networkChanged:(EMConnectionState)connectionState
{
    _connectionState = connectionState;
    [_chatListVC networkChanged:connectionState];
}

- (void)playSoundAndVibration{
    NSTimeInterval timeInterval = [[NSDate date]
                                   timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        //如果距离上次响铃和震动时间太短, 则跳过响铃
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
        return;
    }
    
    //保存最后一次响铃时间
    self.lastPlaySoundDate = [NSDate date];
    
    // 收到消息时，播放音频
    [[EMCDDeviceManager sharedInstance] playNewMessageSound];
    // 收到消息时，震动
    [[EMCDDeviceManager sharedInstance] playVibration];
}

- (void)showNotificationWithMessage:(EMMessage *)message
{
    EMPushOptions *options = [[EMClient sharedClient] pushOptions];
    //发送本地推送
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate date]; //触发通知的时间
    
    if (options.displayStyle == EMPushDisplayStyleMessageSummary) {
        EMMessageBody *messageBody = message.body;
        NSString *messageStr = nil;
        switch (messageBody.type) {
            case EMMessageBodyTypeText:
            {
                messageStr = ((EMTextMessageBody *)messageBody).text;
            }
                break;
            case EMMessageBodyTypeImage:
            {
                messageStr = NSLocalizedString(@"message.image", @"Image");
            }
                break;
            case EMMessageBodyTypeLocation:
            {
                messageStr = NSLocalizedString(@"message.location", @"Location");
            }
                break;
            case EMMessageBodyTypeVoice:
            {
                messageStr = NSLocalizedString(@"message.voice", @"Voice");
            }
                break;
            case EMMessageBodyTypeVideo:{
                messageStr = NSLocalizedString(@"message.video", @"Video");
            }
                break;
            default:
                break;
        }
        
        do {
            NSString *title = [[UserProfileManager sharedInstance] getNickNameWithUsername:message.from];
            if (message.chatType == EMChatTypeGroupChat) {
                NSDictionary *ext = message.ext;
                if (ext && ext[kGroupMessageAtList]) {
                    id target = ext[kGroupMessageAtList];
                    if ([target isKindOfClass:[NSString class]]) {
                        if ([kGroupMessageAtAll compare:target options:NSCaseInsensitiveSearch] == NSOrderedSame) {
                            notification.alertBody = [NSString stringWithFormat:@"%@%@", title, NSLocalizedString(@"group.atPushTitle", @" @ me in the group")];
                            break;
                        }
                    }
                    else if ([target isKindOfClass:[NSArray class]]) {
                        NSArray *atTargets = (NSArray*)target;
                        if ([atTargets containsObject:[EMClient sharedClient].currentUsername]) {
                            notification.alertBody = [NSString stringWithFormat:@"%@%@", title, NSLocalizedString(@"group.atPushTitle", @" @ me in the group")];
                            break;
                        }
                    }
                }
                NSArray *groupArray = [[EMClient sharedClient].groupManager getAllGroups];
                for (EMGroup *group in groupArray) {
                    if ([group.groupId isEqualToString:message.conversationId]) {
                        title = [NSString stringWithFormat:@"%@(%@)", message.from, group.subject];
                        break;
                    }
                }
            }
            else if (message.chatType == EMChatTypeChatRoom)
            {
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                NSString *key = [NSString stringWithFormat:@"OnceJoinedChatrooms_%@", [[EMClient sharedClient] currentUsername]];
                NSMutableDictionary *chatrooms = [NSMutableDictionary dictionaryWithDictionary:[ud objectForKey:key]];
                NSString *chatroomName = [chatrooms objectForKey:message.conversationId];
                if (chatroomName)
                {
                    title = [NSString stringWithFormat:@"%@(%@)", message.from, chatroomName];
                }
            }
            
            notification.alertBody = [NSString stringWithFormat:@"%@:%@", title, messageStr];
        } while (0);
    }
    else{
        notification.alertBody = NSLocalizedString(@"receiveMessage", @"you have a new message");
    }
    
#warning 去掉注释会显示[本地]开头, 方便在开发中区分是否为本地推送
    //notification.alertBody = [[NSString alloc] initWithFormat:@"[本地]%@", notification.alertBody];
    
    notification.alertAction = NSLocalizedString(@"open", @"Open");
    notification.timeZone = [NSTimeZone defaultTimeZone];
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
    } else {
        notification.soundName = UILocalNotificationDefaultSoundName;
        self.lastPlaySoundDate = [NSDate date];
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:[NSNumber numberWithInt:message.chatType] forKey:kMessageType];
    [userInfo setObject:message.conversationId forKey:kConversationChatter];
    notification.userInfo = userInfo;
    
    //发送通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber += 1;
}

- (EMConversationType)conversationTypeFromMessageType:(EMChatType)type
{
    EMConversationType conversatinType = EMConversationTypeChat;
    switch (type) {
        case EMChatTypeChat:
            conversatinType = EMConversationTypeChat;
            break;
        case EMChatTypeGroupChat:
            conversatinType = EMConversationTypeGroupChat;
            break;
        case EMChatTypeChatRoom:
            conversatinType = EMConversationTypeChatRoom;
            break;
        default:
            break;
    }
    return conversatinType;
}

- (void)dealloc
{
    [self.tabBarController.tabBar setHidden:NO];
    [[EMClient sharedClient].groupManager removeDelegate:self];
}

/** 接收到好友 */
- (void)didReceiveFriendInvitationFromUsername:(NSString *)aUsername
                                       message:(NSString *)aMessage
{
//    self.navigationController.tabBarItem.badgeValue = @"F";
    self.navigationController.tabBarItem.badgeValue = [updateTabBarBadge updateTabBarBadgeNum];
    if (!aUsername) {
        return;
    }
    
    if (self) {
        [self setupUntreatedApplyCount];
#if !TARGET_IPHONE_SIMULATOR
        [self playSoundAndVibration];
#endif
    }
    if (self.contactsVC) {
        [self.contactsVC reloadApplyView];
    }
    if (self.chatListVC) {
        [self.chatListVC refresh];
    }

}

/** 接收到群组邀请 */
- (void)didReceiveGroupInvitation:(NSString *)aGroupId
                          inviter:(NSString *)aInviter
                          message:(NSString *)aMessage
{
    if (!aGroupId || !aInviter) {
        return;
    }
    
//    self.navigationController.tabBarItem.badgeValue = @"G";
    self.navigationController.tabBarItem.badgeValue = [updateTabBarBadge updateTabBarBadgeNum];
    NSInteger badge = 0;
    
    NSUserDefaults *udefault = [NSUserDefaults standardUserDefaults];
    badge = [udefault integerForKey:@"aGroupIdBadge"];
    
    badge++;
    [udefault setInteger:badge forKey:@"aGroupIdBadge"];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"title":@"", @"groupId":aGroupId, @"username":aInviter, @"groupname":@"", @"applyMessage":aMessage, @"applyStyle":[NSNumber numberWithInteger:ApplyStyleGroupInvitation]}];
    [[ApplyGruopNoticeVC shareController] addNewApply:dic];
    if (self) {
        [self setupUntreatedApplyCount];
#if !TARGET_IPHONE_SIMULATOR
        [self playSoundAndVibration];
#endif
    }
    
    if (self.contactsVC) {
        [self.contactsVC reloadApplyView];
    }
    if (self.chatListVC) {
        [self.chatListVC refresh];
    }
}

- (void)didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    if (userInfo)
    {
        if ([self.navigationController.topViewController isKindOfClass:[ChatViewController class]]) {
            //            ChatViewController *chatController = (ChatViewController *)self.navigationController.topViewController;
            //            [chatController hideImagePicker];
        }
        
        NSArray *viewControllers = self.navigationController.viewControllers;
        [viewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            if (obj != self)
            {
                if (![obj isKindOfClass:[ChatViewController class]])
                {
                    [self.navigationController popViewControllerAnimated:NO];
                }
                else
                {
                    NSString *conversationChatter = userInfo[kConversationChatter];
                    ChatViewController *chatViewController = (ChatViewController *)obj;
                    if (![chatViewController.conversation.conversationId isEqualToString:conversationChatter])
                    {
                        [self.navigationController popViewControllerAnimated:NO];
                        EMChatType messageType = [userInfo[kMessageType] intValue];
#ifdef REDPACKET_AVALABLE
                        chatViewController = [[RedPacketChatViewController alloc]
#else
                                              chatViewController = [[ChatViewController alloc]
#endif
                                                                    initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
                                              switch (messageType) {
                                                  case EMChatTypeChat:
                                                  {
                                                      NSArray *groupArray = [[EMClient sharedClient].groupManager getAllGroups];
                                                      for (EMGroup *group in groupArray) {
                                                          if ([group.groupId isEqualToString:conversationChatter]) {
                                                              chatViewController.title = group.subject;
                                                              break;
                                                          }
                                                      }
                                                  }
                                                      break;
                                                  default:
                                                      chatViewController.title = conversationChatter;
                                                      break;
                                              }
                                              chatViewController.hidesBottomBarWhenPushed = YES;
                                              [self.navigationController pushViewController:chatViewController animated:NO];
                                              }
                                              *stop= YES;
                                              }
                                              }
                                              else
                                              {
                                                  ChatViewController *chatViewController = nil;
                                                  NSString *conversationChatter = userInfo[kConversationChatter];
                                                  EMChatType messageType = [userInfo[kMessageType] intValue];
#ifdef REDPACKET_AVALABLE
                                                  chatViewController = [[RedPacketChatViewController alloc]
#else
                                                                        chatViewController = [[ChatViewController alloc]
#endif
                                                                                              initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
                                                                        switch (messageType) {
                                                                            case EMChatTypeGroupChat:
                                                                            {
                                                                                NSArray *groupArray = [[EMClient sharedClient].groupManager getAllGroups];
                                                                                for (EMGroup *group in groupArray) {
                                                                                    if ([group.groupId isEqualToString:conversationChatter]) {
                                                                                        chatViewController.title = group.subject;
                                                                                        break;
                                                                                    }
                                                                                }
                                                                            }
                                                                                break;
                                                                            default:
                                                                                chatViewController.title = conversationChatter;
                                                                                break;
                                                                        }
                                                                        chatViewController.hidesBottomBarWhenPushed = YES;
                                                                        [self.navigationController pushViewController:chatViewController animated:NO];
                                                                        }
                                                                        }];
                                              }
                                              else if (_chatListVC)
                                              {
                                                  [self.navigationController popToViewController:self animated:NO];
//                                                  [self setSelectedViewController:_chatListVC];
                                              }
}
                                              
@end
