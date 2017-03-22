//
//  XBOffLiveVoiceShowVC.h
//  JZBRelease
//
//  Created by zjapple on 16/10/21.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveVideoDetailItem.h"
@interface XBOffLiveVoiceShowVC : UIViewController

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

@end
