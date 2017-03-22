//
//  startNoticeView.m
//  JZBRelease
//
//  Created by zjapple on 16/9/23.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "startNoticeView.h"


#import "Masonry.h"
#import <AVFoundation/AVFoundation.h>

@interface startNoticeView ()

@property (weak, nonatomic) IBOutlet UIImageView *backGImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleaLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UILabel *zhunshizhiboLabel;
@property (weak, nonatomic) IBOutlet UILabel *liveNoticeLabel;
@property (weak, nonatomic) IBOutlet UIToolbar *MBLtoolBar;
@property (weak, nonatomic) IBOutlet UIView *BGView;


@end

@implementation startNoticeView
{
    BOOL _isMediaSliderBeingDragged;
}

+ (instancetype)startNoticeView
{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]firstObject];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
//    [self refreshMediaControl];
    
    /** 每秒更新视频进度 */
    //self.progress_timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(time_second_listen) userInfo:nil repeats:YES];
    //[[NSRunLoop currentRunLoop]addTimer:self.progress_timer forMode:NSRunLoopCommonModes];
}

- (void)setLiveitem:(LiveVideoDetailItem *)liveitem
{
    _liveitem = liveitem;
    
//    [self.backGImageView sd_setImageWithURL:[NSURL URLWithString:[AddHostToLoadPIC AddHostToLoadPICWithString:self.liveitem.thumb2]] placeholderImage:[UIImage imageNamed:@"视频占位图片"]];
    
    [LocalDataRW getImageWithDirectory:Directory_XB RetalivePath:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:self.liveitem.thumb2] WithContainerImageView:self.backGImageView];
    
    if (self.isVoice) {
        self.titleaLabel.hidden = YES;
        self.timeLabel.hidden = YES;
        self.closeButton.hidden = YES;
        self.zhunshizhiboLabel.hidden = YES;
        self.liveNoticeLabel.hidden = YES;
        self.MBLtoolBar.hidden = YES;
        self.BGView.hidden = YES;
        
    }
    
    self.titleaLabel.text = self.liveitem.title;
    
    NSTimeInterval time= [self.liveitem.start_time doubleValue];
    if (time) {
        self.timeLabel.text = [[self dateFormatter] stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]];
        self.zhunshizhiboLabel.hidden = NO;
    }else {
        self.timeLabel.text = @"即将到来，尽请期待";
        self.zhunshizhiboLabel.hidden = YES;
    }
}

- (NSDateFormatter *)dateFormatter {
    static NSDateFormatter* dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YY年MM月dd日 hh:mm"];
    });
    return dateFormatter;
}

- (IBAction)closeWindow:(UIButton *)sender {
    
    [self removeFromSuperview];
}

#pragma mark - OnlineVideoPlayView工具条事件处理
- (IBAction)onClickPlayOrPause:(UIButton *)sender {
    
    if (self.onClickPlayButton) {
        self.onClickPlayButton(sender);
    }
    
}




//#pragma mark - 刷新工具条
//- (void)refreshMediaControl
//{
//    // duration
//    NSTimeInterval duration = self.delegatePlayer.duration;
//    NSInteger intDuration = duration + 0.5;
//    if (intDuration > 0) {
//        self.mediaProgressSlider.maximumValue = duration;
//        self.totalDurationLabel.text = [NSString stringWithFormat:@"%02d:%02d", (int)(intDuration / 60), (int)(intDuration % 60)];
//    } else {
//        self.totalDurationLabel.text = @"--:--";
//        self.mediaProgressSlider.maximumValue = 1.0f;
//    }
//    
//    
//    // position
//    NSTimeInterval position;
//    if (_isMediaSliderBeingDragged) {
//        position = self.mediaProgressSlider.value;
//    } else {
//        position = self.delegatePlayer.currentPlaybackTime;
//    }
//    NSInteger intPosition = position + 0.5;
//    if (intDuration > 0) {
//        self.mediaProgressSlider.value = position;
//    } else {
//        self.mediaProgressSlider.value = 0.0f;
//    }
//    self.currentTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d", (int)(intPosition / 60), (int)(intPosition % 60)];
//    
//    
//    // status
//    //    BOOL isPlaying = [self.delegatePlayer isPlaying];
//    //    self.playButton.hidden = isPlaying;
//    //    self.pauseButton.hidden = !isPlaying;
//    
//    
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshMediaControl) object:nil];
////    if (!self.overlayPanel.hidden) {
////        [self performSelector:@selector(refreshMediaControl) withObject:nil afterDelay:0.5];
////    }
//    [self performSelector:@selector(refreshMediaControl) withObject:nil afterDelay:0.5];
//}
//
//#pragma mark - 每秒设置进度条的进度
//- (void)time_second_listen
//{
//    self.ProgressValueView.progress = self.delegatePlayer.playableDuration / self.delegatePlayer.duration;
//}

//#pragma mark - 拖拽进度条
//- (void)beginDragMediaSlider
//{
//    _isMediaSliderBeingDragged = YES;
//}
//
//- (void)endDragMediaSlider
//{
//    _isMediaSliderBeingDragged = NO;
//}
//- (void)continueDragMediaSlider
//{
//    [self refreshMediaControl];
//}
//
//
//- (IBAction)didSliderTouchDown
//{
//    [self beginDragMediaSlider];
//    
//}
//
//- (IBAction)didSliderTouchCancel
//{
//    [self endDragMediaSlider];
//    
//}
//
//- (IBAction)didSliderTouchUpOutside
//{
//    [self endDragMediaSlider];
//    
//}
//
//- (IBAction)didSliderTouchUpInside
//{
////    self.player.currentPlaybackTime = self.playView.mediaProgressSlider.value;
//    
//    if (self.endDragSlider) {
//        self.endDragSlider(self.mediaProgressSlider.value);
//    }
//
//    [self endDragMediaSlider];
//   
//}
//
//- (IBAction)didSliderValueChanged
//{
//    [self continueDragMediaSlider];
//   
//}


@end
