//
//  WDBDetailCell.h
//  MyBang
//
//  Created by mac on 16/10/4.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WDBDetailItem.h"
#import "WDBmember.h"

@interface WDBDetailCell : UITableViewCell

/** model */
@property (nonatomic, strong) WDBmember *model;

/** user */
@property (nonatomic, strong) Users *user;

@end
