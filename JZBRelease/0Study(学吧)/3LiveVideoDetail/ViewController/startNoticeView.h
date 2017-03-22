//
//  startNoticeView.h
//  JZBRelease
//
//  Created by zjapple on 16/9/23.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveVideoDetailItem.h"

@protocol IJKMediaPlayback;

@interface startNoticeView : UIView

+ (instancetype)startNoticeView;

/** item */
@property (nonatomic, strong) LiveVideoDetailItem *liveitem;

/** isVoice */
@property (nonatomic, assign) BOOL isVoice;


/** NSTimer *progress_timer */
@property (nonatomic, strong) NSTimer *progress_timer;
- (void)beginDragMediaSlider;
- (void)endDragMediaSlider;
- (void)continueDragMediaSlider;
- (void)refreshMediaControl;
//@property(nonatomic,weak) id<IJKMediaPlayback> delegatePlayer;
@property(nonatomic,strong) IBOutlet UILabel *currentTimeLabel;
@property(nonatomic,strong) IBOutlet UILabel *totalDurationLabel;
@property(nonatomic,strong) IBOutlet UISlider *mediaProgressSlider;
@property (weak, nonatomic) IBOutlet UIProgressView *ProgressValueView;
@property (weak, nonatomic) IBOutlet UIButton *smallPlayOrPause;
@property (weak, nonatomic) IBOutlet UIView *panelView;


/** btn */
@property (nonatomic, copy) void(^onClickPlayButton)(UIButton *btn);
/** btn */
@property (nonatomic, copy) void(^endDragSlider)(float value);

@end
