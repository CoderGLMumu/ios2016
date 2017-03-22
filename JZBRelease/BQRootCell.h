//
//  BQRootCell.h
//  JZBRelease
//
//  Created by zjapple on 16/6/22.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynamicViewLayout.h"
@interface BQRootActivityCel : UITableViewCell

@property (nonatomic,strong) DynamicViewLayout *dynamicView;
@property (nonatomic,strong) NSIndexPath* indexPath;
@end
