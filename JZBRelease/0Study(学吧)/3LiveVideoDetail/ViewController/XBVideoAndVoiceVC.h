//
//  XBVideoAndVoiceVC.h
//  JZBRelease
//
//  Created by cl z on 16/10/28.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveVideoDetailItem.h"
@interface XBVideoAndVoiceVC : UIViewController

/** class_id */
@property (nonatomic, strong) NSString *class_id;
/** online_userItem */
@property (nonatomic, strong) NSArray *join_list_user;
/** question */
@property (nonatomic, strong) NSArray *question;
/** teacher */
@property (nonatomic, strong) Users *teacher;
/** item */
@property (nonatomic, strong) LiveVideoDetailItem *liveitem;
/** 视频URL */
@property (nonatomic, strong) NSURL *videoURL;

/** 判断是音频或者视频 点播 */
@property (nonatomic, assign) BOOL videoOrVoice;

@end
