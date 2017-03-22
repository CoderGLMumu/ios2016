//
//  QuestionDetailCommentCell.h
//  JZBRelease
//
//  Created by cl z on 16/9/8.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LWAsyncDisplayView.h"
#import "TableViewCellDelegate.h"
#import "LWDefine.h"
#import "LWImageStorage.h"
#import "QuestionsDetailLayout.h"
#import "SimpleInfoView.h"
#import "CommentTabItemBarView.h"
#import "recorderPlayView.h"

@interface QuestionDetailCommentCell : UITableViewCell
@property (nonatomic,weak) id <TableViewCellDelegate> delegate;
@property (nonatomic,strong) QuestionsDetailLayout *cellLayout;
@property (nonatomic,strong) SimpleInfoView *infoView;
@property (nonatomic,strong) CommentTabItemBarView *tabItemBarView;
@property (nonatomic,strong) recorderPlayView *audioPlayView;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,assign) BOOL isDetail;
@end
