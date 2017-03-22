//
//  BBCommentDetailCell.m
//  JZBRelease
//
//  Created by cl z on 16/7/26.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "BBCommentDetailCell.h"
#import "CommentDetailLayout.h"
@interface BBCommentDetailCell()<LWAsyncDisplayViewDelegate>

@property (nonatomic,strong) LWAsyncDisplayView* asyncDisplayView;

@end

@implementation BBCommentDetailCell
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
    
    if (CGRectContainsPoint(CGRectMake(((CommentDetailLayout *)(self.cellLayout)).avatarPosition1.origin.x - 10,
                                       ((CommentDetailLayout *)(self.cellLayout)).avatarPosition1.origin.y - 10,
                                       ((CommentDetailLayout *)(self.cellLayout)).avatarPosition1.size.width + 20,
                                       ((CommentDetailLayout *)(self.cellLayout)).avatarPosition1.size.height + 20), point)) {
        NSLog(@"hi has hitted %ld row",(long)self.indexPath.row);
        [self didClickedCommentButton:Clink_Type_Six];
    }
    
    //click share
    if (CGRectContainsPoint(CGRectMake(((CommentDetailLayout *)(self.cellLayout)).sharePosition.origin.x - 10,
                                       ((CommentDetailLayout *)(self.cellLayout)).sharePosition.origin.y - 10,
                                       ((CommentDetailLayout *)(self.cellLayout)).sharePosition.size.width + 20,
                                       ((CommentDetailLayout *)(self.cellLayout)).sharePosition.size.height + 20), point)) {
        NSLog(@"hi has hitted %ld row",(long)self.indexPath.row);
        [self didClickedCommentButton:Clink_Type_Two];
    }
    
    //click good
    if (CGRectContainsPoint(CGRectMake(((CommentDetailLayout *)(self.cellLayout)).goodPosition.origin.x - 10,
                                       ((CommentDetailLayout *)(self.cellLayout)).goodPosition.origin.y - 10,
                                       ((CommentDetailLayout *)(self.cellLayout)).goodPosition.size.width + 20,
                                       ((CommentDetailLayout *)(self.cellLayout)).goodPosition.size.height + 20), point)) {
        NSLog(@"hi has hitted %ld row",(long)self.indexPath.row);
        [self didClickedCommentButton:Clink_Type_Three];
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

- (void)setCellLayout:(CellLayout *)cellLayout {
    if (_cellLayout == cellLayout) {
        return;
    }
    _cellLayout = (CommentDetailLayout *)cellLayout;
    self.asyncDisplayView.layout = cellLayout;
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
    if (self.indexPath.row == 0) {
        CGContextMoveToPoint(context, 0.0f, self.bounds.size.height);
        CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height);
        CGContextSetLineWidth(context, 0.3f);
        CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
        CGContextStrokePath(context);
    }
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
