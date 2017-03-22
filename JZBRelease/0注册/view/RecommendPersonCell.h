//
//  RecommendPersonCell.h
//  JZBRelease
//
//  Created by zjapple on 16/10/17.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RecommendPersonItem.h"

@interface RecommendPersonCell : UITableViewCell

/** item */
@property (nonatomic, strong) RecommendPersonItem *item;

- (void)updateSubViewConstraints;

@end
