//
//  DynamicCell.h
//  JZBRelease
//
//  Created by zjapple on 16/5/12.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LWAsyncDisplayView.h"
#import "DynamicLayout.h"
#import "TableViewCellDelegate.h"
#import "LWDefine.h"
#import "LWImageStorage.h"
#import "InfoShowView.h"
#import "CommentTabItemBarView.h"
@interface DynamicCell : UITableViewCell

@property (nonatomic,weak) id <TableViewCellDelegate> delegate;
@property (nonatomic,strong) CellLayout *cellLayout;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,strong) InfoShowView *infoView;
@property (nonatomic,strong) CommentTabItemBarView *tabItemBarView;
@end
