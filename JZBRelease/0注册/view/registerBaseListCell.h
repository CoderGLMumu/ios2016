//
//  registerBaseListCell.h
//  JZBRelease
//
//  Created by zjapple on 16/8/26.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "registerBaseListModel.h"
@interface registerBaseListCell : UITableViewCell

/** 模型数据 */
@property (nonatomic, strong) registerBaseListModel *model;

/** item */
@property (nonatomic, strong) NSString *item;

@end
