//
//  recorderPlayView.h
//  JZBRelease
//
//  Created by Apple on 16/11/14.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GLRecorderTool;

@interface recorderPlayView : UIView

/** tool */
@property (nonatomic, strong) GLRecorderTool * tool;

/** playLocalStr */
@property (nonatomic, strong) NSString *playLocalStr;

@property (nonatomic, strong) UILabel * rightLabel0;
@property (nonatomic, strong) UILabel * rightLabel1;

@property (nonatomic, strong) UIView *imageBGSmall,*imageBGBig;

@property (nonatomic, assign) BOOL isLongOrShort;

@property (nonatomic, copy) void (^ playBlock)();

- (instancetype)initWithContent:(NSString *)content;

- (void)stopAnima;

- (void)startAnima;

@end
