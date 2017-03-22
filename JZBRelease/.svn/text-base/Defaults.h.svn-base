//
//  Defaults.h
//  JZBRelease
//
//  Created by zjapple on 16/4/28.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#ifndef Defaults_h
#define Defaults_h


//#define KVersion @"Version 2.0.2"
#define KversionNo @"2.0.2"
#define huiTongAppSystem @"iOS"
#define huiTongAppVersion @"2.0.2"

//navigationitem left right
#define LEFT @"LEFT"
#define RIGHT @"RIGHT"

// 极光推送
#define JPush @"161f1017deaf5dc1cba3e83d"
// 0335dd3eb505909bdc492d06 开发
// 161f1017deaf5dc1cba3e83d  发布

// 网络请求封装
#import "HttpManager.h"

// urlConnection
#import "URLConnectionGet.h"
#import "URLConnectionPost.h"
#import "UIButton+CreateButton.h"
#import "ZJBHelp.h"
#import "ValuesFromXML.h"
#import "WJRefresh.h"
#import "UIImageView+CacheImage.h"
#import "UILabel+CreateLabel.h"
#import "UIImageView+CreateImageView.h"
#import "TableViewCellDelegate.h"
#import "LWTextParser.h"
#import "LWStorage+Constraint.h"
#import "LWConstraintManager.h"
#import "CommentModel.h"
#import "LWDefine.h"
#import "NSObject+LWAlchemy.h"
#import "LocalDataRW.h"
#import "LoginVM.h"
#import "SendAndGetDataFromNet.h"
#import "DataBaseHelperSecond.h"
#import "Toast.h"
#import "CustomAlertView.h"
#import "LewPopupViewAnimationSpring.h"
#import "HexColors.h"
#import "ApplyVipVC.h"
#import "BCH_Alert.h"
//typedef NS_ENUM(NSInteger,Clink_Type){
//    Clink_Type_One = 0,
//    Clink_Type_Two = 1,
//};
//#import "CustomNavBar.h"
//
//// 二维码
//#import "QRCodeGenerator.h"
//
//// 上传图片使用
//#import "UIImage+Scale.h"
// 数据库文件
#import "FMDatabase.h"
// 操作通知数据库：1.0.6.1及之前没用到
//#import "MessageDBManager.h"

// AppStore app 下载地址
#define KAppStoreURL @"http://itunes.apple.com/us/app/id993707391"

// uber


// 网络请求前缀 1.0.6.1及以后放弃前缀，使用本地URL.plist文件中的地址访问
// #define kUrlPre @"http://huitong.ping-qu.com/"
#define kUrlPre [[GETURL shareGETURL] getURL]
// 手机号码判断
#import "isPhoneNumber.h"
// MD5



//RGB颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue)    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromRGBWithAlpha(rgbValue,alp)    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alp]
//rgb 宏定义
#define  COLORRGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]
#define FONTSIZE(x) [UIFont systemFontOfSize:x];

#define kEffectColor [UIColor colorWithRed:0 green:0 blue:0 alpha:.2]
#define kClickEffectImage [UIImage imageWithColor:kEffectColor]

#define k8ETitleColor UIColorFromRGB(0x8e8e8e)
#define kTabbarGrayColor UIColorFromRGB(0xb6b6b6)
#define kTabbarRedColor UIColorFromRGB(0xb4040f)
#define kBlackTitleColor UIColorFromRGB(0x434343)

#define kHomeBackColor UIColorFromRGB(0xfafafa)
#define kHomeLineColor UIColorFromRGB(0xe5e5e5)

#define kNavigationTitleFontSize 18
#define kNavigationBackFontSize 17

// 黄色
#define kYellowColor [UIColor colorWithRed:238.0/255 green:133.0/255 blue:38.0/255 alpha:1]
// 背景灰色
#define kGrayColor [UIColor colorWithRed:246.0/255 green:246.0/255 blue:246.0/255 alpha:1]
// 系统灰色
#define kSystemGray [UIColor grayColor]
// 字体灰色
#define kWriteGray [UIColor colorWithRed:147.0/255 green:158.0/255 blue:167.0/255 alpha:1]
// 字体蓝色
#define kWriteBule [UIColor colorWithRed:21.0/255 green:158.0/255 blue:208.0/255 alpha:1]
// 黑色
#define kBlack [UIColor blackColor]
// 白色
#define KWhiteColor [UIColor whiteColor]
// 屏幕宽度
#define kWidth self.view.frame.size.width
// 屏幕高度
#define kHeight self.view.frame.size.height

// App Frame Height&Width
#define Application_Frame  [[UIScreen mainScreen] applicationFrame] //除去信号区的屏幕的frame

#define APP_Frame_Height   [[UIScreen mainScreen] applicationFrame].size.height //应用程序的屏幕高度

#define App_Frame_Width    [[UIScreen mainScreen] applicationFrame].size.width  //应用程序的屏幕宽度

// 红色
#define KRedColor [UIColor colorWithRed:188.0/255 green:0.0/255 blue:0.0/255 alpha:1]


//RecommendCell background color
#define RcommendCellColor [UIColor colorWithRed:251.0/255 green:204.0/255 blue:109.0/255 alpha:1]



#define IOS7   [[UIDevice currentDevice]systemVersion].floatValue>=7.0
#define IOS8   [[UIDevice currentDevice]systemVersion].floatValue>=8.0

// 分享
//#import "ShareContext.h"
#define KShareSDK_AppKey @"81f63f7ffa88"
// 微博
#define KWeiBo_AppKey @"2889563526"
#define KWeiBo_AppSecret @"a56692683e70bff750a2716557cfde83"
// 微信
#define KWeiXin_AppId @"wx63ff6a896ecfe7c1"
#define KWeiXin_AppSecret @"3a006da5543a6d237573925dc43d78b1"
// QQ空间
#define KQQZone_AppID @"1104558435" //16进制：41D63963
#define KQQZone_AppKey @"Z45sO6PUTQvP8ni6"  // 特别说明 appKey 就是 appSecret
#define KQQZone_AppSecret @"Z45sO6PUTQvP8ni6"



// App Frame Height&Width
#define Application_Frame  [[UIScreen mainScreen] applicationFrame] //除去信号区的屏幕的frame
#define APP_Frame_Height   [[UIScreen mainScreen] applicationFrame].size.height //应用程序的屏幕高度
#define App_Frame_Width    [[UIScreen mainScreen] applicationFrame].size.width  //应用程序的屏幕宽度
#define APP_Navgationbar_Height 64
#define APP_Tabbar_Height 49

/*** MainScreen Height Width */
#define Main_Screen_Height [[UIScreen mainScreen] bounds].size.height //主屏幕的高度
#define Main_Screen_Width  [[UIScreen mainScreen] bounds].size.width  //主屏幕的宽度

#define AppKeyWindow [UIApplication sharedApplication].keyWindow

#define AppD ((AppDelegate *)[UIApplication sharedApplication].delegate)

#define DefaultToastDuration 1.5

//计算显示宽度
#define UI_CONTENT_WIDTH ([[UIScreen mainScreen] bounds].size.width)
//计算显示的高度
#define UI_CONTENT_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

//iphone4适应
#define IS_IPHONE_4 (fabs((double)MAX(UI_CONTENT_WIDTH, UI_CONTENT_HEIGHT) - (double)480) < DBL_EPSILON)
//iphone5适应
#define IS_IPHONE_5 (fabs((double)MAX(UI_CONTENT_WIDTH, UI_CONTENT_HEIGHT) - (double)568) < DBL_EPSILON)
//判断iPhone6plus
#define IS_IPHONE_6_PLUS (fabs((double)MAX(UI_CONTENT_WIDTH, UI_CONTENT_HEIGHT) - (double)736) < DBL_EPSILON)
//判断iPhone6
#define IS_IPHONE_6 (fabs((double)MAX(UI_CONTENT_WIDTH, UI_CONTENT_HEIGHT) - (double)667) < DBL_EPSILON)



#endif /* Defaults_h */
