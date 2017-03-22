//
//  XBSmallView.h
//  JZBRelease
//
//  Created by cl z on 16/10/12.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseTimeModel.h"
@interface XBSmallView : UIView

@property(nonatomic,assign) BOOL isTwoSmall;
@property(nonatomic,assign) BOOL isThreeSmall;
@property(nonatomic,strong) CourseTimeModel *models;

+ (XBSmallView *) initWithModel:(CourseTimeModel *) model WithFrame:(CGRect) frame;

- (void) updateWithModel:(CourseTimeModel *) models;

@end
