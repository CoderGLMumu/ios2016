//
//  DanmuItem.h
//  JZBRelease
//
//  Created by Apple on 16/12/3.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DanmuItem : NSObject

/** isvip */
@property (nonatomic, assign) BOOL isvip;
/** userName 颜色ff9800 */
@property (nonatomic, strong) NSString *userName;
/** allstring */
@property (nonatomic, strong) NSString *allstring;
/** 【电脑】content 颜色212121 */
@property (nonatomic, strong) NSString *content_black;
/** 【电脑】用户发送的弹幕 黑色文本 */
@property (nonatomic, assign) BOOL is_blackcontent;
/** 【电脑】content 颜色2196f3 */
@property (nonatomic, strong) NSString *content_blue;
/** 【电脑】用户进入房间 蓝色文本  */
@property (nonatomic, assign) BOOL is_bluecontent;
/** 【电脑】content 颜色ff0202 */
@property (nonatomic, strong) NSString *content_red;
/** 【电脑】用户打赏礼物 红色 */
@property (nonatomic, assign) BOOL is_redcontent;


/** 【手机】content 颜色 白色 */
@property (nonatomic, strong) NSString *content_white_mob;
/** 【手机】用户发送的弹幕 黑色文本 */
@property (nonatomic, assign) BOOL is_whitecontent_mob;
/** 【手机】content 颜色00f2f3 */
@property (nonatomic, strong) NSString *content_blue_mob;
/** 【手机】用户进入房间 绿色文本  */
@property (nonatomic, assign) BOOL is_bluecontent_mob;
/** 【手机】content 颜色53ffb9 */
@property (nonatomic, strong) NSString *content_green_mob;
/** 【手机】用户打赏礼物 蓝色文本 */
@property (nonatomic, assign) BOOL is_greencontent_mob;

/** isfisrtLabel */
@property (nonatomic, assign) BOOL isfisrtLabel;
/** fisrtName */
@property (nonatomic, strong) NSString *fisrtName;

@end
