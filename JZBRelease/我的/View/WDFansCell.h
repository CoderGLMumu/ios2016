//
//  WDFansCell.h
//  JZBRelease
//
//  Created by zjapple on 16/10/17.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MySaleList.h"

@interface WDFansCell : UITableViewCell

///** model */
//@property (nonatomic, strong) reward_rankItem *model;

- (void)updateSubViewConstraints;

/** isReferrer */
@property (nonatomic, assign) BOOL isReferrer;

/** item */
@property (nonatomic, strong) Users *item;

/** MySaleList */
@property (nonatomic, strong) MySaleList *model;

/** callActiveBtn */
@property (nonatomic, copy) void(^callActiveBtn)();

/** isReferrer */
@property (nonatomic, assign) BOOL isinitButton;

@end
