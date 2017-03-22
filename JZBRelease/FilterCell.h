//
//  FilterCell.h
//  JZBRelease
//
//  Created by zjapple on 16/5/6.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LWAsyncDisplayView.h"
#import "FilterLayout.h"
#import "TableViewCellDelegate.h"

@interface FilterCell : UITableViewCell<TableViewCellDelegate>

@property (nonatomic,weak) id <TableViewCellDelegate> delegate;
@property (nonatomic,strong) FilterLayout* cellLayout;
@property (nonatomic,strong) NSIndexPath* indexPath;



@end
