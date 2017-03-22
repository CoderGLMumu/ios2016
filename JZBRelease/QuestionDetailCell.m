//
//  QuestionDetailCell.m
//  JZBRelease
//
//  Created by cl z on 16/9/7.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "QuestionDetailCell.h"

@interface QuestionDetailCell()<LWAsyncDisplayViewDelegate>{
    UIView *intevalView;
}

@property (nonatomic,strong) LWAsyncDisplayView* asyncDisplayView;

@end

@implementation QuestionDetailCell

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
    point = CGPointMake(point.x, point.y - 44);
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
     //point = CGPointMake(point.x, point.y + 44);
    //click focuesed
    if (CGRectContainsPoint(CGRectMake(self.cellLayout.is_like_frame.origin.x - 15,
                                       self.cellLayout.is_like_frame.origin.y - 15,
                                       self.cellLayout.is_like_frame.size.width + 30,
                                       self.cellLayout.is_like_frame.size.height + 30), point)) {
        NSLog(@"hi has hitted %ld row",(long)self.indexPath.row);
        [self didClickedCommentButton:Clink_Type_One];
    }
    
    //click avatar
    if (CGRectContainsPoint(CGRectMake(((QuestionsDetailLayout *)(self.cellLayout)).avatarPosition1.origin.x - 10,
                                       ((QuestionsDetailLayout *)(self.cellLayout)).avatarPosition1.origin.y - 10,
                                       ((QuestionsDetailLayout *)(self.cellLayout)).avatarPosition1.size.width + 20,
                                       ((QuestionsDetailLayout *)(self.cellLayout)).avatarPosition1.size.height + 20), point)) {
        NSLog(@"hi has hitted %ld row",(long)self.indexPath.row);
        [self didClickedCommentButton:Clink_Type_Six];
    }
    
    //click share
    if (CGRectContainsPoint(CGRectMake(((QuestionsDetailLayout *)(self.cellLayout)).sharePosition.origin.x - 10,
                                       ((QuestionsDetailLayout *)(self.cellLayout)).sharePosition.origin.y - 10,
                                       ((QuestionsDetailLayout *)(self.cellLayout)).sharePosition.size.width + 20,
                                       ((QuestionsDetailLayout *)(self.cellLayout)).sharePosition.size.height + 20), point)) {
        NSLog(@"hi has hitted %ld row",(long)self.indexPath.row);
        [self didClickedCommentButton:Clink_Type_Two];
    }
    
    //click focused
    if (CGRectContainsPoint(CGRectMake(((QuestionsDetailLayout *)(self.cellLayout)).goodPosition.origin.x - 10,
                                       ((QuestionsDetailLayout *)(self.cellLayout)).goodPosition.origin.y - 10,
                                       ((QuestionsDetailLayout *)(self.cellLayout)).goodPosition.size.width + 20,
                                       ((QuestionsDetailLayout *)(self.cellLayout)).goodPosition.size.height + 20), point)) {
        NSLog(@"hi has hitted %ld row",(long)self.indexPath.row);
        [self didClickedCommentButton:Clink_Type_Three];
    }
    
    //click good
    if (CGRectContainsPoint(CGRectMake(((QuestionsDetailLayout *)(self.cellLayout)).rewardPosition.origin.x - 10,
                                       ((QuestionsDetailLayout *)(self.cellLayout)).rewardPosition.origin.y - 10,
                                       ((QuestionsDetailLayout *)(self.cellLayout)).rewardPosition.size.width + 20,
                                       ((QuestionsDetailLayout *)(self.cellLayout)).rewardPosition.size.height + 20), point)) {
        NSLog(@"hi has hitted %ld row",(long)self.indexPath.row);
        [self didClickedCommentButton:Clink_Type_Four];
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
    _cellLayout = (QuestionsDetailLayout *)cellLayout;
    QuestionsModel *questionModel = _cellLayout.questionsModel;
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, questionModel.inteval * 7.333);
    if (!self.infoView) {
        self.infoView = [SimpleInfoView getInfoShowViewWithData:_cellLayout.questionsModel.user WithFrame:frame];
//        if ([_cellLayout.questionsModel.type integerValue] == 1) {
//            self.infoView.isEmergence = YES;
//        }
        [self.infoView updateFrameWithData:_cellLayout.questionsModel.user];
        [self.contentView addSubview:self.infoView];
        __weak typeof (self) wself = self;
        self.infoView.returnAction = ^(NSInteger tag){
            if ([wself.delegate respondsToSelector:@selector(tableViewCell:didClickedCommentWithCellLayout:atIndexPath:clinkType:)]) {
                [wself.delegate tableViewCell:wself didClickedCommentWithCellLayout:wself.cellLayout atIndexPath:wself.indexPath clinkType:Clink_Type_Six];
            }
        };
        
    }else{
//        if ([_cellLayout.questionsModel.type integerValue] == 1) {
//            self.infoView.isEmergence = YES;
//        }
        [self.infoView updateFrameWithData:_cellLayout.questionsModel.user];
    }
    self.asyncDisplayView.layout = cellLayout;
    [self.asyncDisplayView setFrame:CGRectMake(0, questionModel.inteval * 7.333, SCREEN_WIDTH, cellLayout.cellHeight)];
    if (!intevalView) {
        intevalView = [[UIView alloc]initWithFrame:CGRectMake(0, cellLayout.cellHeight, SCREEN_WIDTH, 10)];
        [intevalView setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"f2f2f2"]];
        [self.contentView addSubview:intevalView];
    }
    [intevalView setFrame:CGRectMake(0, cellLayout.cellHeight + self.infoView.frame.size.height, SCREEN_WIDTH, questionModel.inteval * 1.67)];
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
    if (self.isDetail) {
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
        _asyncDisplayView = [[LWAsyncDisplayView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 0) maxImageStorageCount:15];
        _asyncDisplayView.delegate = self;
    }
    return _asyncDisplayView;
}


@end
