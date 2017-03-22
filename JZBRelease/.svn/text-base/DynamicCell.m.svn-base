//
//  DynamicCell.m
//  JZBRelease
//
//  Created by zjapple on 16/5/12.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "DynamicCell.h"
#import "DynamicLayout.h"

@interface DynamicCell()<LWAsyncDisplayViewDelegate>{
    UIView *intevalView;
}

@property (nonatomic,strong) LWAsyncDisplayView* asyncDisplayView;

@end

@implementation DynamicCell

#pragma mark - Init

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
    
    //click comment
    if (CGRectContainsPoint(CGRectMake(self.cellLayout.commentPosition.origin.x - 15,
                                       self.cellLayout.commentPosition.origin.y - 15,
                                       self.cellLayout.commentPosition.size.width + 30,
                                       self.cellLayout.commentPosition.size.height + 30), point)) {
        NSLog(@"hi has hitted %ld row",(long)self.indexPath.row);
        [self didClickedCommentButton:Clink_Type_One];
    }

    //click avatar
    if (CGRectContainsPoint(CGRectMake(((DynamicLayout *)(self.cellLayout)).avatarPosition1.origin.x - 10,
                                       ((DynamicLayout *)(self.cellLayout)).avatarPosition1.origin.y - 10,
                                       ((DynamicLayout *)(self.cellLayout)).avatarPosition1.size.width + 20,
                                       ((DynamicLayout *)(self.cellLayout)).avatarPosition1.size.height + 20), point)) {
        NSLog(@"hi has hitted %ld row",(long)self.indexPath.row);
        [self didClickedCommentButton:Clink_Type_Six];
    }
}


/**
 *  点击链接回调
 *
 */
- (void)lwAsyncDisplayView:(LWAsyncDisplayView *)asyncDisplayView didCilickedLinkWithfData:(id)data withType:(Clink_Type)clink_type {
    if ([self.delegate respondsToSelector:@selector(tableViewCell:didClickedLinkWithData:clinkType:)] &&
        [self.delegate conformsToProtocol:@protocol(TableViewCellDelegate)]) {
        [self.delegate tableViewCell:self didClickedLinkWithData:data clinkType:clink_type];
    }
}


/**
 *  点击评论
 *
 */
- (void)didClickedCommentButton :(Clink_Type) clink_type{
    if ([self.delegate respondsToSelector:@selector(tableViewCell:didClickedCommentWithCellLayout:atIndexPath:clinkType:)]) {
        [self.delegate tableViewCell:self didClickedCommentWithCellLayout:self.cellLayout atIndexPath:self.indexPath clinkType:clink_type];
        
    }
}


#pragma mark - Draw and setup

- (void)setCellLayout:(DynamicLayout *)cellLayout {
    if (_cellLayout == cellLayout) {
        return;
    }
    _cellLayout = cellLayout;
    self.asyncDisplayView.layout = cellLayout;
    
    __weak typeof (self) wself = self;
    if (!self.infoView) {
        self.infoView = [InfoShowView getInfoShowViewWithData:cellLayout.evaluateModel.user WithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
        self.infoView.isCaina = NO;
        [self.infoView updateFrameWithData:cellLayout.evaluateModel.user];
        self.infoView.returnAction = ^(NSInteger tag){
            if ([wself.delegate respondsToSelector:@selector(tableViewCell:didClickedCommentWithCellLayout:atIndexPath:clinkType:)]) {
                [wself.delegate tableViewCell:wself didClickedCommentWithCellLayout:wself.cellLayout atIndexPath:wself.indexPath clinkType:Clink_Type_Six];
            }
        };
        [self.contentView addSubview:self.infoView];
        
    }else{
        self.infoView.isCaina = NO;
        [self.infoView updateFrameWithData:cellLayout.evaluateModel.user];
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
    
    
    self.tabItemBarView.isBQDetail = YES;
    [self.tabItemBarView setFrame:CGRectMake(0, cellLayout.cellHeight + 64, SCREEN_WIDTH, 44)];
    [self.tabItemBarView updateViews:cellLayout.evaluateModel];
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

- (void)extraAsyncDisplayIncontext:(CGContextRef)context size:(CGSize)size {
    //绘制分割线
    CGContextMoveToPoint(context, 0.0f, self.bounds.size.height);
    CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height);
    CGContextSetLineWidth(context, 0.3f);
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    CGContextStrokePath(context);
}

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
