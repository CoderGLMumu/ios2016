//
//  TBMoiveViewController.h
//  PlayerTest
//
//  Created by shiping chen on 15/9/25.
//  Copyright © 2015年 shiping chen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, VideoActionType) {
    VideoActionTypeNULL = 1 << 0, //1
    VideoActionTypePreparedPlay = 1 << 1,
    VideoActionTypeVideoError = 1 << 2,
//    VideoActionTypeRight = 1 << 3,
    VideoActionTypeClose = 1 << 3,
};

@interface TBMoiveViewController : UIViewController

/**
 * 顶部区域和底部区域按钮栏的背景颜色
 */
@property (nonatomic, strong) UIColor *barColor;

/**
 * 顶部区域和底部区域按钮栏的高度
 */
@property (nonatomic, assign) CGFloat barHeight;

/**
 * 用来控制按钮显示之后消失的时间
 */
@property (nonatomic, assign) NSTimeInterval fadeDelay;

/**
 * 用来控制快进快退按钮点击一次的跳转进度
 */
@property (nonatomic, assign) NSTimeInterval seekTimeSpan;

/**
 * 用来控制是否显示剩余时间还是显示总的时间长度
 */
@property (nonatomic) BOOL timeRemainingDecrements;

/**
 * 用来控制是视频播放view的大小
 */
@property (nonatomic, assign) CGRect videoFrame;

/**
 * 直播预告
 */
@property (nonatomic, assign) BOOL isStartNotice;

/**
 * 直播预告
 */
@property (nonatomic, assign) BOOL isVoice;

/**
 * 用来控制视频期间的回调消息
 */
@property (nonatomic, copy) void(^callBack)(NSString *timeLabel,VideoActionType type);
/**
 * 用来传递点击视频view的消息
 */
@property (nonatomic, copy) void(^clickVideoView)();

- (void)closePlayer;

/**
 *  设置播放的视频地址，需要在试图启动之前设置
 *  参数url为本地地址或网络地址
 *  如果位本地地址，则需要用[NSURL fileURLWithPath:path]初始化NSURL
 *  如果为网络地址则需要用[NSURL URLWithString:path]初始化NSURL
 */
- (void) SetMoiveSource:(NSURL*)url;

/**
 * 缓存指示器
 */
@property (nonatomic, weak) UIView *activityBackgroundView1;

@end
