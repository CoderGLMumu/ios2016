//
//  AppDelegate.h
//  JZBRelease
//
//  Created by zjapple on 16/4/20.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocialViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "VipModel.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,BMKGeneralDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SocialViewController *mainController;

/** checkpay */
@property (nonatomic, assign) BOOL checkpay;
/** notAutoLogin */
@property (nonatomic, assign) BOOL notAutoLogin;
/** userCurrentLocal */
@property (nonatomic, strong) NSString *userCurrentLocal;
/** vip */
@property (nonatomic, strong) VipModel *vip;
/** user */
@property (nonatomic, strong) Users *user;
/** vip */
@property (nonatomic, strong) NSString *payType;
/** vip */
@property (nonatomic, strong) NSString *UDID;

/** checkpay */
@property (nonatomic, assign) BOOL firstLogin;

/** 问答语音开关 */
@property (nonatomic, assign) BOOL audioSwitch;

/** 正在进行微信支付 */
@property (nonatomic, assign) BOOL isWechatPay;

/** 记录app在后台时接受的除开环信聊天的数量 */
@property (nonatomic, assign) NSInteger BGBadge;
/** 记录app在后台正在后台 */
@property (nonatomic, assign) BOOL isLiveBG;
/** 记录过聊天的数量 */
@property (nonatomic, assign) BOOL isGetUnreadCount;

/** 记录进入聊天窗口前数量 */
@property (nonatomic, assign) NSInteger preChatNum;
/** 记录进入聊天窗口需要减去的熟练 */
@property (nonatomic, assign) NSInteger ChatcutNum;

@end

