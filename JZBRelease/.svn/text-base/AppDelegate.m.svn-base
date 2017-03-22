//
//  AppDelegate.m
//  JZBRelease
//
//  Created by zjapple on 16/4/20.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginVM.h"
#import "JPUSHService.h"
#import "ValuesFromXML.h"
#import "LocalDataRW.h"
#import "SlideNavigationController.h"

#import <CoreLocation/CoreLocation.h>

#import "EMSDK.h"
#import "AppDelegate+UMeng.h"
#import "AppDelegate+EaseMob.h"
#import "AlipaySDK.h"
#import "RedPacketUserConfig.h"
#import "RedpacketOpenConst.h"
#import "AppDelegate+Parse.h"

#import "SVProgressHUD.h"

#define isProduction NO
@interface AppDelegate (){
    BMKMapManager* _mapManager;
}

/** 位置管理者 */
@property (nonatomic ,strong) CLLocationManager *locationM;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // 启动页延迟
    //  [NSThread sleepForTimeInterval:3.0];
    [self setUpFMDB];
    
    /** 初始化 弹窗告示 */
    [self setUpSVProgressHUDStyle];
    
    //百度地图
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:@"uBLsm8Ssq8niGLoBTQSr6L8U1fiQLbc5" generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    _locationM = [[CLLocationManager alloc] init];
    _locationM.distanceFilter = kCLDistanceFilterNone;
    
    _locationM.desiredAccuracy = kCLLocationAccuracyBest;
    
    //Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
        
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
//            _locationM.allowsBackgroundLocationUpdates = YES;
        }
        [_locationM requestAlwaysAuthorization];
        
        
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    //Required
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:[ValuesFromXML getValueWithName:@"JPUSH_APPKEY" WithKind:XMLTypeBase]
                          channel:@"App Store"
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
   
    [JPUSHService crashLogON];
    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
    
    NSLog(@"identifier %@",identifier);
    
    //[NSTimer scheduledTimerWithTimeInterval:12 target:self selector:@selector(sendMessage) userInfo:nil repeats:NO];
    
    
#ifdef REDPACKET_AVALABLE
    /**
     *  TODO: 通过环信的AppKey注册红包
     */
    [[RedPacketUserConfig sharedConfig] configWithAppKey:@"jianzhongbang#jzb"];
#endif
    //AppKey:注册的AppKey，详细见下面注释。
    //apnsCertName:推送证书名（不需要加后缀），详细见下面注释。
    EMOptions *options = [EMOptions optionsWithAppkey:@"jianzhongbang#jzb"];
    //    options.apnsCertName = @"istore_dev";
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0) {
        // 设置topView和状态栏的颜色
        //[[UINavigationBar appearance] setBarTintColor:RGBACOLOR(130, 167, 252, 1)];
        
        //[[UINavigationBar appearance] setTitleTextAttributes:
         //[NSDictionary dictionaryWithObjectsAndKeys:RGBACOLOR(245, 245, 245, 1), NSForegroundColorAttributeName, [UIFont fontWithName:@ "HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil]];
    }
    
    // 环信UIdemo中有用到友盟统计crash，您的项目中不需要添加，可忽略此处。
    [self setupUMeng];
    
    // 环信UIdemo中有用到Parse，您的项目中不需要添加，可忽略此处。
    //    [self parseApplication:application didFinishLaunchingWithOptions:launchOptions];
    
#warning 初始化环信SDK，详细内容在AppDelegate+EaseMob.m 文件中
#warning SDK注册 APNS文件的名字, 需要与后台上传证书时的名字一一对应
    NSString *apnsCertName = nil;
#if DEBUG
    apnsCertName = @"chatdemoui_dev";
#else
    apnsCertName = @"chatdemoui";
#endif
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *appkey = [ud stringForKey:@"identifier_appkey"];
    if (!appkey) {
        appkey = @"jianzhong#jianzhong";
        [ud setObject:appkey forKey:@"identifier_appkey"];
    }
    
    [self easemobApplication:application
didFinishLaunchingWithOptions:launchOptions
                      appkey:appkey
                apnsCertName:apnsCertName
                 otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];
    
    
    return YES;
}

-(void)rigisterSuccess:(NSNotification *)notification{
    NSLog(@"通知[notification userInfo]:%@", [notification userInfo] );
}
-(void)loginSuccess:(NSNotification *)notification{
    NSLog(@"通知[notification userInfo]:%@", [notification userInfo] );
}
-(void)connectSuccess:(NSNotification *)notification{
    NSLog(@"通知[notification userInfo]:%@", [notification userInfo] );
}

- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    NSString *content = [userInfo valueForKey:@"content"];
    NSDictionary *extras = [userInfo valueForKey:@"extras"];
    NSString *contentType = [userInfo valueForKey:@"content_type"];
    [LocalDataRW addCountWithType:contentType];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MessageComing" object:self userInfo:nil];
    NSLog(@"收到通知:%@", contentType);
    //NSString *customizeField1 = [extras valueForKey:@"customizeField1"]; //服务端传递的Extras附加字段，key是自己定义的
    
    if ([contentType isEqualToString:@"circle_forbid"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MessageBanSpeak" object:self userInfo:extras];
        NSUserDefaults *udefaults = [NSUserDefaults standardUserDefaults];
        [udefaults setObject:extras forKey:extras[@"groupid"]];
//        [[HXuserDefault alloc]initWithDict:extras];
    }
    
    if ([contentType isEqualToString:@"friend_add"]) {
        
        NSUserDefaults *udefault = [NSUserDefaults standardUserDefaults];
        NSInteger num = [udefault integerForKey:@"MessageFriend"];
        
        num++;
        
        [udefault setInteger:num forKey:@"MessageFriend"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MessageFriend_add" object:self userInfo:nil];
//        NSUserDefaults *udefaults = [NSUserDefaults standardUserDefaults];
//        [udefaults setObject:extras forKey:extras[@"groupid"]];
//        NSLog(@"接受申请好友");
    }
    if ([contentType isEqualToString:@"friend_agree"]) {
        
        NSUserDefaults *udefault = [NSUserDefaults standardUserDefaults];
        NSInteger num = [udefault integerForKey:@"MessageFriend"];
        
        num--;
        
        [udefault setInteger:num forKey:@"MessageFriend"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MessageFriend_agree" object:self userInfo:nil];
//        NSUserDefaults *udefaults = [NSUserDefaults standardUserDefaults];
//        [udefaults setObject:extras forKey:extras[@"groupid"]];
//        NSLog(@"同意申请好友");
    }
    
//    [SVProgressHUD showInfoWithStatus:@"收到通知"];
}


-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    /// Required - 注册 DeviceToken
    NSLog(@"My token is: %@", deviceToken);
    [JPUSHService registerDeviceToken:deviceToken];
}



- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // IOS 7 Support Required
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
//    [rootViewController addNotificationCount];
}


- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
        //[[LoginVM getInstance] loginWithUserInfo:[[LoginVM getInstance] readLocal]];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)setUpFMDB
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [GLFMDBToolSDK shareToolsWithCreateDDL:@"CREATE TABLE if not exists t_HXFriendDataSource ( uid text, nickname text, HXid text, UserModel blob );"];
        [GLFMDBToolSDK shareToolsWithCreateDDL:@"CREATE TABLE if not exists t_HXapplyFriendItems ( _id text, recode_uid text, message_content text, recode_u_avatar text, recode_u_nickname text, create_time text, status text,type text, ustate text, isConfirm bit );"];
    });
}

- (void)setUpSVProgressHUDStyle
{
//    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setMinimumDismissTimeInterval:2];
}

//(recode_uid,message_content,recode_u_avatar,recode_u_nickname,create_time,status,type,ustate,isConfirm)
@end
