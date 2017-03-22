//
//  avaIconCell.h
//  JZBRelease
//
//  Created by zjapple on 16/9/26.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpBaseRequestItem.h"
#import "online_userItem.h"

@interface avaIconCell : UICollectionViewCell

/** Users */
@property (nonatomic, strong) HttpBaseRequestItem *item;
/** useritem */
@property (nonatomic, strong) online_userItem *useritem;

@end
