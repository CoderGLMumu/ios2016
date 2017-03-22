//
//  QuestionsDetailLayout.h
//  JZBRelease
//
//  Created by cl z on 16/9/7.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "CellLayout.h"
#import "QuestionsModel.h"
@interface QuestionsDetailLayout : CellLayout
@property (nonatomic,assign) CGRect avatarPosition1;
@property (nonatomic,assign) CGRect is_like_frame;
@property (nonatomic, strong) QuestionsModel *questionsModel;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSMutableArray *imageAry;

- (id)initWithContainer:(LWStorageContainer *)container
                  Model:(QuestionsModel *)questionsModel
          dateFormatter:(NSDateFormatter *)dateFormatter
                  index:(NSInteger)index
               IsDetail:(BOOL)isDetail;
@end
