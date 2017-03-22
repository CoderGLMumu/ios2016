//
//  PushToVideoPopView.h
//  JZBRelease
//
//  Created by zjapple on 16/9/21.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PushToVideoPopView : UIView

/** paySorce */
@property (nonatomic, strong) NSString *payScore;
/** paySorce */
@property (nonatomic, strong) NSString *stillScore;

/** class_id */
@property (nonatomic, strong) NSString *class_id;

@property (nonatomic, strong) NSString *type;

+ (instancetype)pushToVideoPopView;

- (void)updateData;

/** 关闭window消息 */
@property (nonatomic, copy) void(^clickCloseWindow)();

/** 点击了立即推送的 消息回调 */
@property (nonatomic, copy) void(^clickPayUp)();

/** 成功购买的回调 */
@property (nonatomic, copy) void(^passToLive)();

@end
