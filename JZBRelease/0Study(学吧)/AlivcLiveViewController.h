//
//  AlivcLiveViewController.h
//  DevAlivcLiveVideo
//
//  Created by lyz on 16/3/21.
//  Copyright © 2016年 Alivc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveVideoDetailItem.h"
@class Users;

@interface AlivcLiveViewController : UIViewController

/** item */
@property (nonatomic, strong) LiveVideoDetailItem *liveitem;

/** loveRankDataSource */
@property (nonatomic, strong) NSArray *loveRankDataSource;
/** question */
@property (nonatomic, strong) NSArray *question;
/** class_id */
@property (nonatomic, strong) NSString *class_id;
/** 约定直播开始时间 */
@property (nonatomic, strong) NSString *start_time;
/** 约定直播结束时间 */
@property (nonatomic, strong) NSString *end_time;

/** teacher */
@property (nonatomic, strong) Users *teacher;

/** Users */
@property (nonatomic, strong) NSArray *join_list_user;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, assign) BOOL isScreenHorizontal;
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil url:(NSString *)url;

@end
