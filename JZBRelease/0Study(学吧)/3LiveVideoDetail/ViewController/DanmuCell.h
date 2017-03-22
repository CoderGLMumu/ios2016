//
//  DanmuCell.h
//  JZBRelease
//
//  Created by Apple on 16/12/2.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DanmuLabel.h"
#import "DanmuItem.h"

@interface DanmuCell : UITableViewCell

/** model */
@property (nonatomic, strong) DanmuItem *model;

@end
