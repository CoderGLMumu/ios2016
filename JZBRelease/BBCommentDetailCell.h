//
//  BBCommentDetailCell.h
//  JZBRelease
//
//  Created by cl z on 16/7/26.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LWAsyncDisplayView.h"
#import "TableViewCellDelegate.h"
#import "LWDefine.h"
#import "LWImageStorage.h"
#import "CommentDetailLayout.h"
@interface BBCommentDetailCell : UITableViewCell

@property (nonatomic,weak) id<TableViewCellDelegate> delegate;
@property (nonatomic,strong) CommentDetailLayout *cellLayout;
@property (nonatomic,strong) NSIndexPath *indexPath;

@end
