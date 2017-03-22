//
//  QuestionDetailCommentCell.m
//  JZBRelease
//
//  Created by cl z on 16/9/8.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "QuestionDetailCommentCell.h"
#import "QuestionEvaluateModel.h"
#import "HSDownloadManager.h"
#import "Masonry.h"
@interface QuestionDetailCommentCell()<LWAsyncDisplayViewDelegate>{
    UIView *intevalView;
}

@property (nonatomic,strong) LWAsyncDisplayView* asyncDisplayView;

@end

@implementation QuestionDetailCommentCell

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
    //click comment
    if (CGRectContainsPoint(CGRectMake(self.cellLayout.commentPosition.origin.x - 15,
                                       self.cellLayout.commentPosition.origin.y - 15,
                                       self.cellLayout.commentPosition.size.width + 30,
                                       self.cellLayout.commentPosition.size.height + 30), point)) {
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
    
    //click good
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
    QuestionEvaluateModel *evaluateModel = [QuestionEvaluateModel mj_objectWithKeyValues:[ _cellLayout.questionsModel.evaluate objectAtIndex:_cellLayout.index]];
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, evaluateModel.inteval * 7.333);

    __weak typeof (self) wself = self;
    if (!self.infoView) {
        self.infoView = [SimpleInfoView getInfoShowViewWithData:_cellLayout.questionsModel.user WithFrame:frame];
        if (_cellLayout.questionsModel.reward_eval_id && [_cellLayout.questionsModel.reward_eval_id isEqualToString:evaluateModel.eval_id] ) {
            self.infoView.isCaina = YES;
        }else{
            self.infoView.isCaina = NO;
        }
        [self.infoView updateFrameWithData:evaluateModel.user];
        self.infoView.returnAction = ^(NSInteger tag){
            if ([wself.delegate respondsToSelector:@selector(tableViewCell:didClickedCommentWithCellLayout:atIndexPath:clinkType:)]) {
                [wself.delegate tableViewCell:wself didClickedCommentWithCellLayout:wself.cellLayout atIndexPath:wself.indexPath clinkType:Clink_Type_Six];
            }
        };
        [self.contentView addSubview:self.infoView];
        
    }else{
        if (_cellLayout.questionsModel.reward_eval_id && [_cellLayout.questionsModel.reward_eval_id isEqualToString:evaluateModel.eval_id]) {
            self.infoView.isCaina = YES;
        }else{
            self.infoView.isCaina = NO;
        }
        [self.infoView updateFrameWithData:evaluateModel.user];
    }
    
    if ([evaluateModel.user.uid isEqualToString:[LoginVM getInstance].users.uid]) {
        self.infoView.delBtn.hidden = NO;
    }else{
        self.infoView.delBtn.hidden = YES;
    }
    
    self.asyncDisplayView.layout = cellLayout;
    [self.asyncDisplayView setFrame:CGRectMake(0, evaluateModel.inteval * 7.333, SCREEN_WIDTH, cellLayout.cellHeight)];
    
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    if (appDelegate.audioSwitch) {
        //如果有语音，加载语音audioPlayView
        if (evaluateModel.audio && evaluateModel.audio.length > 0) {
            if (!self.audioPlayView) {
                self.audioPlayView = [[recorderPlayView alloc]initWithContent:nil];
                if (evaluateModel.inteval != 4) {
                    [self.audioPlayView setFrame:CGRectMake(0, cellLayout.cellHeight + 34, GLScreenW, 40)];
                }else{
                    [self.audioPlayView setFrame:CGRectMake(0, cellLayout.cellHeight + 24, GLScreenW, 30)];
                }
                
                [self.contentView addSubview:self.audioPlayView];
            }
            if (evaluateModel.audio_length && evaluateModel.audio_length.length > 0) {
                self.audioPlayView.playLocalStr = [[ValuesFromXML getValueWithName:@"Audio_Absolute_Address" WithKind:2] stringByAppendingPathComponent: evaluateModel.audio];
                NSString *timeStr;
                NSInteger minute = [evaluateModel.audio_length integerValue] / 60;
                NSInteger seconds = [evaluateModel.audio_length integerValue] % 60;
                if (minute >= 1) {
                    timeStr = [NSString stringWithFormat:@"%ld' %ld''",minute,seconds];
                    [self.audioPlayView.rightLabel1 setText:timeStr];
                    self.audioPlayView.imageBGBig.hidden = NO;
                    self.audioPlayView.imageBGSmall.hidden = YES;
                }else{
                    timeStr = [NSString stringWithFormat:@"%ld''",seconds];
                    [self.audioPlayView.rightLabel0 setText:timeStr];
                    self.audioPlayView.imageBGBig.hidden = YES;
                    self.audioPlayView.imageBGSmall.hidden = NO;
                }
                self.audioPlayView.hidden = NO;
            }
        }else{
            if (self.audioPlayView) {
                self.audioPlayView.hidden = YES;
            }
            
        }
    }
    
    
    if (!self.tabItemBarView) {
        
        self.tabItemBarView = [CommentTabItemBarView getCommentTabItemBarViewWithFrame:CGRectMake(0, cellLayout.cellHeight + evaluateModel.inteval * 7.333, SCREEN_WIDTH, evaluateModel.inteval * 7.333) IsQuestionOwner:NO];
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
    
    if (_cellLayout.questionsModel.reward_eval_id) {
        self.tabItemBarView.isQustionOwner = NO;
    }else{
        if ([_cellLayout.questionsModel.user.uid isEqualToString:[[LoginVM getInstance] readLocal]._id]) {
            self.tabItemBarView.isQustionOwner = YES;
        }else{
            self.tabItemBarView.isQustionOwner = NO;
        }
    }
    if (self.audioPlayView && !self.audioPlayView.hidden) {
        if (evaluateModel.inteval != 4) {
            [self.tabItemBarView setFrame:CGRectMake(0, self.audioPlayView.frame.origin.y + self.audioPlayView.frame.size.height + 18, SCREEN_WIDTH, evaluateModel.inteval * 7.333)];
        }else{
            [self.tabItemBarView setFrame:CGRectMake(0, self.audioPlayView.frame.origin.y + self.audioPlayView.frame.size.height + 14, SCREEN_WIDTH, evaluateModel.inteval * 7.333)];
        }
        
    }else{
        [self.tabItemBarView setFrame:CGRectMake(0, cellLayout.cellHeight + evaluateModel.inteval * 7.333, SCREEN_WIDTH, evaluateModel.inteval * 7.333)];
    }
    
    [self.tabItemBarView updateViews:evaluateModel];
    if (!intevalView) {
        intevalView = [[UIView alloc]initWithFrame:CGRectMake(0, self.tabItemBarView.frame.origin.y + self.tabItemBarView.frame.size.height, SCREEN_WIDTH, evaluateModel.inteval * 1.67)];
        [intevalView setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"f2f2f2"]];
        [self.contentView addSubview:intevalView];
    }
    [intevalView setFrame:CGRectMake(0, self.tabItemBarView.frame.origin.y + self.tabItemBarView.frame.size.height, SCREEN_WIDTH, evaluateModel.inteval * 1.67)];
}



- (void)zanBtnAction{
    if ([self.delegate respondsToSelector:@selector(tableViewCell:didClickedCommentWithCellLayout:atIndexPath:clinkType:)]) {
        [self.delegate tableViewCell:self didClickedCommentWithCellLayout:self.cellLayout atIndexPath:self.indexPath clinkType:Clink_Type_Two];
    }
}

- (void)rewardBtnAction{
    if ([self.delegate respondsToSelector:@selector(tableViewCell:didClickedCommentWithCellLayout:atIndexPath:clinkType:)]) {
        [self.delegate tableViewCell:self didClickedCommentWithCellLayout:self.cellLayout atIndexPath:self.indexPath clinkType:Clink_Type_Three];
    }
}

- (void)commentBtnAction{
    if ([self.delegate respondsToSelector:@selector(tableViewCell:didClickedCommentWithCellLayout:atIndexPath:clinkType:)]) {
        [self.delegate tableViewCell:self didClickedCommentWithCellLayout:self.cellLayout atIndexPath:self.indexPath clinkType:Clink_Type_One];
    }
}

- (void)cainaBtnAction{
    if ([self.delegate respondsToSelector:@selector(tableViewCell:didClickedCommentWithCellLayout:atIndexPath:clinkType:)]) {
        [self.delegate tableViewCell:self didClickedCommentWithCellLayout:self.cellLayout atIndexPath:self.indexPath clinkType:Clink_Type_Four];
    }
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
       // _asyncDisplayView.delegate = self;
    }
    return _asyncDisplayView;
}

@end
