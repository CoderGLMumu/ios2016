//
//  QuestionsLayout.h
//  JZBRelease
//
//  Created by cl z on 16/7/23.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "CellLayout.h"
#import "QuestionsModel.h"
#import "DetailListModel.h"
#import "LWTextParser.h"
#import "LWDefine.h"
#import "Defaults.h"
@interface QuestionsLayout : CellLayout

@property (nonatomic,assign) CGRect focusPostion;
@property (nonatomic,assign) CGRect avatarPosition1;
@property (nonatomic, strong) QuestionsModel *questionsModel;
@property (nonatomic, strong) NSMutableArray *imageAry;

- (id)initWithContainer:(LWStorageContainer *)container
                  Model:(QuestionsModel *)questionsModel
          dateFormatter:(NSDateFormatter *)dateFormatter
                  index:(NSInteger)index
               IsDetail:(BOOL)isDetail
               IsLast:(BOOL)isLast;

@end
