//
//  BQRootCell.m
//  JZBRelease
//
//  Created by zjapple on 16/6/22.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "BBActivityCell.h"
#import "Defaults.h"
#import "UIImageView+WebCache.h"


@interface BBActivityCell()<LWAsyncDisplayViewDelegate>

@property (nonatomic,strong) LWAsyncDisplayView* asyncDisplayView;

@end

@implementation BBActivityCell

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
    
    
    //click avatar
    if (CGRectContainsPoint(CGRectMake(((ActivityLayout *)(self.cellLayout)).avatarPosition1.origin.x - 10,
                                       ((ActivityLayout *)(self.cellLayout)).avatarPosition1.origin.y - 10,
                                       ((ActivityLayout *)(self.cellLayout)).avatarPosition1.size.width + 20,
                                       ((ActivityLayout *)(self.cellLayout)).avatarPosition1.size.height + 20), point)) {
        NSLog(@"hi has hitted %ld row",(long)self.indexPath.row);
        [self didClickedCommentButton:Clink_Type_One];
    }
    
    //click share
    if (CGRectContainsPoint(CGRectMake(((ActivityLayout *)(self.cellLayout)).banaerPosition.origin.x - 10,
                                       ((ActivityLayout *)(self.cellLayout)).banaerPosition.origin.y - 10,
                                       ((ActivityLayout *)(self.cellLayout)).banaerPosition.size.width + 20,
                                       ((ActivityLayout *)(self.cellLayout)).banaerPosition.size.height + 20), point)) {
        NSLog(@"hi has hitted %ld row",(long)self.indexPath.row);
        [self didClickedCommentButton:Clink_Type_Two];
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
    _cellLayout = (ActivityLayout *)cellLayout;
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
//    if (self.isDetail) {
//        CGContextMoveToPoint(context, 0.0f, self.bounds.size.height);
//        CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height);
//        CGContextSetLineWidth(context, 0.3f);
//        CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
//        CGContextStrokePath(context);
//        
//    }
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
