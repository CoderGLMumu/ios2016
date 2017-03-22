//
//  XBLiveComputerShowVC.h
//  JZBRelease
//
//  Created by Apple on 16/12/8.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveVideoDetailItem.h"

@interface XBLiveComputerShowVC : UIViewController

/** playurl */
@property (nonatomic, strong) NSString *playUrl;
/** item */
@property (nonatomic, strong) LiveVideoDetailItem *liveitem;

/** class_id */
@property (nonatomic, strong) NSString *class_id;
/** teacher */
@property (nonatomic, strong) Users *teacher;
/** question */
@property (nonatomic, strong) NSArray *question;
/** question */
@property (nonatomic, strong) NSArray *loveRankDataSource;

@end
