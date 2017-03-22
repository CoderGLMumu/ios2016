//
//  GLRecorderTool.h
//  JZBRelease
//
//  Created by Apple on 16/11/11.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocalDataRW.h"
#import <SYIMAmrCore/SYIMAmrCore.h>
#import "SYSharedTool.h"
#import "voiceTipView.h"
#import "voiceTipView.h"

@interface GLRecorderTool : NSObject

+ (instancetype)getInstance;

/** 开始录音 */
- (void)startRecord;
/** 停止录音 */
- (void)stopRecord;
/** 播放录音 */
- (void)playRecord;
- (void)playRecordWithJZBPath:(NSString *)mPath;

/** 停止播放录音 */
- (void)stopPlaylayRecord;

/** 取消录音 */
- (void)cancelRecord;

/** 上传录音 */
- (void)uploadRecordWithquestion_id:(NSString *)question_id Audio_length:(NSString *)audio_length eval_id:(NSString *)eval_id;

/** stopanima */
@property (nonatomic, copy) void(^stopanima)();

/** 发送语音，通知主线程更新ui */
@property (nonatomic, copy) void(^updateUI)();

/** showVC */
@property (nonatomic, weak) UIViewController *showVC;


@property (nonatomic, strong) SYIMAmrRecorder *amrRecorder;//录音机
@property (nonatomic, strong) SYIMAmrPlayer *amrPlayer;//播放机

@property (nonatomic, strong) voiceTipView *voiceView;//播放view

- (void)hiddenVoiceView;
- (void)showVoiceView;

- (void)changeBotLabelText:(BotLabelType)type;

@end
