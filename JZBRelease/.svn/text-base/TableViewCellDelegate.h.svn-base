//
//  TableViewCellDelegate.h
//  JZBRelease
//
//  Created by zjapple on 16/5/6.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#ifndef TableViewCellDelegate_h
#define TableViewCellDelegate_h
#import "LWLayout.h"
#import <UIKit/UIKit.h>
@protocol TableViewCellDelegate <NSObject>

- (void)tableViewCell:(UITableViewCell *)cell didClickedImageWithCellLayout:(LWLayout *)layout
              atIndex:(NSInteger)index;

- (void)tableViewCell:(UITableViewCell *)cell didClickedLinkWithData:(id)data clinkType:(Clink_Type) clink_type;

- (void)tableViewCell:(UITableViewCell *)cell didClickedCommentWithCellLayout:(LWLayout *)layout
          atIndexPath:(NSIndexPath *)indexPath clinkType:(Clink_Type) clink_type;


@end

#endif /* TableViewCellDelegate_h */
