//
//  BigViewCell.h
//  JZBRelease
//
//  Created by cl z on 16/12/8.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseTimeModel.h"
#import "XBBigView.h"
@interface BigViewCell : UITableViewCell

@property(nonatomic,strong) CourseTimeModel *model;
@property(nonatomic,strong) XBBigView *bigView;
@end
