




/********************* 有任何问题欢迎反馈给我 liuweiself@126.com ****************************************/
/***************  https://github.com/waynezxcv/Gallop 持续更新 ***************************/
/******************** 正在不断完善中，谢谢~  Enjoy ******************************************************/









#import <UIKit/UIKit.h>
#import "LWAsyncDisplayView.h"
#import "CellLayout.h"
#import "TableViewCellDelegate.h"
#import "InfoShowView.h"
#import "CommentTabItemBarView.h"
//@class TableViewCell;
//
//@protocol TableViewCellDelegate <NSObject>
//
//- (void)tableViewCell:(TableViewCell *)cell didClickedImageWithCellLayout:(CellLayout *)layout
//              atIndex:(NSInteger)index;
//
//- (void)tableViewCell:(TableViewCell *)cell didClickedLinkWithData:(id)data clinkType:(Clink_Type) clink_type;
//
//- (void)tableViewCell:(TableViewCell *)cell didClickedCommentWithCellLayout:(CellLayout *)layout
//              atIndexPath:(NSIndexPath *)indexPath;
//
//
//@end

@interface TableViewCell : UITableViewCell

@property (nonatomic,weak) id <TableViewCellDelegate> delegate;
@property (nonatomic,strong) CellLayout* cellLayout;
@property (nonatomic,strong) NSIndexPath* indexPath;
@property (nonatomic,strong) InfoShowView *infoView;
@property (nonatomic,strong) CommentTabItemBarView *tabItemBarView;


@end


