//
//  XBLiveMobileVideoShowVC.h
//  JZBRelease
//
//  Created by zjapple on 16/9/13.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LiveVideoDetailItem.h"

@interface XBLiveMobileVideoShowVC : UIViewController

/** isBackVideo */
@property (nonatomic, assign) BOOL isBackVideo;

/** class_id */
@property (nonatomic, strong) NSString *class_id;

/** teacher */
@property (nonatomic, strong) Users *teacher;

/** online_userItem */
@property (nonatomic, strong) NSArray *join_list_user;
/** question */
@property (nonatomic, strong) NSArray *question;
/** loveRankDataSource */
@property (nonatomic, strong) NSArray *loveRankDataSource;

/** playurl */
@property (nonatomic, strong) NSString *playUrl;

/** callBackDataS */
@property (nonatomic, copy) void(^callBackDataS)(NSArray *dataSource);

/** item */
@property (nonatomic, strong) LiveVideoDetailItem *liveitem;

@end
