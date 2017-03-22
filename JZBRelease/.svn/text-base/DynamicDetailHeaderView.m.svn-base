//
//  DynamicDetailHeaderView.m
//  JZBRelease
//
//  Created by zjapple on 16/5/9.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "DynamicDetailHeaderView.h"

@interface DynamicDetailHeaderView()<LWAsyncDisplayViewDelegate>{
    UIView *intevalView;
}

@property (nonatomic,strong) LWAsyncDisplayView* asyncDisplayView;

@end

@implementation DynamicDetailHeaderView

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.asyncDisplayView];
    }
    return self;
}

#pragma mark - Actions

- (void)lwAsyncDisplayView:(LWAsyncDisplayView *)asyncDisplayView
   didCilickedImageStorage:(LWImageStorage *)imageStorage
                     touch:(UITouch *)touch{
    CGPoint point = [touch locationInView:self];
    point = CGPointMake(point.x, point.y - 64);
    for (NSInteger i = 0; i < self.cellLayout.imagePostionArray.count; i ++) {
        CGRect imagePosition = CGRectFromString(self.cellLayout.imagePostionArray[i]);
        //点击查看大图
        if (CGRectContainsPoint(imagePosition, point)) {
            if ([self.delegate respondsToSelector:@selector(tableViewCell:didClickedImageWithCellLayout:atIndex:)] &&
                [self.delegate conformsToProtocol:@protocol(TableViewCellDelegate)]) {
                [self.delegate tableViewCell:self didClickedImageWithCellLayout:self.cellLayout atIndex:i];
            }
        }
        
    }
    point = CGPointMake(point.x, point.y + 64);
    //点击菜单按钮
    if (CGRectContainsPoint(CGRectMake(self.cellLayout.menuPosition.origin.x - 10,
                                       self.cellLayout.menuPosition.origin.y - 10,
                                       self.cellLayout.menuPosition.size.width + 20,
                                       self.cellLayout.menuPosition.size.height + 20), point)) {
     
    }
    //click comment
    if (CGRectContainsPoint(CGRectMake(self.cellLayout.commentPosition.origin.x - 10,
                                       self.cellLayout.commentPosition.origin.y - 10,
                                       self.cellLayout.commentPosition.size.width + 20,
                                       self.cellLayout.commentPosition.size.height + 20), point)) {
       
        [self didClickedCommentButton:Clink_Type_One];
    }
    //click good
    if (CGRectContainsPoint(CGRectMake(self.cellLayout.goodPosition.origin.x - 10,
                                       self.cellLayout.goodPosition.origin.y - 10,
                                       self.cellLayout.goodPosition.size.width + 20,
                                       self.cellLayout.goodPosition.size.height + 20), point)) {
        NSLog(@"hi has hitted %ld row",(long)self.indexPath.row);
        [self didClickedCommentButton:Clink_Type_Two];
    }
    //click reward
    if (CGRectContainsPoint(CGRectMake(self.cellLayout.rewardPosition.origin.x - 10,
                                       self.cellLayout.rewardPosition.origin.y - 10,
                                       self.cellLayout.rewardPosition.size.width + 20,
                                       self.cellLayout.rewardPosition.size.height + 20), point)) {
        NSLog(@"hi has hitted %ld row",(long)self.indexPath.row);
        [self didClickedCommentButton:Clink_Type_Three];
    }
    //click share
    if (CGRectContainsPoint(CGRectMake(self.cellLayout.sharePosition.origin.x - 10,
                                       self.cellLayout.sharePosition.origin.y - 10,
                                       self.cellLayout.sharePosition.size.width + 20,
                                       self.cellLayout.sharePosition.size.height + 20), point)) {
        NSLog(@"hi has hitted %ld row",(long)self.indexPath.row);
        [self didClickedCommentButton:Clink_Type_Four];
    }
    
    //singlereward
    if (CGRectContainsPoint(CGRectMake(self.cellLayout.singleRewardPosition.origin.x - 10,
                                       self.cellLayout.singleRewardPosition.origin.y - 10,
                                       self.cellLayout.singleRewardPosition.size.width + 20,
                                       self.cellLayout.singleRewardPosition.size.height + 20), point)) {
        NSLog(@"hi has hitted %ld row",(long)self.indexPath.row);
        [self didClickedCommentButton:Clink_Type_Three];
    }
    
    //click avatar
    if (CGRectContainsPoint(CGRectMake(((self.cellLayout)).avatarPosition.origin.x - 10,
                                       ((self.cellLayout)).avatarPosition.origin.y - 10,
                                       ((self.cellLayout)).avatarPosition.size.width + 20,
                                       ((self.cellLayout)).avatarPosition.size.height + 20), point)) {
        NSLog(@"hi has hitted %ld row",(long)self.indexPath.row);
        [self didClickedCommentButton:Clink_Type_Seven];
    }

}



/**
 *  点击链接回调
 *
 */
- (void)lwAsyncDisplayView:(LWAsyncDisplayView *)asyncDisplayView didCilickedLinkWithfData:(id)data withType:(Clink_Type)clink_type{
    if ([self.delegate respondsToSelector:@selector(tableViewCell:didClickedLinkWithData:clinkType:)] &&
        [self.delegate conformsToProtocol:@protocol(TableViewCellDelegate)]) {
        [self.delegate tableViewCell:self didClickedLinkWithData:data clinkType:clink_type];
    }
}


/**
 *  点击评论
 *
 */
- (void)didClickedCommentButton:(Clink_Type) clink_type {
    if ([self.delegate respondsToSelector:@selector(tableViewCell:didClickedCommentWithCellLayout:atIndexPath:clinkType:)]) {
        [self.delegate tableViewCell:self didClickedCommentWithCellLayout:self.cellLayout atIndexPath:0 clinkType:clink_type];
        
    }
}


#pragma mark - Draw and setup

- (void)setCellLayout:(CellLayout *)cellLayout {
    if (_cellLayout == cellLayout) {
        return;
    }
    _cellLayout = cellLayout;
    self.asyncDisplayView.layout = cellLayout;
    __weak typeof (self) wself = self;
    if (!self.infoView) {
        self.infoView = [InfoShowView getInfoShowViewWithData:_cellLayout.statusModel.user WithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
        self.infoView.isCaina = NO;
        [self.infoView updateFrameWithData:_cellLayout.statusModel.user];
        self.infoView.returnAction = ^(NSInteger tag){
            if ([wself.delegate respondsToSelector:@selector(tableViewCell:didClickedCommentWithCellLayout:atIndexPath:clinkType:)]) {
                [wself.delegate tableViewCell:wself didClickedCommentWithCellLayout:wself.cellLayout atIndexPath:wself.indexPath clinkType:Clink_Type_Six];
            }
        };
        [self.contentView addSubview:self.infoView];
        
    }else{
        self.infoView.isCaina = NO;
        [self.infoView updateFrameWithData:_cellLayout.statusModel.user];
    }
    self.asyncDisplayView.layout = cellLayout;
    [self.asyncDisplayView setFrame:CGRectMake(0, 64, SCREEN_WIDTH, cellLayout.cellHeight)];
    if (!self.tabItemBarView) {
        self.tabItemBarView = [CommentTabItemBarView getCommentTabItemBarViewWithFrame:CGRectMake(0, cellLayout.cellHeight + 64, SCREEN_WIDTH, 44) IsQuestionOwner:NO];
        self.tabItemBarView.returnAction = ^(NSInteger tag){
            if (0 == tag) {
                if ([wself.delegate respondsToSelector:@selector(tableViewCell:didClickedCommentWithCellLayout:atIndexPath:clinkType:)]) {
                    [wself.delegate tableViewCell:wself didClickedCommentWithCellLayout:wself.cellLayout atIndexPath:wself.indexPath clinkType:Clink_Type_Two];
                }
            }else if (1 == tag){
                if ([wself.delegate respondsToSelector:@selector(tableViewCell:didClickedCommentWithCellLayout:atIndexPath:clinkType:)]) {
                    [wself.delegate tableViewCell:wself didClickedCommentWithCellLayout:wself.cellLayout atIndexPath:wself.indexPath clinkType:Clink_Type_Three];
                }
            }else if (2 == tag){
                if ([wself.delegate respondsToSelector:@selector(tableViewCell:didClickedCommentWithCellLayout:atIndexPath:clinkType:)]) {
                    [wself.delegate tableViewCell:wself didClickedCommentWithCellLayout:wself.cellLayout atIndexPath:wself.indexPath clinkType:Clink_Type_One];
                }
            }else if (3 == tag){
                if ([wself.delegate respondsToSelector:@selector(tableViewCell:didClickedCommentWithCellLayout:atIndexPath:clinkType:)]) {
                    [wself.delegate tableViewCell:wself didClickedCommentWithCellLayout:wself.cellLayout atIndexPath:wself.indexPath clinkType:Clink_Type_Four];
                }
            }
        };
        [self.contentView addSubview:self.tabItemBarView];
    }
    
    
    
    [self.tabItemBarView setFrame:CGRectMake(0, cellLayout.cellHeight + 64, SCREEN_WIDTH, 44)];
    [self.tabItemBarView updateViews:_cellLayout.statusModel];
    if (!intevalView) {
        intevalView = [[UIView alloc]initWithFrame:CGRectMake(0, self.tabItemBarView.frame.origin.y + self.tabItemBarView.frame.size.height, SCREEN_WIDTH, 10)];
        [intevalView setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"f2f2f2"]];
        [self.contentView addSubview:intevalView];
    }
    [intevalView setFrame:CGRectMake(0, self.tabItemBarView.frame.origin.y + self.tabItemBarView.frame.size.height, SCREEN_WIDTH, 10)];

}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.asyncDisplayView.frame = CGRectMake(0,
                                             0,
                                             SCREEN_WIDTH,
                                             self.cellLayout.cellHeight);
 
}

//- (void)extraAsyncDisplayIncontext:(CGContextRef)context size:(CGSize)size {
//    //绘制分割线
//    CGContextMoveToPoint(context, 0.0f, self.bounds.size.height);
//    CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height);
//    CGContextSetLineWidth(context, 0.3f);
//    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
//    CGContextStrokePath(context);
//}

- (void)_drawImage:(UIImage *)image rect:(CGRect)rect context:(CGContextRef)context {
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, rect.origin.x, rect.origin.y);
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextTranslateCTM(context, -rect.origin.x, -rect.origin.y);
    CGContextDrawImage(context, rect, image.CGImage);
    CGContextRestoreGState(context);
}

#pragma mark - Getter

- (LWAsyncDisplayView *)asyncDisplayView {
    if (!_asyncDisplayView) {
        _asyncDisplayView = [[LWAsyncDisplayView alloc] initWithFrame:CGRectZero maxImageStorageCount:15];
        _asyncDisplayView.delegate = self;
    }
    return _asyncDisplayView;
}


@end
